#!/bin/bash
source `dirname $0`/Include.sh

function syncLocal
{
	cd "$tree";
	strategy=$4
	# switch to branch b
	doGit checkout $2 2> /dev/null
	if [ $? -ne 0 ]; then
		echo 'checkout failed, unsaved changes'
		exit
	fi
	echo 'checkout ok'
	git branch
	# update b with changes in a
	$strategy $1 "$3"
#	doGit merge $1 -m "$3" >& /dev/null
	if [ $? -ne 0 ]; then
		echo 'merge attempt failed'
		doGit reset -q --hard
		doGit checkout $1
		exit
	fi
	echo 'merge ok'
	# switch back to branch a
	doGit checkout $1
	# and update a with changes in b
	$strategy $2 "$3"
	echo 'done'
#	doGit merge $2 -m "$3"
}

function syncRemote
{
	cd "$tree";
	strategy=$3
	$strategy $1 "$2"
#	doGit merge $1 -m "$2" >& /dev/null
	if [ $? -ne 0 ]; then
		echo $#
		echo 'merge attempt failed'
		doGit reset -q --hard
	fi
}

function mergeNormal
{
	echo 'mergeNormal called > $1'
	doGit merge $1 -m "$2" >& /dev/null
}

function mergeOurs
{
	echo 'mergeOurs called > $1'
	doGit merge -s ours $1 -m "$2" >& /dev/null
}

function mergeTheirs
{
	echo 'mergeTheirs called > $1'
	doGit merge -Xtheirs $1 -m "$2" >& /dev/null
}

# -- UTILITIES -- #

function getUniqueCommits
{
	doGit log $2..$1 --no-merges --pretty=format:"%H-#-%ar-#-%an-#-%ae-#-%s-##-"
}

function getLastCommit
{
	f="%s-#-%ar-#-%ae-#-%an-#-%at-##-"
	doGit log --no-merges -n 1 --pretty=format:$f
	doGit log --no-merges $1 -n 1 --pretty=format:$f
}

# call the requested method #
tree=${args[$#-1]}
gdir=${args[$#-2]}/.git
$1 "${args[@]}"
