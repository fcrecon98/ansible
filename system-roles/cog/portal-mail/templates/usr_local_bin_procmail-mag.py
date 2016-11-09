#! /usr/bin/python

import sys, re
from time import localtime, strftime
from urllib2 import urlopen

today  = strftime("%Y%m", localtime())
log    = '/var/log/daletto/mail/bounce-' + today + '.log'
date      = ''
from_add  = ''
mails     = ['']
url       = '{{ api_url }}/member/chgmailflagbymail?svid=1&mailerr=1&mail='
result    = ''


d1 = re.compile('^Date: ')
d2 = re.compile(',')
d3 = re.compile('\(')

f1 = re.compile('^From: ')
f2 = re.compile('info@capcom-onlinegames.jp')
f3 = re.compile('.+@.+')

m1 = re.compile('<.+@.+>[;:]')
m2 = re.compile('.*capcom-onlinegames.*')
m3 = re.compile('.*root.*')
m4 = re.compile('<.+@.+>')
m5 = re.compile('Postmaster@ezweb.ne.jp')
m6 = re.compile('@ezweb.ne.jp')
m7 = re.compile('MAILER-DAEMON@softbank.ne.jp')

a1 = re.compile('^result')


for line in sys.stdin.readlines():

   if d1.search(line):
        dtmp = line.split('Date:')
        date = dtmp[1].strip()
        if d2.search(date):
           dtmp = date.split(',')
           date = dtmp[1].strip()
        if d3.search(date):
           dtmp = date.split('(')
           date = dtmp[0].strip()

   if f1.search(line) and not f2.search(line):
        ftmp = line.split(' ')
        for i in ftmp:
            if f3.search(i):
                from_add = f3.search(i).group().strip()

   if m1.search(line) and not m2.search(line) and not m3.search(line) \
      or m5.search(from_add) and m4.search(line) and m6.search(line) and not m5.search(line):
        mflag = 0
        mtmp  = line.split('<')
        mtmp  = mtmp[1].split('>')
        mtmp2 = mtmp[0].strip().replace('"', '')
        for mail in mails:
            if mails[0] == '':
               mails[0] = mtmp2
               mflag = 1
            elif mail == mtmp2:
               mflag = 1
        if mflag == 0:
            mails.append(mtmp2)

fd = open(log,'a')
for mail in mails:
    url  = url + mail
    res  = urlopen(url)
    
    for line in res.readlines():
      if a1.search(line):
        atmp = line.split('=')
        result = atmp[1].strip()

    str = date + "\t" + from_add + "\t" + mail + "\tmag\t" + result + "\n"
    fd.write(str)
fd.close()

