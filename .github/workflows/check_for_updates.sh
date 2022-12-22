#!/bin/bash
set -euo pipefail

UPSTREAM="https://github.com/heroku/heroku-buildpack-go.git"
REMOTE=$(git remote -v)
if [[ "${REMOTE}" != *"${UPSTREAM}"* ]]; then
    git remote add upstream "${UPSTREAM}"
fi

git fetch upstream
git pull origin main:upstream 1> /dev/null

if [[ "$(git status --porcelain)" ]]; then
    LATEST_COMMIT=$(git rev-parse @{u})

    git add .
    git commit -m "Github action - New upstream heroku buildpack changes - ${LATEST_COMMIT}"
    gh pr create \
        --base origin \
        --title "New upstream heroku buildpack changes - ${LATEST_COMMIT}" \
        --body "Most recent upstream changes"
else
    echo "repo is up to date with remote"
fi
