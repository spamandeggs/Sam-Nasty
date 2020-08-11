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

rem SUB_SCROLLS_DEF
@SUB_SCROLLS_DEF
def scroll 1,0,0 to 320,184,8,0
def scroll 8,0,0 to 320,184,-8,0
def scroll 3,0,8*PTIT to 320,8*PTIT*2,-8,0
return

rem WAIT FOR ANY KEY PRESSED OR FIRE
@SUB_WAIT_KEY_FIRE
if inkey$="" and joy<16 then SUB_WAIT_KEY_FIRE
clear key
return

rem WAIT FOR FIRE
@SUB_WAIT_FIRE
while joy<16 : wend
return

rem WAIT FOR FIRE
@SUB_WAIT_FIRE_RELEASE
while joy>=16 : wend
return

rem MOUSE
@WAIT_MOUSE1_RELEASE
while mouse key=1 : wend : return
@WAIT_MOUSE2_RELEASE
while mouse key=2 : wend : return
@WAIT_MOUSE2_RELEASE
while mouse key=3 : wend : return
@WAIT_MOUSE_RELEASE
while mouse key=3 or mouse key=2 or mouse key=1 : wend : return

rem WAIT FOR FIRE
@SUB_WAIT_FIRE_RELEASE
while joy>=16 : wend
return



rem WAIT FOR ANY KEY OR FIRE RELEASE
@SUB_WAIT_KEY_FIRE_RELEASE_DELAY
DELAY=0 : MXDELAY=200 : key speed 1,1 : while joy>=16 : wend
@WAITKFR
if inkey$="" then inc DELAY else DELAY=0 : clear key
if DELAY<MXDELAY then WAITKFR
clear key
return

rem DELAY 4 SECS OR FIRE/ANY KEY (1 SEC MIN.)
@SUB_WAIT_KEY_FIRE_DELAY
timer=0 : clear key : key speed 1,1
while timer<200
if timer<50 then WAITKF
if joy>=16 then timer=200
if inkey$<>"" then timer=200
@WAITKF
wend
gosub SUB_WAIT_KEY_FIRE_RELEASE_DELAY
return

rem SUB FADE OUT TO LEVEL COLOR
@SUB_FADE_LEVEL
fade 5,COLLVL(0),COLLVL(1),COLLVL(2),COLLVL(3),COLLVL(4),COLLVL(5),COLLVL(6),COLLVL(7),COLLVL(8),COLLVL(9),COLLVL(10),COLLVL(11),COLLVL(12),COLLVL(13),COLLVL(14),COLLVL(15) : wait 35
return

rem SUB ALL OF FAME COLOR
@SUB_FADE_HALL
fade 5,$0,$770,$760,$750,$740,$730,$720,$710,$700,$600,$500,$777,$666,$0,$0,$777 : wait 35
return

rem SUB FADE TO BLACK COMMON
@SUB_FADE_BLACK
fade 3 : wait 21 : sprite off : move off : flash off : cls logic : cls back
return

rem exit to STOS or gem
@GO_EXIT
default : key speed 6,6
if errl<>0 then print "code erreur : ";errl : wait key
erase 2 : end

