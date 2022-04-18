#!/usr/bin/env python3

from bs4 import BeautifulSoup as bs
import requests,subprocess,sys

group=[]
try:
	url=sys.argv[1]
	headers={'User-Agent':'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:82.0) Gecko/20100101 Firefox/82.0'}
	r=requests.get(url,headers=headers)
	soup=bs(r.content,"html.parser")
	pre=soup.find('pre')
	pre=pre.text
	group=pre.split('Authorized ')
except:
	print("Error Reaching Webpage\nURL:")
	exit()
NeedAdmins=[]
NeedUsers=[]
adm=False

for i in group:
     t=i.split('\r\n')
     for th in t:
             if 'password' in th:
                     pass
             elif th=='':
                     pass
             elif ':' in th:
                     adm=not adm
             elif '(you)' in th:
                     namep1=th.split(' ')
                     NeedAdmins.append(namep1[0])
             else:
                     if adm:
                             NeedAdmins.append(th)
                     else:
                             NeedUsers.append(th)

CurAdmins=[]
try:
	command="grep sudo /etc/group"
	mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
	stdout,stderr=mout.communicate()
	CurAdmins=str(stdout).split(':')[3].split('\\')[0].split(',')
except:
	print("Error Fetching Admins (Sudoers)")

try:
	for a in CurAdmins:
		if a not in NeedAdmins:
			command="sudo deluser "+a+" sudo"
			mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
			stdout,stderr=mout.communicate()
			print(stdout)
except:
	print("Error Removing Admins: "+stderr)

try:
	command="grep sudo /etc/group"
	mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
	stdout,stderr=mout.communicate()
	CurAdmins=str(stdout).split(':')[3].split('\\')[0].split(',')
except:
	print("Error Fetching Admins (Sudoers)")

'''
command="grep users /etc/group"
mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
stdout,stderr=mout.communicate()
CurUsers=str(stdout).split(':')[3].split('\\')[0].split(',')
for a in CurAdmins:
	if a in CurUsers:
		CurUsers.remove(a)
'''
CurUsersDir=[]
try:
	command="ls /home"
	mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
	stdout,stderr=mout.communicate()
	CurUsersDir=str(stdout).split("'")[1].split('\\n')[0:-1]
	for a in CurAdmins:
		if a in CurUsersDir:
			CurUsersDir.remove(a)
except:
	print("Error Fetching Users")

try:
	for user in CurUsersDir:
		if user not in NeedUsers:
			command="sudo deluser "+user
			mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
			stdout,stderr=mout.communicate()
			print(stdout)
			try:
				command="sudo mv /home/%s /home/.%s" % (user,user)
				mout=subprocess.Popen(command.split(),stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
				stdout,stderr=mout.communicate()
			except:
				print("Failed hiding %s home directory" % (user))
except:
	print("Error Removing Users: "+stderr)



