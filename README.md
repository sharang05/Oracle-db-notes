# oracleDBmonitoring

Follow below steps to create new branch and merge with master branch

1. $ git branch (check which branches exist and which one is currently active (prefixed with *). This helps you avoid creating duplicate/confusing branch name)
 2. $ git branch <new_branch> (creates new branch)
 3. $ git checkout new_branch
 4. $ git add . (After making changes in the current branch)
 5. $ git commit -m "type commit msg here"
 6. $ git checkout master (switch to master branch so that merging with new_branch can be done)
 7. $ git merge new_branch (starts merging)
 8. $ git push origin master (push to the remote server)
