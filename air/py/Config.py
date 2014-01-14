#!/usr/bin/python
import os
import getpass
import tarfile
from Include import *

def detectGit():
	if not os.path.exists(GIT_PATH):
		print 0
	else:
		git_exe(['--version'])
	return
	
def installGit():
	src = os.path.abspath('../git-1.7.7.1.tar.gz')
	tar = tarfile.open(src, "r:gz")
	tar.extractall(STORAGE)
	git_exe(['--version'])
	return
	
def getLoggedInUserName():
	print getpass.getuser()
	return
	
def getUserName():
	git_exe('config --global user.name'.split())
	return
	
def getUserEmail():
	git_exe('config --global user.email'.split())
	return

def setUserName(n):
	v = 'config --global user.name'.split()
	v.append(n[0])
	git_exe(v)
	getUserName()
	return

def setUserEmail(e):
	v = 'config --global user.email'.split()
	v.append(e[0])
	git_exe(v)
	getUserEmail()
	return

call(locals()[METHOD])