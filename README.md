Welcome to the ALICE Analysis Tutorial documentation
====================================================

[![Build Status](https://travis-ci.org/alice-doc/alice-analysis-tutorial.svg?branch=master)](https://travis-ci.org/alice-doc/alice-analysis-tutorial)

This is a community-contributed place where we collect all our documentation. Every ALICE member can
contribute, and the Analysis Tutorial Committee will review every contribution.


## Where can I see the documentation online?

Documentation is published on GitHub pages at the following address:

> https://alice-doc.github.io/alice-analysis-tutorial/


## How can I contribute to the documentation?

First off you need a [GitHub](https://github.com) account. [Fork the
**alice-doc/alice-analysis-tutorial** repository](https://github.com/alice-doc/alice-analysis-tutorial/fork), then clone it to your
laptop:

```bash
git clone https://github.com/alice-doc/alice-analysis-tutorial
cd alice-analysis-tutorial/
git remote add <my_username> https://github.com/<my_username>/alice-analysis-tutorial
```

Documentation is written in [Markdown](https://daringfireball.net/projects/markdown/syntax) and it
is generated using [GitBook](https://www.gitbook.com/). You need to install GitBook first. GitBook
is a NodeJS package, meaning that you need `npm` to install it. You can get `npm` easily.

On Ubuntu:

```bash
sudo apt install npm
```

On macOS (assuming you have [Homebrew](https://brew.sh/):

```bash
brew install npm
```

On CentOS 7 (you need [EPEL](https://fedoraproject.org/wiki/EPEL) enabled):

```bash
sudo yum install npm
```

Once `npm` is installed, you can install GitBook:

```bash
sudo npm install -g gitbook-cli
```

**Do not use `sudo` on macOS.**

Once GitBook is installed, you should find it in your `$PATH`, check it with:

```bash
type gitbook
```

To preview the documentation pages locally while you are editing them, move to the repository's root
directory and run:

```bash
cd alice-analysis-tutorial/
make serve
```

The command will not exit and a local website will be visible at the following address:

> http://localhost:4000

The website uses [GitBook](https://www.gitbook.com/). Editing the pages using your favorite text
editor: whenever you save, the page currently opened in your local preview will be refreshed
automatically.

When you are happy with your modifications, commit them, push them to your repository and open a
pull request, for instance:

```bash
git commit -a -m 'I am happy with my doc'
git push <my_username>
```

then navigate to your GitHub repository online to open a pull request.
