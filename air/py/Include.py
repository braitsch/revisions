#!/usr/bin/python

import os, subprocess, sys

HOME		= os.getenv('HOME')
STORAGE		= HOME + '/Library/Preferences/com.braitsch.revisions/Local Store'
KEYFILE 	= HOME + '/.ssh/revisions_rsa'
GIT_PATH 	= STORAGE + '/git'
GIT_EXEC 	= STORAGE + '/git/git'
TEMPLATES 	= STORAGE + '/git/share/git-core/templates'
WORK_TREE 	= GIT_DIR = 'xxx-xxx-xxx'

def git(v, p=1):
	v.insert(0, GIT_EXEC)
	v.insert(1, '--git-dir='+GIT_DIR+'/.git')
	v.insert(2, '--work-tree='+WORK_TREE)	
#	print v
	r = subprocess.Popen(v, stdout=subprocess.PIPE).communicate()[0]
	if p: print r
	return r

def git_exe(v):
	v.insert(0, GIT_EXEC)
#	print 'git_exe = '+str(v)
	subprocess.call(v)
	return

def call(m):
	if not ARGUMENTS:
		m()
	else:
		m(ARGUMENTS)

# capture the method by string name
METHOD = sys.argv[1]
v = sys.argv[2:]
for i in range(len(v)):
	if v[i].find('[') == 0:
		x = v[-1]
		v = v[:i]
		
ARGUMENTS = v
# if the last arg was wrapped in an array, set gdir & wktr
if 'x' in locals():
	x = x[1:]
	x = x[:-1]
	x = x.split(',')
	GIT_DIR = x[0]
	WORK_TREE= x[1]
#	print '--git-dir='+GIT_DIR, '--work-tree='+WORK_TREE
		
#print 'method = '+METHOD	
#print 'arguments =',ARGUMENTS