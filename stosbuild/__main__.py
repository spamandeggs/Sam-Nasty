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

class Template() :
	
	# file path
	# list of ordered blocks and their code
	def __init__(self) :
		self.dummy = 0
		

class Block() :
	
	def __init__(self,entryline,blockname,block,callers) :
		self.blockname = blockname
		self.entryline = entryline
		self.block = block
		self.callers = callers
		self.length = len(block)
	
	def list(self) :
		print('block %s :'%self.blockname)
		print('callers : %s'%', '.join(self.callers))
		print()
		for li,code in enumerate(self.get_tpl()) :
			print(' %s. %s'%(li,code))
	
	def get_tpl(self) :
		tpl = []
		notag = True
		for code in self.block :
			# if code.split()[0].lower() != 'rem' and notag :
				# tpl.append('@%s'%(self.blockname))
				# notag = False
			tpl.append(code)
		return tpl
		
class Structure() :

	def __init__(self,generated,callers,blocks,subblocks,blocknames,rtns) :
	
		self.callers = callers
		self.blocknames = blocknames
		self.rtns = rtns
		
		self.lines = list(generated.keys())
		
		self.summary()
		
		self.blocks = odict()
		self.subblocks = odict()
		self.isinablock = set()
		self.generated = odict()
		
		for lnum in self.lines :
			if lnum in blocks :
				prefix = 'GO_'
			elif lnum in subblocks :
				prefix = 'SUB_'
			else : prefix = False
			if prefix :
				self.generated[lnum+'@'] = '@'+prefix+str(lnum)
			self.generated[lnum] = generated[lnum]
		
		self.lines = list(self.generated.keys())
		
		dst = tpl_pth.joinpath('generated.asc.tpl')
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# ALL\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for k, v in self.generated.items() :
				f.write(v+'\n')
		
		# for now only isolate subs from main code
		# for entry_line, callers in blocks.items() :
			# blockname, block = self.import_block(entry_line)
			# self.blocks[blockname] = Block(entry_line,blockname,block,callers)
		
		# first isolate the subs :
		sub_sorted = list(subblocks.keys())
		sub_sorted.sort()
		for sub_entry_line in sub_sorted :
			if sub_entry_line not in self.isinablock :
				blockname, block = self.import_block(sub_entry_line,'SUB')
				self.subblocks[blockname] = Block(sub_entry_line,blockname,block,callers)

		dst = tpl_pth.joinpath('main.asc.tpl')
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# MAIN\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for k, v in self.generated.items() :
				if k not in self.isinablock :
					f.write(v+'\n')
				
		# li = 0
		# while li < len(self.lines) :
			# lnum = lines[li]
			# if lnum not in self.isinablock :
				# if l in blocks :
					
				# self.main[l] = self.generated[l]
			
		print('%s blocks'%(len(self.blocks)))
		print('%s subblocks'%(len(self.subblocks)))
		
		dst = tpl_pth.joinpath('subs.asc.tpl')
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# SUBS\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for blockname, block in self.subblocks.items() :
				
				for l in block.get_tpl() :
					f.write(l+'\n')
				f.write('\n')
		
	def import_block(self,sub_entry_line,prefix='GO') :

		# block name
		if sub_entry_line in self.blocknames :
			blockname = self.blocknames[sub_entry_line]
		else :
			blockname = '%s_%s'%(prefix,str(sub_entry_line))
		
		# entry point as a variable case (goto SOMEVAR)
		try :
			isanum = int(sub_entry_line)
		except :
			print('gosub entry point specified as a variable (%s)'%sub_entry_line)
			blockname = sub_entry_line
			block = []
			return blockname, block
		
		# get the block
		block = []
		idx = self.lines.index(sub_entry_line)
		line = sub_entry_line
		
		# search for comments lines in the previous lines
		isrem = True
		while idx > 0 and isrem :
			idx -= 1
			testline = self.lines[idx]
			if self.generated[testline][0] != '@' and self.generated[testline].split()[0].lower() != 'rem' :
				isrem = False
				idx += 1
			else :
				line = testline
				
		while line :
			code = self.generated[line]
			block.append(code)
			self.isinablock.add(line)
			line = False
			
			# todo : test is dirty does not cover all conditionnal returns cases
			if 'return' not in code  or 'then' in code or 'else' in code :
				idx += 1
				if idx < len(self.lines) :
					line = self.lines[idx]
				
		return blockname, block
		
	def summary(self) :
		# summary
		print('%s lines'%(len(self.lines)))
		print('from line %s to %s'%(self.lines[0],self.lines[-1]))
		print('%s callers'%(len(self.callers)))
		# print('%s blocks'%(len(self.blocks)))
		# print('%s subblocks'%(len(self.subblocks)))
		print('%s returns'%(len(self.rtns)))
		# check number of blocks
		test = set()
		for v in self.callers.values() :
			for j in v : test.add(j)
		print(test)
		print(len(test))
	
	def listmain(self) :
	
		for k,v in self.main.items() : print('%s %s'%(k,v))
	
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
	imported = odict()		# line number as keys / code as values
	generated = odict()		# same with jumps replaced by variables
	callers = odict()		# lines with a goto, gosub, restore as key / list of destinations a values
	blocks = odict()		# entry points of a jump as key / list of callers
	subblocks = odict()		# same when called from a gosub
	blocknames = {}
	blockname = False
	rtns = []
	code = ''
	
	def getlines(needle,start,blk=True) :
		start += codelow[start:].index(needle)+len(needle)+1
		jump = code[start:].split()[0]
		jumps = jump.split(',')
		if lnum not in callers : callers[lnum] = []
		callers[lnum].extend(jumps)
		if blk :
			prefix = 'GO_'
			blk = blocks
		else :
			prefix = 'SUB_'
			blk = subblocks
		
		nextcode = code
		
		for j in jumps :
			
			if j in blocknames : 
				goj = blocknames[j]
			else :
				goj = prefix+str(j)
				
			if j not in blk : blk[j] = []
			blk[j].append(lnum)
			
			nextcode = nextcode[:start] + goj + nextcode[start+len(j):]
			start += len(goj)
			if start < len(nextcode) and nextcode[start] == ',' : start += 1
			# print('>',nextcode,start)
			# k = input()
			
		# nextcode = code[:codelow.index(needle)] + code[start+len(jump):]
		# if len(nextcode) and nextcode.strip().split()[-1] in ['then','else'] :
			# nextcode = nextcode[:-4]
		print('>',nextcode)
		return nextcode, start

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
					if len(part) > 2 and part[2][0] == '@' :
						blockname = part[2]
					continue
				
				elif blockname :
					blocknames[lnum] = blockname
					blockname = False
				
				codelow = code.lower()
				if 'return' in codelow :
					rtns.append(lnum)					
				
	for li,(lnum,code) in enumerate(imported.items()) :
	
		if code.split()[0].lower() != 'rem' :
			start = 0
			while start < len(code) :
				jump = False
				ongotos = False
				codelow = code.lower()
				if 'gosub' in codelow[start:] :
					print('gosub:',code)
					code, start = getlines('gosub',start,False)
				elif 'goto' in codelow[start:] :
					print('goto:',code)
					code, start = getlines('goto',start)
				elif 'restore' in codelow[start:] :
					print('restore:',code)
					code, start = getlines('restore',start)
				elif 'then' in codelow[start:] : # then LINE (goto ommitted) cases
					start += codelow[start:].index('then')
					jump = code[start+5:].split()[0]
					# print('then')
					# print(codelow[start:])
					# print(code[start+5:])
					# print(start,jump)
					try :
						isline = int(jump)
						print('then:',code)
						code, start = getlines('then',start)
					except :
						start += 5
						# print('then: no jump. next part %s'%codelow[start:])
						# code = code[:start-5] + code[start+len(jump):]
						
				elif 'else' in codelow[start:] : # then LINE (goto ommitted) cases
					start += codelow[start:].index('else')
					jump = code[start+5:].split()[0]
					# print('else')
					# print(codelow[start:])
					# print(code[start+5:])
					# print(start,jump)
					
					try :
						isline = int(jump)
						print('else:',code)
						code, start = getlines('else',start)
					except :
						start += 5
						# print('else: no jump. next part %s'%codelow[start:])
						# start = code[:start-5] + code[start+len(jump):]
						
				else :
					start = len(code)
		
		generated[lnum] = code
	
	
	
	st = Structure(generated,callers,blocks,subblocks,blocknames,rtns)
	
	return st
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
	return importasc(ascfile)
	
	# except :
		# print('bad input')
		# return

	
def main() :

	print('Press 1 to Generate basic from templates,')
	print('Press 2 to Generate templates from basic,')
	print('anything else to leave : ',end='')
	rep = input()
	if rep == '1' : print('to ASC') ; return generate()
	elif rep == '2' : print('to tpl') ; return selectimport()
	# exit()


st = main()