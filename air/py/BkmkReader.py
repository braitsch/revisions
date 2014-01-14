#!/usr/bin/python
from Include import *

# never forget all git sh scripts must be called from within the worktree!!
def getStash():
	os.chdir(WORK_TREE)
	git(['stash', 'list'])

def getRemotes():
	git(['remote', '-v'])

def getLocalBranches():
	git(['branch'])

def getRemoteBranches():
	git(['branch', '-r'])

call(locals()[METHOD])
#print 'executing from :: '+os.getcwd()