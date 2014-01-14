#!/bin/bash
source `dirname $0`/Include.sh

function commit
{
	doGit add --all
	doGit commit -m "$1" -q
}

# -- BRANCHING -- #

function addBranch
{
	doGit checkout -b $1 $2
}

function setBranch
{
	doGit checkout -q $1
}

function delBranch
{
	doGit branch -D $1
}

function renameBranch
{
	doGit branch -m $1 $2
}

function addTrackingBranches
{
	for branch in `doGit branch -a | grep remotes | grep -v HEAD | grep -v master`; do
    doGit branch --track ${branch##*/} $branch
	done
}

# -- FAVORITES -- #

function starCommit
{
	doGit tag '!important-'$1 $1	
}

function unstarCommit
{
	doGit tag -d '!important-'$1	
}

# -- REMOTES -- #

function addRemote
{
	doGit remote add $1 $2
	doGit config branch.$3.remote $1
	doGit config branch.$3.merge refs/heads/$3
}

function editRemote
{
	doGit remote set-url $1 $2
}

function delRemote
{	
	doGit remote rm $1
}

function stash
{
	d=$PWD; cd "$tree"; doGit stash -q; cd $d	
}

function unstash
{
	d=$PWD; cd "$tree"; doGit stash pop -q; cd $d 	
}

function trackFile
{
	doGit add $1
}

function unTrackFile
{
	doGit rm -r --cached $1	
}

function trashUnsaved
{
	doGit reset --hard	
}

function copyVersion
{
	mod=`doGit ls-files -m`
	if [ -n "$mod" ]; then stash; fi
	setBranch $2
	if [ -f "$3" ]; then 
		saveFileCopy "$3" "$4"
	else
		saveFolderCopy "$3" "$4"
	fi
	setBranch $1
	if [ -n "$mod" ]; then unstash; fi
}

function saveFileCopy
{
	cp "$1" "$2"
}

function saveFolderCopy
{
	cp -r -f "$1" "$2"
	rm -r -f "$2"/.git
}

# function getNumInIndex
# {
# #	expr $(git status --porcelain 2>/dev/null| egrep "^(A |D | M|AM|DM)" | wc -l)
# }

# call the requested method #
tree=${args[$#-1]}
gdir=${args[$#-2]}/.git
$1 "${args[@]}"
