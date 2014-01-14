#!/usr/bin/python

from Include import *

def clone(v):
	os.chdir(v[1])
	git_exe(['clone', v[0], '--template=' + TEMPLATES])

def pushBranch(v):
	# remote-nme, branch-name	
	git(['push', v[0], v[1]])

def attemptHttpsAuth(v):
	# remote-url, branch-name
	git(['push', '--dry-run', v[0], v[1]])

def getRemoteFiles():
	git(['fetch', '--all'])

def deleteRemoteBranchFromServer(v):
	git(['push', v[0], ':'+v[1]])

call(locals()[METHOD])