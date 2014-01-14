#!/bin/bash
source `dirname $0`/Include.sh

#old header
hdr='Content-Type:application/x-www-form-urlencoded'

function silentLogin
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n	
}

function activeLogin
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n
}

function getRepositories
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n	
}

function addRepository
{
	n=`curl --silent -X POST -d "${args[1]}" ${args[2]}`
	echo $?,$n	
}

function getCollaborators
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n		
}

function addCollaborator
{
	n=`curl --silent -X PUT -H 'Content-Length: 0' ${args[1]}`
	echo $?,$n	
}

function killCollaborator
{
	n=`curl --silent -X DELETE ${args[1]}`
	echo $?,$n	
}

## ssh - keys ##

function getAllKeys
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n
}

function addKeyToRemote
{
	n=`curl --silent -X POST -d "${args[1]}" ${args[2]}`
	echo $?,$n
}

function repairRemoteKey
{
	n=`curl --silent -X PATCH -d "${args[1]}" ${args[2]}`
	echo $?,$n	
}

function deleteKeyFromRemote
{
	n=`curl --silent -X DELETE ${args[1]}`
	echo $?,$n	
}

function addNewKnownHost
{
	ssh -q -T ${args[1]} -o StrictHostKeyChecking=no
}

# call the requested method
$1 "${args[@]}"