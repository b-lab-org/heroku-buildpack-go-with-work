#!/bin/bash
set -euox pipefail

UPSTREAM="https://github.com/heroku/heroku-buildpack-go.git"
REMOTE=$(git remote -v)
if [[ "${REMOTE}" != *"${UPSTREAM}"* ]]; then
    git remote add upstream "${UPSTREAM}"
fi

OLD_COMMIT=$(git rev-parse @{u})
git fetch --all
git pull -s recursive -X theirs upstream main 1> /dev/null
LATEST_COMMIT=$(git rev-parse @{u})

if [[ "${OLD_COMMIT}" != "${LATEST_COMMIT}" ]]; then
    git add .
    git commit -m "Github action - New upstream heroku buildpack changes - ${LATEST_COMMIT}"
    gh pr create \
        --base origin \
        --title "New upstream heroku buildpack changes - ${LATEST_COMMIT}" \
        --body "Most recent upstream changes"
else
    echo "repo is up to date with remote"
fi
