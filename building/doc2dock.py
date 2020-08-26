#!/usr/bin/env python
from __future__ import print_function
import re
from sys import argv, exit
from os import remove, environ
from os.path import dirname, basename, isfile
from subprocess import call

def create_dockerfile(fn):
  in_runinline = False
  in_codeblock = False
  uploadname = ""
  dockerfile = []

  runbuf = []
  runfmt = lambda x: "RUN %s" % " && \\\n    ".join(x)

  if fn[0] != "/":
    fn = "./" + fn
  outfile = dirname(fn) + "/Dockerfile_" + basename(fn)
  try:
    # Remove extension from outfile
    outfile = outfile[0:outfile.rindex(".")]
  except ValueError:
    pass

  with open(fn) as fp:
    for line in fp.readlines():
      line = line.rstrip()
      if in_codeblock:
        if line == "```":
          # End of codeblock
          in_codeblock = False
          in_runinline = False
        else:
          runbuf.append(line)
      elif in_runinline and line.startswith("```"):
        # Start of codeblock
        in_codeblock = True
      else:
        m = re.search('<!-- Dockerfile (([A-Z_]+)( .*)?) -->', line)
        if m:
          cmd = m.group(2)
          arg = m.group(3).lstrip() if m.group(3) else ""
          if cmd == "RUN_INLINE":
            in_runinline = True
          elif cmd == "RUN":
            runbuf.append(arg)
          elif cmd == "UPLOAD_NAME":  # docker build . -t <UPLOAD_NAME>
            uploadname = arg
          else:  # insert Docker command ditto
            if runbuf:
              dockerfile.append(runfmt(runbuf))
              runbuf = []
            dockerfile.append("%s %s" % (cmd, arg))

  if runbuf:
    dockerfile.append(runfmt(runbuf))

  if dockerfile:
    with open(outfile, "w") as fp:
      fp.write("# Automatically generated from %s\n" % fn)
      for line in dockerfile:
        fp.write(line + "\n")

  return (outfile, uploadname)

errcount = 0
for fn in argv[1:]:
  if not isfile(fn):
    print("WARNING: skipping %s, does not exist" % fn)
    continue
  print("Processing %s..." % fn)
  dockerfile,uploadname = create_dockerfile(fn)
  if uploadname:
    with open(dockerfile) as fp:
      print(fp.read().strip())
    print("# End of Dockerfile for %s" % uploadname)
    if call(["docker", "build", "-f", dockerfile, "-t", uploadname, "."]) == 0:
      if environ.get("TRAVIS_PULL_REQUEST", "true") == "false" and environ.get("TRAVIS_BRANCH", "") == "master":
        if call(["docker", "push", uploadname]) == 0:
          try: remove(dockerfile)
          except: pass
        else:
          print("ERROR: cannot push %s" % uploadname)
          errcount = errcount+1
      else:
        print("WARNING: not pushing Docker image %s, not building master branch" % uploadname)
    else:
      print("ERROR: cannot create %s from %s" % (uploadname, dockerfile))
      errcount = errcount+1
  else:
    print("%s: no Dockerfile generated, skipping" % fn)

exit(1 if errcount else 0)
