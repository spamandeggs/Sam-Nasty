'''
stosbuild
Copyright (c) 2020, jerome mahieux
This file is part of stosbuild.

stosbuild is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

stosbuild is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with stosbuild.  If not, see <https://www.gnu.org/licenses/>.

GPL-3.0-or-later
'''

import os
from assets import *
from shutil import copy
from pathlib import Path
from collections import OrderedDict as odict

root_pth = Path().cwd()
assets_pth = root_pth.joinpath('assets')
builds_pth = root_pth.joinpath('builds')
tpl_pth = root_pth.joinpath('sources')
dev_pth = root_pth.joinpath('sources')

builds_pth.mkdir(exist_ok=True)

# licence notice
# ...



def generate() :
	for floppy_name, content in FLOPPIES.items() :
		dest_pth = builds_pth.joinpath(floppy_name)
		dest_pth.mkdir(exist_ok=True)

		print('Generating floppy %s'%(floppy_name))
		print('in %s :'%(dest_pth))
		
		if 'ASSETS' in content :
			for file_name in content['ASSETS'] :
				print(' adding %s'%file_name)
				src = assets_pth.joinpath(file_name)
				dst = dest_pth.joinpath(file_name)
				copy(src,dst)
		if 'SOURCES' in content :
			for file_name in content['SOURCES'] :
				print(' adding %s'%file_name)
				src = dev_pth.joinpath(file_name)
				dst = dest_pth.joinpath(file_name)
				copy(src,dst)
		if 'TEMPLATES' in content :
			for file_name, tpl_names in content['TEMPLATES'].items() :
				print(' generating %s'%file_name)
				dst = dest_pth.joinpath(file_name)
				generated = []
				pointers = {}
				lnb = 10
				lnbinc = 10
				for tpl_name in tpl_names :
					print('  adding %s'%tpl_name)
					src = tpl_pth.joinpath(tpl_name)
					with open(src) as f : 
						for li,line in enumerate(f.readlines()) :
							l = line.strip()
							if l :
								if l[0] == '#' : continue
								elif l[0] == '@' :
									pointers[l[1:]] = str(lnb+lnbinc)
									generated.append('%s rem %s'%(lnb,l))
								else :
									generated.append('%s %s'%(lnb,l))
								lnb += lnbinc

				for li,line in enumerate(generated) :
					if 'rem' not in line.split()[1].lower() :
						for keyword,line_number in pointers.items() :
								if keyword in line :
									generated[li] = generated[li].replace(keyword,line_number)
									
				print(' adding %s'%file_name)
				print('\n'.join(generated))
				with open(dst,'w',newline='\r\n') as f : 
					for l in generated : f.write(l+'\n')
		print('Done.')


def importasc(src) :
	print('Importing %s...'%src)
	imported = odict()
	callers = odict()
	blocks = odict()
	subblocks = odict()
	blocknames = {}
	rtns = []
	
	def getlines(needle,blk=True) :
		start = codelow.index(needle)+len(needle)+1
		jump = code[start:].split()[0]
		jumps = jump.split(',')
		if lnum not in callers : callers[lnum] = []
		callers[lnum].extend(jumps)
		if blk :
			for j in jumps :
				if j not in blocks : blocks[j] = []
				blocks[j].append(lnum)
		else :
			for j in jumps :
				if j not in subblocks : subblocks[j] = []
				subblocks[j].append(lnum)
		return code[start+len(jump):]
		
# 1318 lines
# from line 1 to 20020
# 341 callers
# 112 blocks
# 64 subblocks
# 88 returns

	with open(src) as f :
		mark = False
		for li,line in enumerate(f.readlines()) :
			l = line.strip()
			if l :
				part = l.split()
				lnum = part[0]
				code = ' '.join(part[1:])
				imported[lnum] = code
				
				if part[1].lower() == 'rem' :
					# next line is a block previously generate()'d 
					if len(part[2]) and part[2][0] == '@' :
						blockname = part[2]
					continue
				
				elif blockname :
					blocknames[lnum] = blockname
					blockname = False
				
				codelow = code.lower()
				if 'return' in codelow :
					rtns.append(lnum)
				
				while code :
					jump = False
					ongotos = False
					codelow = code.lower()
					if 'gosub' in codelow :
						code = getlines('gosub',False)
					elif 'goto' in codelow :
						code = getlines('goto')
					elif 'restore' in codelow :
						code = getlines('restore')
					else :
						code = False

	linenumbers = list(imported.keys())
	
	# summary
	print('%s lines'%(len(imported)))
	print('from line %s to %s'%(linenumbers[0],linenumbers[-1]))
	print('%s callers'%(len(callers)))
	print('%s blocks'%(len(blocks)))
	print('%s subblocks'%(len(subblocks)))
	print('%s returns'%(len(rtns)))
	
	# check number of blocks
	test = set()
	for v in callers.values() :
		for j in v : test.add(j)
	print(test)
	print(len(test))
	
	# for k,v in imported.items() : print(k,v)
	
def selectimport() :
	
	ascfiles = sorted(builds_pth.glob('**/*.asc'))
	if not(ascfiles) : print('No basic (*.asc) files found in %s'%builds_pth) ; return
	print('Available basic files :')
	for fi,f in enumerate(ascfiles) :
		print(' %s %s'%(fi+1,f))
	rep = input('type a number to import the corresponding file : ')
	# try :
	rep = int(rep)-1
	ascfile = ascfiles[rep]
	rtn = importasc(ascfile)
		
	# except :
		# print('bad input')
		# return
	
def main() :

	print('Press 1 to Generate basic from templates,')
	print('Press 2 to Generate templates from basic,')
	print('anything else to leave : ',end='')
	rep = input()
	if rep == '1' : print('to ASC') ; generate()
	elif rep == '2' : print('to tpl') ; selectimport()
	exit()

main()