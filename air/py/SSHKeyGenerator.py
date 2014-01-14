#!/usr/bin/python
import os
import socket
from Include import *

def getHostName():
	print socket.gethostname()

def detectSSHKey():
	try:
   		print open(KEYFILE+'.pub').read()
	except IOError as e:
		print 'keyfile not found'

def createSSHKey():
	subprocess.call(['ssh-keygen', '-q', '-t', 'rsa', '-f', KEYFILE, '-P', ''])

def addKeyToAuthAgent():
	subprocess.call(['ssh-add', KEYFILE])

call(locals()[METHOD])