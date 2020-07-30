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

root_pth = Path().cwd()
assets_pth = root_pth.joinpath('assets')
builds_pth = root_pth.joinpath('builds')
tpl_pth = root_pth.joinpath('sources')
dev_pth = root_pth.joinpath('sources')

builds_pth.mkdir(exist_ok=True)

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