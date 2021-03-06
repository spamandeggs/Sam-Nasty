# Sam Nasty Template
# Copyright (c) 2020, jerome mahieux
# This file is part of Sam Nasty Template.
#
# Sam Nasty Template is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Sam Nasty Template is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Sam Nasty Template.  If not, see <https://www.gnu.org/licenses/>.
# 
# GPL-3.0-or-later

rem  Sam Nasty - a board game for Atari ST.
rem  Copyright (c) 1995,2019,2020, jerome mahieux
rem  This file is part of Sam Nasty.
rem 
rem  Sam Nasty is free software: you can redistribute it and/or modify
rem  it under the terms of the GNU General Public License as published by
rem  the Free Software Foundation, either version 3 of the License, or
rem  (at your option) any later version.
rem 
rem Sam Nasty is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem 
rem You should have received a copy of the GNU General Public License
rem along with Sam Nasty.  If not, see <https://www.gnu.org/licenses/>.
rem 
rem GPL-3.0-or-later

clear
COMPILED=0 : COMPDELAY=1 : DEVEL=0 : TRACE=0

on error goto GO_EXIT
if COMPILED=1 then break off

clear key : hide : mode 0 : curs off : reset zone : colour 14,$0 : key off : click off : fade 1

rem load panel
reserve as data 2,5585
bload "SAM0.BLK",2 : unpack 2,back : erase 2
get palette (back) : screen copy back to logic
dim COLINTRO(15) : for I=0 to 15 : COLINTRO(I)=colour(I) : next I

gosub SUB_GET_BANKCOUNT