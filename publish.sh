#!/bin/bash

set -ex
  [[ -d _book ]]
  [[ $TRAVIS_REPO_SLUG ]]
  [[ $TRAVIS_PULL_REQUEST ]]
  [[ $GH_TOKEN ]]
set +ex

if [[ $TRAVIS_PULL_REQUEST == false ]]; then
  COMMIT_MSG="Add generated pages"
  DEST="./"
else
  COMMIT_MSG="Add preview for #$TRAVIS_PULL_REQUEST"
  DEST="pr$TRAVIS_PULL_REQUEST/"
fi

for ((I=0; I<3; I++)); do
  rm -rf _publish/
  git clone --depth=1 https://github.com/$TRAVIS_REPO_SLUG -b gh-pages _publish/
  pushd _publish
    touch .nojekyll

    git config user.name 'ALICE Doc Bot'
    git config user.email 'alice-doc-bot@cern.ch'

    rsync -a --delete --exclude '**/.git' --exclude '**/pr*' ../_book/ $DEST
    git add --all -v
    git commit -m "$COMMIT_MSG"

    git push https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG gh-pages && break
    echo Pushing has failed, maybe some new changes were pushed. Retrying in 5 seconds...
    sleep 5
  popd
done
