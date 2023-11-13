bash
#!/bin/bash

# Get current date
now=$(date +%s)

# For each branch
for branch in $(git branch); do
  # Get the last commit date on this branch
  last_commit=$(git show --format="%ci" $branch | head -n 1)

  # Convert commit date to Unix timestamp
  last_commit_unix=$(date -d"$last_commit" +%s)

  # Calculate age of branch in days
  age=$(( ($now - $last_commit_unix) / (60*60*24) ))

  # If branch is older than 90 days
  if [ $age -gt 90 ]; then
    echo "Archiving and deleting $branch"
    
    # Create a backup tag before deleting
    git tag archive/$branch $branch
    
    # Delete the branch
    #git branch -d $branch
  fi
done
