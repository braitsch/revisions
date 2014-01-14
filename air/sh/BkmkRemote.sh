#!/bin/bash
source `dirname $0`/Include.sh

function clone
{
	cd "$2"; git clone "$1" --template="$templates"
}

function pushBranch
{
	doGit push $1 $2
}

function attemptHttpsAuth
{
# $1-url $2 branch-name
	doGit push --dry-run $1 $2	
}

function getRemoteFiles
{
	doGit fetch --all
}

function deleteRemoteBranchFromServer
{
	doGit push $1 :$2
}

# call the requested method #
tree=${args[$#-1]}
gdir=${args[$#-2]}/.git
$1 "${args[@]}"