old_branches=$(git for-each-ref refs/heads --sort=-committerdate --format='%(refname)' | while read branch; do
    commit_date=$(git log -1 --pretty=%cd --date=format:%s "$branch")
    if [[ "$commit_date" < "$three_months_ago" ]]; then
        echo "$branch"
    fi
done)

