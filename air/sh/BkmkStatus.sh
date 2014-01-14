#!/bin/bash
source `dirname $0`/Include.sh

function getHistory
{
	doGit log --no-merges --pretty=format:"%H-#-%ar-#-%an-#-%ae-#-%s-##-"
}

function getFavorites
{
	doGit tag -l '!important*'
}

function cherryBranch
{
	doGit cherry $1 $2	
}

function getTrackedFiles
{
	doGit ls-files -c	
}

function getUntrackedFiles
{
	doGit ls-files --other --exclude-standard
}

function getModifiedFiles
{
	doGit ls-files -m
}

function getIgnoredFiles
{	
	doGit ls-files --others --ignored --exclude-standard
}

# call the requested method #
tree=${args[$#-1]}
gdir=${args[$#-2]}/.git
$1 "${args[@]}"