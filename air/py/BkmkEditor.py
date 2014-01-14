#!/usr/bin/python

import shutil
from Include import *

def commit(v):
	git(['add', '--all'])
	git(['commit', '-m', v[0], '-q'])

# -- BRANCHING -- #

def addBranch(v):
	git(['checkout', '-b', v[0], v[1]])

def setBranch(v):
	git(['checkout', '-q', v[0]])

def delBranch(v):
	git(['branch', '-D', v[0]])

def renameBranch(v):
	git(['branch', '-m', v[0], v[1]])

def addTrackingBranches():
	b = git(['branch', '-a'], 0).split('\n')
	for r in b:
		if r.find('remotes') != -1 and r.find('master') == -1 : 
			r = r[r.find('/') + 1:]
			n = r[r.find('/') + 1:]
			git(['branch', '--track', n, r])

# -- FAVORITES -- #

def starCommit(v):
	git(['tag', '!important-'+v[0], v[0]])

def unstarCommit(v):
	git(['tag', '-d', '!important-'+v[0]])


# -- REMOTES -- #

def addRemote(v):
	git(['remote', 'add', v[0], v[1]])
	git(['config', 'branch.'+v[2]+'.remote', v[0]])
	git(['config', 'branch.'+v[2]+'.merge', 'refs/heads/'+v[2]])

def editRemote(v):
	git(['remote', 'set-url', v[0], v[1]])

def delRemote(v):
	git(['remote', 'rm', v[0]])

def stash():
	dir=os.getcwd()
	os.chdir(WORK_TREE)
	git(['stash', '-q'])
	os.chdir(dir)

def unstash():
	dir=os.getcwd()
	os.chdir(WORK_TREE)
	git(['stash', 'pop', '-q'])
	os.chdir(dir)

def trackFile(v):
	git(['add', v[0]])

def unTrackFile(v):
	n = git(['rm', '-r', '--cached', v[0]])
	print 'n='+n

def trashUnsaved():
	git(['reset', '--hard'])

def copyVersion(v):
	mod = git(['ls-files', '-u'], 0)
 	if mod: stash()
	setBranch([v[1]])	
	if os.path.isfile(v[2]):
		saveFileCopy(v[2], v[3])
	else:
		saveFolderCopy(v[2], v[3])
	setBranch([v[0]])	
	if mod: unstash()

def saveFileCopy(src, dest):
	shutil.copy(src, dest)

def saveFolderCopy(src, dest):
	shutil.copytree(src, dest)
	shutil.rmtree(dest+'/.git')

call(locals()[METHOD])
