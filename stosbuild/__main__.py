# Sam Nasty - a board game for Atari ST.
# copyright (c) 2019,2020, jerome mahieux
# This file is part of Sam Nasty.

# Sam Nasty is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Sam Nasty is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Sam Nasty.  If not, see <https://www.gnu.org/licenses/>.
#
# GPL-3.0-or-later

import os
from assets import *
from shutil import copy
from pathlib import Path

root_pth = Path().cwd()
assets_pth = root_pth.joinpath('assets')
builds_pth = root_pth.joinpath('builds')
dev_pth = root_pth.joinpath('dev','alpha')

# print(root_pth)
# print(assets_pth)
# print(builds_pth)
# print(dev_pth)
# print('*')

builds_pth.mkdir(exist_ok=True)
dest_pth = builds_pth.joinpath(SAMNASTY['FLOPPY'])
dest_pth.mkdir(exist_ok=True)

print('Generating floppy %s'%(SAMNASTY['FLOPPY']))
print('in %s :'%(dest_pth))

for file_name in SAMNASTY['ASSETS'] :
	print(' adding %s'%file_name)
	src = assets_pth.joinpath(file_name)
	dst = dest_pth.joinpath(file_name)
	copy(src,dst)
for file_name in SAMNASTY['SOURCES'] :
	print(' adding %s'%file_name)
	src = dev_pth.joinpath(file_name)
	dst = dest_pth.joinpath(file_name)
	copy(src,dst)

print('Done.')
