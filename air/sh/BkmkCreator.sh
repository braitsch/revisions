#!/bin/bash
source `dirname $0`/Include.sh

function trim { echo $1; }

# function getDirectorySize
# {
# # returns weight of target & all subdirectories in MB's	
# 	s=`du -sm`; s=${s/./}; echo `trim $s`
# }

function getDirectoryFiles
{
# get a list of all files in the target folder that are visible and outside of the main .git directory 	
	cd "$1"; find . -type d \( ! -name .git \) -o \( ! -name cache -prune \) -a \( ! -name '.*' -type f \) -print
}

function initFile
{
	cd "$1"; git --git-dir=./.git --work-tree="$2" init --template="$templates"
	# tell git to ignore everything in the worktree
	echo '*' >> ./.git/info/exclude
	# we will force add the single file in 'trackFile'
}

function initFolder
{
	cd "$1"; if [ ! -d .git ]; then git init --template="$templates" -q; fi
	git branch
}

function trackFile
{
	cd "$2"; git add "$1" -f
}

function addInitialCommit
{
	cd "$1"; git commit -m "Bookmark Created"
}

function initSingleFileRepo
{
	cd "$1"
	echo '*' >> ./.git/info/exclude	
	git config core.worktree "$2" # and update the worktree	
}

function setFileLocation
{	
	cd "$1" # local app-storage directory
	mv "$2" "$3" # rename the target folder 
	cd "$3"
	git config core.worktree "$4" # and update the worktree
}

#MD5 reference used in old editGirDirMethod
# old=`md5 -q -s "$1"`
# new=`md5 -q -s "$2"`

# call the requested method #
$1 "${args[@]}"