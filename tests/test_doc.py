import os
import re
import unittest

class TestDoc(unittest.TestCase):

  def test_refs(self):
    pat = re.compile(r'\[[^\]]*\]\(([^\)]+)\)')
    checked = set()
    to_check = [ "SUMMARY.md" ]
    while to_check:
      path = to_check.pop()
      root = os.path.dirname(path)
      self.assertTrue(os.path.exists(path),
                      "File `{}` does not exists.".format(path))
      checked.add(path)
      if path.endswith(".md"):
        with open(path) as f:
          refs = pat.findall(f.read())
          files = [ os.path.normpath(os.path.join(root, ref.split('#', 1)[0]))
                    for ref in refs if not ':' in ref ]
          to_check += [f for f in files if f not in checked]

  def test_length(self):
    for root,dirs,files in os.walk("."):
      for f in files:
        if not f.endswith(".md"):
          continue
        f = os.path.join(root, f)
        with open(f) as fp:
          for line in fp.readlines():
            self.assertLessEqual(len(line), 100, "%s has lines longer than 100 cols: %s" % (f, line))
