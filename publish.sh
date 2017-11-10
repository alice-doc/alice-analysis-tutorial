#!/bin/bash -ex

cd "$(dirname "$0")"

[[ -r env.sh ]] && source env.sh &> /dev/null

[[ $TRAVIS_REPO_SLUG ]]             || exit 1
[[ $TRAVIS_PULL_REQUEST == false ]] || exit 1
[[ $GH_TOKEN ]]                     || exit 1

pushd _book
  git init .
  git config user.name 'ALICE Doc Bot'
  git config user.email 'alice-doc-bot@cern.ch'
  git add --all
  git commit -m 'Update site'
  git push -f https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG HEAD:gh-pages
popd
