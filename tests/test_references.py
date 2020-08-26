import os
import re
import unittest


class TestRefsInMarkdownFiles(unittest.TestCase):
    def test_refs(self):
        pat = r'```.*?```|`.*?`|\[[^\]]*\]\(([^\)]+)\)'
        urlregexp = re.compile(
            r'^(?:http|ftp)s?://' # http:// or https://
            r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
            r'localhost|' #localhost...
            r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
            r'(?::\d+)?' # optional port
            r'(?:/?|[/?]\S+)$', re.IGNORECASE)
        checked = set()
        to_check = ['SUMMARY.md']
        while to_check:
            path = to_check.pop()
            root = os.path.dirname(path)
            self.assertTrue(os.path.exists(path),
                            'File `{}` does not exists.'.format(path))
            checked.add(path)
            if path.endswith('.md'):
                with open(path) as f:
                    matches = re.finditer(pat, f.read(), re.MULTILINE | re.DOTALL)
                    for match in matches:
                        if len(match.groups()) == 0 or match.group(1) == None:
                            continue
                        print(match.group(1))
                        if urlregexp.match(match.group(1)):
                            continue
                        f = os.path.normpath(os.path.join(root, match.group(1).split('#', 1)[0]))
                        if f not in checked:
                            to_check.append(f)
