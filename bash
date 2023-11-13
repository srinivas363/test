#!/bin/bash

# Get the current date
current_date=$(date +%Y-%m-%d)

# Calculate the date 3 months ago
three_months_ago=$(date -d "$current_date - 3 months" +%Y-%m-%d)

# Get all the branches older than 3 months
old_branches=$(git for-each-ref refs/heads --sort=-committerdate --format='%(refname)' | while read branch; do
    commit_date=$(git log -1 --pretty=%cd --date=format:%s "$branch")
    if [[ "$commit_date" < "$three_months_ago" ]]; then
        echo "$branch"
    fi
done)

# Archive the old branches
for branch in $old_branches; do
    git checkout "$branch"
    git archive --format=tar.gz --output="/path/to/archives/$branch.tar.gz" .
    git checkout main
done
