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

@SUB_LEVEL_ARRAYS
BANK=0 : FIRSTLVLSCR=4 : BANKSIZE=32768 : I=0 : RESERV=int(BANKSIZE*1.5)
while free>RESERV and FIRSTLVLSCR+I<10
reserve as screen FIRSTLVLSCR+I : inc I
wend : if I=1 then I=2
BANKCOUNT=I-1 : dim LVLBANK(BANKCOUNT)
dim MP(BANKCOUNT,1,40,22),MOUSKY(BANKCOUNT),SP(BANKCOUNT,8),XM(BANKCOUNT,8),YM(BANKCOUNT,8)
dim SBLK(BANKCOUNT,7,2),RTRP$(BANKCOUNT,8),XD(BANKCOUNT),YD(BANKCOUNT),NTS(BANKCOUNT),NTZ(BANKCOUNT),CZI(BANKCOUNT)
dim AN$(BANKCOUNT,8,10),MOV$(BANKCOUNT,8,10),SS(BANKCOUNT,8),FLP(BANKCOUNT,8),ST(BANKCOUNT,9),AL(BANKCOUNT,8),AL2(BANKCOUNT,8)
dim ZNE(BANKCOUNT,110),X1Z(BANKCOUNT,110),X2Z(BANKCOUNT,110),Y1Z(BANKCOUNT,110),Y2Z(BANKCOUNT,110)
dim DGEM$(BANKCOUNT,8,3),ACT$(BANKCOUNT,80),NZID(BANKCOUNT,10),NZIO(BANKCOUNT,10),NZIF(BANKCOUNT,10),CTIM(BANKCOUNT,10)
dim LIN$(BANKCOUNT),ZNE2(BANKCOUNT,80)
return

@SUB_SCROLLS_DEF
def scroll 1,0,0 to 320,184,8,0
def scroll 8,0,0 to 320,184,-8,0
def scroll 3,0,8*PTIT to 320,8*PTIT*2,-8,0
rem specific game
def scroll 4,0,160 to 320,168,-4,0
def scroll 10,0,168 to 320,176,4,0
def scroll 9,0,168 to 320,176,8,0
return

@SUB_LEVEL_DRAW
cls : gosub SUB_SCROLLS_DEF
auto back off
for NV=0 to 1
for Y=0 to 22 : for X=1 to 39 step 2
if MP(NBPL,NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NBPL,NV,X,Y))
next X : next Y
scroll 1 : ink 0 : bar 0,0 to 7,183
for Y=0 to 22 : for X=0 to 40 step 2
if MP(NBPL,NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NBPL,NV,X,Y))
next X : next Y
LIN$(NV)=screen$(logic,0,0 to 16,184) : cls logic,0,0,0 to 16,184 : scroll 8
next NV : scroll 1 : auto back on
for I=0 to 1 : screen$(logic,0,0)=LIN$(I) : next I
screen copy logic to back
return

@SUB_VAR_ESY
PTSEXTRALIFE=15000 : LVLMAXTIME=120
PTSTIME=150
PTSLIVES=1500
PTSLVL=1000
PTSGUARD=50
PTSCOIN=100
PTSWREATH=500
LIFES=6
HINTATLVL=3
return

@SUB_VAR_NRMAL
PTSEXTRALIFE=20000 : LVLMAXTIME=90
PTSTIME=150
PTSLIVES=1500
PTSLVL=1000
PTSGUARD=50
PTSCOIN=100
PTSWREATH=500
LIFES=4
HINTATLVL=3
return

@SUB_VAR_HARD
PTSEXTRALIFE=30000 : LVLMAXTIME=60
PTSTIME=150
PTSLIVES=1500
PTSLVL=1000
PTSGUARD=50
PTSCOIN=100
PTSWREATH=500
LIFES=3
HINTATLVL=3
return

rem SUB FADE TO BLACK COMMON
@FADE_TO_BLACK
fade 3 : wait 21 : sprite off : move off : flash off : cls
return

rem SUB FADE OUT TO LEVEL COLOR
@FADE_TO_LEVELCOL
fade 5,COLLVL(0),COLLVL(1),COLLVL(2),COLLVL(3),COLLVL(4),COLLVL(5),COLLVL(6),COLLVL(7),COLLVL(8),COLLVL(9),COLLVL(10),COLLVL(11),COLLVL(12),COLLVL(13),COLLVL(14),COLLVL(15) : wait 35 : return

rem SUB ALL OF FAME COLOR
@FADE_TO_FAMECOL
fade 5,$0,$770,$760,$750,$740,$730,$720,$710,$700,$600,$500,$777,$666,$0,$0,$777 : wait 35 : return

rem SUB INTRO COLOR - not used
@FADE_TO_INTROCOL
10740 palette COLINTRO(0),COLINTRO(1),COLINTRO(2),COLINTRO(3),COLINTRO(4),COLINTRO(5),COLINTRO(6),COLINTRO(7),COLINTRO(8),COLINTRO(9),COLINTRO(10),COLINTRO(11),COLINTRO(12),COLINTRO(13),COLINTRO(14),COLINTRO(15)
10745 return

rem WAIT FOR ANY KEY PRESSED OR FIRE
@WAIT_KEY_OR_FIRE
if inkey$="" and joy<16 then WAIT_KEY_OR_FIRE
clear key
return

rem WAIT FOR ANY KEY OR FIRE RELEASE
@WAIT_RELEASE
DELAY=0 : MXDELAY=200 : key speed 1,1 : while joy>=16 : wend
if inkey$="" then inc DELAY else DELAY=0 : clear key
if DELAY<MXDELAY then 10810
clear key
return

rem DELAY 4 SECS OR FIRE/ANY KEY (1 SEC MIN.)
@WAIT_4SECS
10500 timer=0 : clear key : key speed 1,1
10510 while timer<200
10515 if timer<50 then 10540
10520 if joy>=16 then timer=200
10530 if inkey$<>"" then timer=200
10540 wend
10550 gosub 10800
10560 return

rem exit to STOS or gem
@GO_EXIT
default : key speed 6,6
if errl<>0 then print "code erreur : ";errl : wait key
erase 2 : end