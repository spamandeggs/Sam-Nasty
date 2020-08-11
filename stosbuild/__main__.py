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
from time import strftime
from shutil import copy
from pathlib import Path
from collections import OrderedDict as odict

from assets import *

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

	def __init__(self,src,generated,callers,blocks,subblocks,named_blocks,named_jumps,rtns) :
	
		self.callers = callers
		self.named_blocks = named_blocks
		self.rtns = rtns

		self.subblocks = odict()
		self.isinablock = set()
		
		self.lines = list(generated.keys())
		self.generated = odict()

		self.summary()
		print('Named Jumps : %s'%(', '.join(named_jumps)))
		print('Named Blocks : %s'%(', '.join(named_blocks.values())))
		
		## unknow jumps defined as variable 
		# for named jumps with no corresponding stosbuild @block,
		# attempt to find the named jump variable definition
		# propose a correction when possible
		orphan_jumps=[]
		for jump in named_jumps :
			if jump not in named_blocks.values() : orphan_jumps.append(jump)
		if orphan_jumps :
			print("\nthis basic file use user defined variable as jumps, user decision required :\n")
			for jump in orphan_jumps :
				print(" * looking for '%s' definitions :"%(jump))
				firstneedle = '%s='%(jump)
				needle = ' %s'%(firstneedle)
				named_block_created = False
				for lnum, code in generated.items() :
					start = None
					if code[:len(firstneedle)] == firstneedle :
						start = 0
						ndl = len(firstneedle)
					elif needle in code :
						start = code.index(needle)
						ndl = len(needle)
				
					if start != None :
						entry_line = code[start+ndl:].split()[0]
						print('  * %s %s'%(lnum,code))
						try :
							test = int(entry_line)
							codeblock = generated[entry_line]
							print('  destination : %s %s'%(entry_line,codeblock))
							
							codeedited = code[:start] + code[start+ndl+len(entry_line)+2:]
							if codeedited[-2:] == ' :' : codeedited = codeedited[:-2]
							codeedited = codeedited.strip()
							
							print('  I could :')
							if not(named_block_created) :
								print("  . add the '@%s' entry point above line %s"%(jump,entry_line))
							
							if codeedited :
								print("  . replace line %s by\n  '%s'"%(lnum,codeedited))
							else :
								print("  . remove the %s definition line as it\'s unused."%lnum)
							
							print('\n  Do you want to do that ?')
							print('   type 1 to apply the above suggestion,')
							print('   type 2 to modify this line manually now,')
							print('   type anything else to manually care about that later.')
							q=input('  Your choice ? ')
							
							if q == '1' :
								if codeedited : generated[lnum] = codeedited
								else : generated[lnum] = ''
								if not(named_block_created) :
									named_blocks[entry_line] = jump
									named_block_created = True
							elif q == '2' :
								while q :
									print('  current : %s %s'%(lnum,code))
									newcode=input('  new     : %s '%(lnum))
									q = input('  type y to confirm, n to change, anything else to abort')
									if q.lower() != 'n' :
										if q.lower() == 'y' :
											generated[lnum] = newcode
										q = False
								
						# non simple def, can't propose edit
						except :
							print('  can\'t guess the destination line.')
						
						print()
				
		## 3rd pass, insert block names above each entry point
		for li,lnum in enumerate(self.lines) :
			if lnum in named_blocks :
				named_block = '@'+named_blocks[lnum]
			elif lnum in blocks :
				named_block = '@'+'GO_'+str(lnum)
				# print('found %s'%lnum)
			elif lnum in subblocks :
				named_block = '@'+'GO_'+str(lnum)
			else : named_block = False
			if named_block :
				
				self.generated[lnum+'@'] = named_block
				# print(lnum+'@',named_block)
			self.generated[lnum] = generated[lnum]
			# if li > 20 : exit()
		
		self.lines = list(self.generated.keys())
		
		# at this point, conversions are over, 
		# we (should) have a working template
		
		############################################################
		
		# isolate the subs from code
		sub_sorted = list(subblocks.keys())
		sub_sorted.sort()
		for sub_entry_line in sub_sorted :
			if sub_entry_line not in self.isinablock :
				blockname, block = self.import_block(sub_entry_line,'SUB')
				self.subblocks[blockname] = Block(sub_entry_line,blockname,block,callers)

		# todo ? isolate non subs from each other, but how exactly
		# for entry_line, callers in blocks.items() :
			# blockname, block = self.import_block(entry_line)
			# self.blocks[blockname] = Block(entry_line,blockname,block,callers)
		
		newtpl_pth = tpl_pth.joinpath(src.stem)
		newtpl_pth.mkdir(exist_ok=True)
		
		# todo : versioning. for now static dest paths
		# as assets.py is also static
		# tme = strftime('%Y-%m-%d_%H-%M-%S')
		# newtpl_pth = newtpl_pth.joinpath(tme)
		# newtpl_pth.mkdir(exist_ok=True)
		
		## write a file with all non-subs in it
		dst = newtpl_pth.joinpath('main.asc.tpl')
		print('writing main code in %s'%(dst))
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# MAIN\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for k, v in self.generated.items() :
				if k not in self.isinablock :
					f.write(v+'\n')
		
		## write a file with all subs in it
		dst = newtpl_pth.joinpath('subs.asc.tpl')
		print('writing %s subs in %s'%(len(self.subblocks),dst))
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# SUBS\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for blockname, block in self.subblocks.items() :
				for l in block.get_tpl() :
					f.write(l+'\n')
				f.write('\n')
		
		## write all
		dst = newtpl_pth.joinpath('all.asc.tpl')
		print('writing everything in %s'%(dst))
		with open(dst,'w',newline='\r\n') as f : 
			# todo header here
			f.write('# ALL\n')
			f.write('# generated from ...\n')
			f.write('\n')
			for k, v in self.generated.items() :
				f.write(v+'\n')
		
	def import_block(self,sub_entry_line,prefix='GO') :

		## block name : either reuse preexisting one
		# or create a default one
		# if sub_entry_line in self.named_blocks :
			# blockname = self.named_blocks[sub_entry_line]
		# else :
			# blockname = '%s_%s'%(prefix,str(sub_entry_line))
		
		try :
			isanum = int(sub_entry_line)
			blockname = '%s_%s'%(prefix,str(sub_entry_line))
		# entry point as a variable case (goto SOMEVAR)
		except :
			# print('gosub entry point is named %s'%sub_entry_line)
			blockname = sub_entry_line
			if sub_entry_line in self.named_blocks :
				print('%s named block exist at line %s'%(sub_entry_line,self.named_blocks[sub_entry_line]))
				sub_entry_line = self.named_blocks[sub_entry_line]
			else :
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
			
			## end sub detection
			# todo : test is dirty, does not cover all conditionnal returns cases
			# any line with a RETURN but with a THEN or ELSE keyword is not considered
			# as a sub end.
			# so stuff like IF A=1 THEN B=3 : RETURN ELSE B=4 : RETURN are missed.
			if 'return' not in code or 'then' in code or 'else' in code :
				idx += 1
				if idx < len(self.lines) :
					line = self.lines[idx]
				
		return blockname, block
	
	# todo
	def summary(self) :
		# summary
		print('%s lines'%(len(self.lines)))
		print('from line %s to %s'%(self.lines[0],self.lines[-1]))
		# print('%s callers'%(len(self.callers)))
		# print('%s blocks'%(len(self.blocks)))
		# print('%s subblocks'%(len(self.subblocks)))
		print('%s returns'%(len(self.rtns)))
		# check number of blocks
		# test = set()
		# for v in self.callers.values() :
			# for j in v : test.add(j)
		# print(test)
		# print(len(test))
	
	def listmain(self) :
	
		for k,v in self.main.items() : print('%s %s'%(k,v))
	
def generate() :
	for floppy_name, content in FLOPPIES.items() :
		dest_pth = builds_pth.joinpath(floppy_name)
		dest_pth.mkdir(exist_ok=True)
		abort=False
		print('* Generating floppy %s'%(floppy_name))
		print('* in %s :'%(dest_pth))
		
		if 'ASSETS' in content and not(abort) :
			for file_name in content['ASSETS'] :
				print(' adding %s'%file_name)
				src = assets_pth.joinpath(file_name)
				if not(src.is_file()) :
					print(' %s not found.\n* Abort floppy %s'%(src,floppy_name))
					abort=True
					break
				dst = dest_pth.joinpath(file_name)
				copy(src,dst)
		if 'SOURCES' in content and not(abort) :
			for file_name in content['SOURCES'] :
				print(' adding %s'%file_name)
				src = dev_pth.joinpath(file_name)
				if not(src.is_file()) :
					print(' %s not found.\n* Abort floppy %s'%(src,floppy_name))
					abort=True
					break
				dst = dest_pth.joinpath(file_name)
				copy(src,dst)
		if 'TEMPLATES' in content and not(abort) :
			for file_name, tpl_names in content['TEMPLATES'].items() :
				
				dst = dest_pth.joinpath(file_name)					
				print(' generating %s'%file_name)
				generated = []
				pointers = {}
				lnb = 10
				lnbinc = 10
				for tpl_name in tpl_names :
					print('  adding %s'%tpl_name)
					src = tpl_pth.joinpath(tpl_name)
					if not(src.is_file()) :
						print(' %s not found.\n* Abort floppy %s'%(src,floppy_name))
						abort=True
						break
					
					with open(src) as f : 
						for li,line in enumerate(f.readlines()) :
							l = line.strip()
							if l :
								if l[0] == '#' : continue
								elif l[0] == '@' :
									generated.append('%s rem %s'%(lnb,l))
									v = len(l[1:])
									if v not in pointers : pointers[v] = []
									pointers[v].append( [ l[1:],str(lnb+lnbinc) ] )
								else :
									generated.append('%s %s'%(lnb,l))
								lnb += lnbinc
				
				# from the longest keywords to the smaller ones
				order = list(pointers.keys())
				order.sort()
				order.reverse()

				for li,line in enumerate(generated) :
					if 'rem' not in line.split()[1].lower() :
						for v in order :
							for keyword,line_number in pointers[v] :
								if keyword in line :
									generated[li] = generated[li].replace(keyword,line_number)
									
				print(' adding %s'%file_name)
				# print('\n'.join(generated))
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
	named_blocks = {}
	named_jumps = set()
	named_block = False
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
			prefix = 'GO_'
			blk = subblocks
		
		nextcode = code
		isjump = True
		
		for j in jumps :
			# jump line is a numeric, default name
			try :
				if j in named_blocks :
					# print(named_blocks[j])
					goj = named_blocks[j]
				else :
					goj = prefix+str(int(j))
			# jump line is named, keep this name
			# so either a named block exist (1st pass, rem @xxx)
			# or its a variable defined somewhere
			except :
				# if lower case, not a var
				if j != j.upper() :
					isjump = False
				# if chrs other than A-Z and _ , not a var
				else :
					for c in j :
						if not(c.isalpha()) and not(c=='_') :
							isjump = False
							break
				if not(isjump) : 
					# print('not a jump : %s'%j)
					break
				goj = j
				named_jumps.add(j)
			
			
			if j not in blk : blk[j] = []
			blk[j].append(lnum)
			# print('* %s   code %s %s'%(j,lnum,code))
			
			nextcode = nextcode[:start] + goj + nextcode[start+len(j):]
			start += len(goj)
			if start < len(nextcode) and nextcode[start] == ',' : start += 1
			# print('>',nextcode,start) ; k = input()
			
		return nextcode, start-1

	## 1st pass, get possible named blocks
	with open(src) as f :
		mark = False
		for li,line in enumerate(f.readlines()) :
			l = line.strip()
			if l :
				part = l.split()
				lnum = part[0]
				code = ' '.join(part[1:])
				
				## rem's with @ are named entry points :
				# means that the .asc was previously generated
				# from stosbuild : keep the name, don't add this rem yet (in 3rd pass)
				if part[1].lower() == 'rem' :
					if len(part) > 2 and part[2][0] == '@' :
						named_block = part[2][1:]
						print('found named block %s'%named_block)
						# imported[lnum] = ' '.join(part[2:])
						continue
				# if named by a rem @xxx, next line is the entry point
				elif named_block :
					named_blocks[lnum] = named_block
					named_block = False
				
				imported[lnum] = code
				
				# could be used to know wether each subs
				# is actually used
				codelow = code.lower()
				if 'return' in codelow :
					rtns.append(lnum)
					
	## 2nd pass, replace numeric jumps by variables
	for li,(lnum,code) in enumerate(imported.items()) :
		# print(lnum,code)
		if code.split()[0].lower() != 'rem' :
			start = 0
			while start < len(code) :
				codelow = code.lower()
				# get positions of every 'jumper'
				for needle in ['gosub','goto','restore','then','else'] :
					if codelow[start:start+len(needle)] == needle :
						if needle == 'gosub' : inblk=False 
						else : inblk = True
						code, start = getlines(needle,start,inblk)
						codelow = code.lower()
				
				start +=1
		generated[lnum] = code
		
	return Structure(src,generated,callers,blocks,subblocks,named_blocks,named_jumps,rtns)
	
def selectimport() :
	
	ascfiles = odict( (str(li+1),v) for li,v in enumerate( sorted(tpl_pth.glob('**/*.asc')) ) )
	if not(ascfiles) : print('No basic (*.asc) files found in %s'%builds_pth) ; return
	print('\nGenerate templates from :')
	for fi,f in ascfiles.items() :
		print(' %s %s'%(fi,f))
	print('Type a number to import the corresponding file : ')
	rep = input('Anything else to abort : ')
	print()
	if rep not in ascfiles : exit()
	ascfile = ascfiles[rep]
	return importasc(ascfile)

def main() :

	print('Press 1 to Generate basic from templates,')
	print('Press 2 to Generate templates from basic,')
	print('or anything else to abort : ',end='')
	rep = input()
	if rep == '1' : return generate()
	elif rep == '2' : return selectimport()
	exit()

st = main()