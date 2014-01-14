#!/bin/bash
source `dirname $0`/Include.sh

function getHostName
{
	hostname -s	
}

function detectSSHKey
{
	if [ -f $keyFile.pub ]; then cat $keyFile.pub; fi
}

function createSSHKey
{
	ssh-keygen -q -t rsa -f $keyFile -P ''
}

function addKeyToAuthAgent
{
	ssh-add $keyFile
}

# call the requested method
$1 "${args[@]}"