#!/bin/bash
source `dirname $0`/Include.sh

# never forget all git sh scripts must be called from within the worktree!!
function getStash
{
	cd $tree; doGit stash list
}

function getRemotes
{
	doGit remote -v
}

function getLocalBranches
{	
	doGit branch
}

function getRemoteBranches
{	
	doGit branch -r
}

# call the requested method #
tree=${args[$#-1]}
gdir=${args[$#-2]}/.git
$1 "${args[@]}"