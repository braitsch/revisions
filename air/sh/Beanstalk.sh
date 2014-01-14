#!/bin/bash
source `dirname $0`/Include.sh

hdr='Content-Type:application/xml'

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
	n=`curl --silent -X POST -H $hdr -d "${args[1]}" ${args[2]}`
	echo $?,$n	
}

function getCollaborators
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n		
}

function addCollaborator
{
	n=`curl --silent -X POST -H $hdr -d "${args[1]}" ${args[2]}`
	echo $?,$n
}

function killCollaborator
{
	n=`curl -i -X POST -H "Content-Type: application/xml" -H "X-HTTP-Method-Override: DELETE" "${args[1]}"`
	echo $?,$n	
}

function getPermissions
{
	n=`curl --silent -X GET "${args[1]}"`
	echo $?,$n	
}

function setPermissions
{
	n=`curl --silent -X POST -H $hdr -d "${args[1]}" ${args[2]}`
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
	n=`curl --silent -X POST -H $hdr -d "${args[1]}" ${args[2]}`
	echo $?,$n
}

function repairRemoteKey
{
	n=`curl --silent -X PUT -H $hdr -d "${args[1]}" ${args[2]}`
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