set -x
now=$(date +%s)
threshold=$(date -d '6 months ago' +%s)

for k in $(git branch -a | sed s/^..//); do
    commit_date=$(git log --color=always -1 --pretty=format:%ci $k)

    # Check if commit date is not empty
    if [ -n "$commit_date" ]; then
        commit_date_unix=$(date -d"$commit_date" +%s)

        if [ $commit_date_unix -lt $threshold ]; then
            echo -e $(git log --color=always -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k --)\\t"$k"

            # Create an archive tag
            git tag archive/$k $k

            # Rename the branch to indicate it's archived
            git branch -m "$k" "archive/$k"
	     
	    echo "$k"

            # Delete the original branch locally
            git branch -d "$k"

            # Delete the original branch remotely
            #git push origin --delete "$k"
	    #git branch -d -r "$k"

	    #git push --tags

	    git push origin --delete "$k"
        fi
    fi
done | sort

# Remove the original remote branches
#git remote prune origin

# Push the changes to the remote repository
git push origin --tags --force --prune

