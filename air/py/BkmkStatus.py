#!/usr/bin/python
from Include import *

def getHistory():
	git(['log', '--reverse', '--no-merges', '--pretty=format:%H-#-%ar-#-%an-#-%ae-#-%s-##-'])

def getFavorites():
	git(['tag', '-l', '!important*'])

def cherryBranch(v):
	git(['cherry', v[0], v[1]])

def getTrackedFiles():
	git(['ls-files', '-c'])

def getUntrackedFiles():
	git(['ls-files', '--other', '--exclude-standard'])

def getModifiedFiles():
	git(['ls-files', '-m'])

def getIgnoredFiles():
	git(['ls-files', '--other', '--ignored', '--exclude-standard'])

call(locals()[METHOD])