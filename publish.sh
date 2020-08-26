#!/bin/bash -ex

cd "$(dirname "$0")"

[[ -r env.sh ]] && source env.sh &> /dev/null

PUSHURL=$(git remote get-url --push origin)

pushd _book
  git init .
  git config user.name 'ALICE Doc Bot'
  git config user.email 'alice-doc-bot@cern.ch'
  git add --all
  git commit -m 'Update site'
  git push -f $PUSHURL HEAD:gh-pages
popd
