#!/bin/bash
source `dirname $0`/Include.sh

function detectGit
{
	if [ ! -f "$gexec" ]; then
		echo 0
	else		
		git --version
	fi
}

function installGit
{
	if [ -d "$store/git" ]; then rm -rf "$store/git"; fi
	cd `dirname $0`
	tar -zxvf ../git-1.7.7.1.tar.gz -C "$store" 2>&1
	git --version
}

function getLoggedInUsersRealName
{
	user=`whoami`
	if [ -z '$user' ]; then user=$USER; fi	
	name=`finger $user | sed -e '/Name/!d' -e 's/.*Name: //'`
	if [ -z '$name' ]; then name=`finger $user | grep Name | awk -F "Name: " '{print $2}'`; fi
	echo $name
}

function getUserName
{
	git config --global user.name
}

function getUserEmail
{
	git config --global user.email
}

function setUserName
{
# set it and echo back the new value	
	git config --global user.name "${args[1]}"
	git config --global user.name	
}

function setUserEmail
{
# set it and echo back the new value	
	git config --global user.email "${args[1]}"
 	git config --global user.email	
}

# call the requested method #
$1 "${args[@]}"