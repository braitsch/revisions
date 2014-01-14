#!/usr/bin/python
from Include import *

def getDirectoryFiles(v):
# get a list of all files in the target folder that are visible and outside of the main .git directory 	
	for root, dirs, files in os.walk(v[0]):
		if '.git' in dirs: dirs.remove('.git')
		for filename in files:
	#		if not filename.startswith('.'):
			print os.path.join(root, filename)

def initFile(v):
	os.chdir(v[0])
	git_exe(['--git-dir=./.git', '--work-tree=' + v[1], 'init', '--template=' + TEMPLATES])
	# tell git to ignore everything in the worktree
 	with open('./.git/info/exclude', 'a') as f: f.write('*\n')
	# we will force add the single file in 'trackFile'

def initFolder(v):
	os.chdir(v[0])	
	if not os.path.isdir('.git'):
		git_exe(['init', '--template=' + TEMPLATES, '-q'])
	git_exe(['branch'])

def trackFile(v):
	git(['add', v[0], '-f'])

def addInitialCommit():
	git(['commit', '-m', 'Bookmark Created'])

def setWorkTree(v):
	# this is called when cloning a single file
	os.chdir(v[0])
	# tell git to ignore everything in the worktree
 	with open('./.git/info/exclude', 'a') as f: f.write('*\n')
	# and update the worktree
	git_exe(['config', 'core.worktree', v[1]])

def setFileLocation(v):
	# cd into the local app-storage directory
	os.chdir(v[0])
	# rename the target folder 
	os.rename(v[1], v[2])
	os.chdir(v[2])
	# and update the worktree
	git_exe(['config', 'core.worktree', v[3]])

#MD5 reference used in old editGirDirMethod
# old=`md5 -q -s "$1"`
# new=`md5 -q -s "$2"`

call(locals()[METHOD])