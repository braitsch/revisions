#!/bin/bash

args=("$@"); unset args[0];
keyFile=~/.ssh/revisions_rsa
store="$HOME"'/Library/Preferences/com.braitsch.revisions/Local Store'
gexec="$store"/git/git
templates="$store"/git/share/git-core/templates

function git
{
	"$gexec" "$@"
}

function doGit
{
 	"$gexec" "--git-dir=$gdir" "--work-tree=$tree" "$@"
}