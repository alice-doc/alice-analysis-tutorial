#!/bin/bash

source env.sh &> /dev/null  # for local tests

set -x
  [[ $TRAVIS_REPO_SLUG ]]    || exit 1
  [[ $TRAVIS_PULL_REQUEST ]] || exit 1
  [[ $GH_TOKEN ]]            || exit 1
set +x

function gh() {
  curl -s                                                  \
       -H "Authorization: token ${GH_TOKEN}"               \
       -X $1                                               \
       https://api.github.com/repos/${TRAVIS_REPO_SLUG}$2
}

rm -rf _publish _prs
mkdir _publish

PRS=$(gh GET /pulls | python -c "$(printf "import json, sys\nd=json.load(sys.stdin)\nfor p in d: print p['number']")")
for PR in current $PRS; do

  if [[ $PR == current ]]; then
    # Build current directory. Errors here are fatal
    SRC="."
    DST="."
  else
    # Build all PRs. Errors are non-fatal
    SRC="_prs/pr$PR"
    DST="pr$PR"
    mkdir -p $SRC
    git clone --reference=$PWD https://github.com/$TRAVIS_REPO_SLUG $SRC || continue
    pushd $SRC
      git fetch origin pull/$PR/head:pr$PR || continue
      git checkout pr$PR || continue
    popd
  fi

  ERR=0
  pushd $SRC
    rm -rf _book
    gitbook install && gitbook build || ERR=1
  popd
  [[ $ERR == 0 ]] && rsync -a --delete --exclude '**/.git' --exclude '**/pr*' $SRC/_book/ _publish/$DST/
  [[ $ERR == 1 && $PR != current ]] && rm -rf _publish/$DST
  [[ $ERR == 1 && $PR == current ]] && exit 1  # fatal

done

# Publish all
pushd _publish
  git init .
  git config user.name 'ALICE Doc Bot'
  git config user.email 'alice-doc-bot@cern.ch'
  git add --all
  git commit -m 'Update site'
  git push -f https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG HEAD:gh-pages || exit 1  # fatal
popd

exit 0
