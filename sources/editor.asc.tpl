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

gosub SUB_SCROLLS_DEF
gosub SUB_SCROLLS_EDITOR

rem common arrays (but are of 2 dimensions in game)
dim MP(3,40,22)
dim AN$(8,10),MOV$(8,10),SS(8)
dim AL(8),AL2(8)
dim SBLK(7,2),RTRP$(8)
dim DGEM$(8,3),ACT$(80),NZID(10),NZIO(10)
dim NZIF(10),CTIM(10)
dim LIN$(1)

rem editor arrays
dim FL(8)

rem patch
MUS=0 : FX=1 : DEMO=0

SP(NBPL,1)=2 : NTS(NBPL)=1 : XD=148 : YD=103
for I=0 to 10 : NZIO(I)=1 : NZIF(I)=1 : next I
for I=0 to 8 : SS(I)=-1 : next I

rem BRICKS CREATION
reserve as screen 2 : reserve as data 3,16613
bload "SAM1.BLK",3 : cls back : unpack 3,2
erase 3
get palette (back) : wait 50 : dim COLLVL(15) : for I=0 to 15 : COLLVL(I)=colour(I) : colour I,0 : next I
screen copy 2,0,0,320,8*PTIT to logic,0,0

rem to misc differences between game and editor cuts
screen copy logic,0,0,320,8*PTIT to logic,0,8*PTIT
scroll 3 : screen copy logic to back
ink 0 : for X=1 to 40 step 2 : bar X*8,0 to X*8+7,8*PTIT*2 : next X
DEP=0 : ARR=7 : XDEP=0 : XARR=28
rem edit if renum
@CUT_LOOP
for Y=DEP*8 to ARR*8 step 8 : for X=(XDEP*8)+1 to XARR*8 step 16
inc IND : BLK$(IND)=screen$(back,X,Y to X+15,Y+8)
inc IND : BLK$(IND)=screen$(back,X,Y+8*PTIT to X+15,Y+8+8*PTIT) : next X : next Y
if CISO=15 then goto CUT_END
if CISO=0 then DEP=9 : ARR=10 : XDEP=0 : XARR=26 : CISO=1 : goto CUT_LOOP
if CISO=1 then BLK$(328)=BLK$(263) : BLK$(329)=BLK$(264) : BLK$(263)=BLK$(273) : BLK$(264)=BLK$(274)
if CISO=1 then IND=IND-4 : DEP=0 : ARR=1 : XDEP=29 : XARR=36 : CISO=2 : goto CUT_LOOP
if CISO=2 then IND=IND-3 : DEP=4 : ARR=4 : XDEP=31 : XARR=40 : CISO=3 : goto CUT_LOOP
if CISO=3 then DEP=5 : ARR=6 : XDEP=29 : XARR=40 : CISO=4 : goto CUT_LOOP
if CISO=4 then DEP=9 : ARR=9 : XDEP=31 : XARR=38 : CISO=11 : goto CUT_LOOP
if CISO=11 then IND=IND+2 : DEP=8 : ARR=8 : XDEP=0 : XARR=36 : CISO=12 : goto CUT_LOOP
if CISO=12 then DEP=7 : ARR=7 : XDEP=29 : XARR=40 : CISO=5 : goto CUT_LOOP
if CISO=5 then DEP=0 : ARR=0 : XDEP=36 : XARR=40 : CISO=6 : goto CUT_LOOP
if CISO=6 then DEP=1 : ARR=1 : XDEP=35 : XARR=40 : CISO=7 : goto CUT_LOOP
if CISO=7 then DEP=2 : ARR=3 : XDEP=29 : XARR=40 : CISO=8 : goto CUT_LOOP
if CISO=8 then DEP=4 : ARR=4 : XDEP=29 : XARR=30 : CISO=9 : goto CUT_LOOP
if CISO=9 then DEP=9 : ARR=9 : XDEP=29 : XARR=29 : CISO=10 : goto CUT_LOOP
if CISO=10 then DEP=9 : ARR=9 : XDEP=39 : XARR=40 : CISO=13 : goto CUT_LOOP
if CISO=13 then DEP=9 : ARR=9 : XDEP=34 : XARR=34 : CISO=17 : goto CUT_LOOP
BLK$(365)=BLK$(291)
for I=1 to 30 : inc IND : BLK$(IND)=BLK$(56) : next I
swap BLK$(323),BLK$(320) : swap BLK$(328),BLK$(325) : swap BLK$(329),BLK$(326) : swap BLK$(326),BLK$(327)
for I=365 to 368 : BLK$(I+100)=BLK$(I) : BLK$(I)=BLK$(56) : next I
for I=369 to 415 : BLK$(I+101)=BLK$(I) : if I<379 or I>380 then BLK$(I)=BLK$(56)
next I
IND=364 : DEP=10 : ARR=10 : XDEP=26 : XARR=40 : CISO=15 : goto CUT_LOOP
rem CUT_END
@CUT_END
BLK$(469)=BLK$(319) : BLK$(379)=BLK$(416) : BLK$(380)=BLK$(417)

rem ****************
A=0 : for X=1 to 320 step 16 : inc A : IC$(A)=screen$(2,X,184 to X+15,200) : ICSIZE(A,0)=16 : ICSIZE(A,1)=16 : next X
inc A : IC$(A)=screen$(2,144,168 to 192,184) : ICSIZE(A,0)=0 : ICSIZE(A,1)=0
inc A : IC$(A)=screen$(2,96,168 to 144,184) : ICSIZE(A,0)=0 : ICSIZE(A,1)=0
inc A
rem ****************
ink 0 : bar 0,0 to 319,PTIT*8+8 : screen copy 2,0,88,320,104 to logic,0,0
screen copy logic,0,0,320,16 to logic,0,16
scroll 4 : screen copy logic to back
ink 0 : for X=1 to 40 step 2 : bar X*8,0 to X*8+7,32 : next X
screen copy logic,0,0,320,32 to logic,0,32
scroll 7 : screen copy logic to back : bar 0,32 to 7,63
for X=1 to 144 step 16
inc A : IC$(A)=screen$(logic,X,0 to X+15,16) : IC$(A+100)=screen$(logic,X,32 to X+15,48) : ICSIZE(A,0)=8 : ICSIZE(A,1)=16
inc A : IC$(A)=screen$(logic,X,16 to X+15,32) : IC$(A+100)=screen$(logic,X,48 to X+15,64) : ICSIZE(A,0)=8 : ICSIZE(A,1)=16
next X
rem ***********************************
rem
rem
rem
rem
rem
remfade 1 to 2 : for A=200 to 600 : screen$(logic,100,100)=BLK$(A) : locate 0,10 : print A : wait key : bar 100,100 to 108,108 : next A
cls back : cls logic : CH1=19 : CH2=148 : show : goto EDITOR_MAIN_DRAW

rem *******************************************************************
rem * CONSTRUCTION KIT *
rem *******************************************************************
@LEVEL_DRAW_LAST
hide : cls logic,0,0,0 to 320,184 : cls back,0,0,0 to 320,184
auto back off
for NV=0 to 1
for Y=0 to 22 : for X=1 to 39 step 2
if MP(NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NV,X,Y))
next X : next Y
scroll 1 : ink 0 : bar 0,0 to 7,183
for Y=0 to 22 : for X=0 to 40 step 2
if MP(NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NV,X,Y))
next X : next Y
LIN$(NV)=screen$(logic,0,0 to 16,184) : cls logic,0,0,0 to 16,184 : scroll 8
next NV
scroll 1 : auto back on
for I=0 to 1 : screen$(logic,0,0)=LIN$(I) : next I
screen copy logic to back
show : return

@LEVEL_DRAW
hide : cls logic,0,0,0 to 320,184 : cls back,0,0,0 to 320,184
auto back off
for NV=0 to 1 : for Y=0 to 22 : for X=1 to 39 step 2
if MP(NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NV,X,Y))
next X : next Y : next NV
scroll 1 : ink 0 : bar 0,0 to 7,183
for NV=0 to 1 : for Y=0 to 22 : for X=0 to 40 step 2
if MP(NV,X,Y)<>0 then screen$(logic,X*8,Y*8)=BLK$(MP(NV,X,Y))
next X : next Y : next NV 
auto back on : screen copy logic to back
show : return

rem editor panel : main
@EDITOR_MAIN_DRAW
while joy>=16 : wend : fade 5 to 2 : reset zone : gosub GO_5260
IC_ID=9 : IC_X=0 : IC_Z=1 : gosub EDITOR_BUTTON_DRAW
IC_ID=10 : IC_X=2 : IC_Z=2 : gosub EDITOR_BUTTON_DRAW
IC_ID=11 : IC_X=4 : IC_Z=3 : gosub EDITOR_BUTTON_DRAW
IC_ID=12 : IC_X=6 : IC_Z=4 : gosub EDITOR_BUTTON_DRAW
IC_ID=13 : IC_X=8 : IC_Z=5 : gosub EDITOR_BUTTON_DRAW
IC_ID=14 : IC_X=10 : IC_Z=6 : gosub EDITOR_BUTTON_DRAW
IC_ID=18 : IC_X=12 : IC_Z=7 : gosub EDITOR_BUTTON_DRAW
screen copy back to logic

rem ******************************
rem * MAIN *
rem ******************************
@GO_1040
ZM=zone(0) : if joy>=16 then ZM=1 : goto GO_1060 : else if mouse key=1 and ZM<>0 then GO_1060
K$=inkey$ : if COMPILED=0 and asc(K$)=27 then goto GO_EXIT
goto GO_1040

@GO_1060
clear key : reset zone : gosub WAIT_MOUSE1_RELEASE : ink 0 : bar 0,184 to 319,199 : on ZM goto GAME_INIT,EDITOR_BRICKS_DRAW,EDITOR_BRICKS_DRAW,EDITOR_SPRITES_DRAW,EDITOR_ZONES,EDITOR_FILE_DRAW
gosub LEVEL_DRAW : goto EDITOR_MAIN_DRAW

rem editor panel : zones
@EDITOR_ZONES
NV=2 : ZZ=1 : X=0 : VAR=1 : pen 15

@EDITOR_ZN0
locate 17,24 : print NTZ(NBPL);
gosub EDITOR_BUTTONS_ZONES
if ZNE(NBPL,ZZ)=0 then pen 3 else pen 15
locate 3,24 : print using "###";ZZ; : pen 15
if LK=0 then EDITOR_ZN1 else locate 9,24 : print using "###";ZNE(NBPL,ZZ);
if RDY=0 then if ZNE(NBPL,ZZ)>=30 and ZNE(NBPL,ZZ)<=39 then gosub GO_2520
if RDY2=0 then if ZNE(NBPL,ZZ)>=40 and ZNE(NBPL,ZZ)<=59 then gosub GO_2550
if RDY3=0 then if ZNE(NBPL,ZZ)>=80 and ZNE(NBPL,ZZ)<=110 then gosub GO_2600
if RDY4=0 then if ZNE(NBPL,ZZ)>=60 and ZNE(NBPL,ZZ)<=79 then gosub GO_2550
@EDITOR_ZN1
gosub EDITOR_ZONES_SHOW
@EDITOR_ZN2
Z=zone(0) : if Z<>0 and mouse key<>0 then EDITOR_ZN3
if mouse key=3 and LK=1 then if ZNE(NBPL,ZZ)>=30 and ZNE(NBPL,ZZ)<=39 then bell : X=ZNE(NBPL,ZZ)-30 : goto GO_1810
K$=inkey$
if K$=" " then K$="" : clear key : gosub LEVEL_DRAW
if K$="2" or K$="3" then if ZNE(NBPL,ZZ)>=40 and ZNE(NBPL,ZZ)<=59 then ZNE2(NBPL,ZNE(NBPL,ZZ)-30)=val(K$) : bell : clear key : K$=""
if K$="0"           then if ZNE(NBPL,ZZ)>=40 and ZNE(NBPL,ZZ)<=59 then ZNE2(NBPL,ZNE(NBPL,ZZ)-30)=val(K$) : bell : clear key : K$=""
clear key : K$=""
goto EDITOR_ZN2
@EDITOR_ZN3
if mouse key=1 then gosub WAIT_MOUSE1_RELEASE
if Z=1 then sprite off : RDY=0 : RDY2=0 : RDY3=0 : RDY4=0 : goto EDITOR_MAIN_DRAW
if Z<>6 or NTZ(NBPL)=0 then GO_1320 else if LK=0 then LK=1 else LK=0
RDY=0 : RDY2=0 : RDY3=0 : sprite off : reset zone : Z=5 : goto EDITOR_ZONES
@GO_1320
if LK=1 then GO_1370
if Z=2 then sprite off : dec ZZ : if ZZ=0 then ZZ=NTZ(NBPL)+1
if Z=3 then sprite off : inc ZZ : if ZZ=NTZ(NBPL)+2 then ZZ=1
if Z=4 then EDITOR_ZONES_DEL
if Z=5 then gosub EDITOR_ZONES_CREATE
goto EDITOR_ZN0
@GO_1370
rem *** main selection des effets/zones ***
rem
if Z=2 then sprite off : dec ZZ : if ZZ=0 then ZZ=NTZ(NBPL)
if Z=3 then sprite off : inc ZZ : if ZZ=NTZ(NBPL)+1 then ZZ=1
if Z=4 then for I=2 to NTS(NBPL) : sprite off I : next I : KIL=0 : dec ZNE(NBPL,ZZ) : if ZNE(NBPL,ZZ)=0 then ZNE(NBPL,ZZ)=OPTN
if Z=5 then for I=2 to NTS(NBPL) : sprite off I : next I : KIL=0 : inc ZNE(NBPL,ZZ) : if ZNE(NBPL,ZZ)=OPTN+1 then ZNE(NBPL,ZZ)=1
if ZNE(NBPL,ZZ)>=30 and ZNE(NBPL,ZZ)<=39 then GO_1690
if ZNE(NBPL,ZZ)>=80 and ZNE(NBPL,ZZ)<=110 then GO_1480
if ZNE(NBPL,ZZ)>=40 and ZNE(NBPL,ZZ)<=79 then GO_1940
if ZNE(NBPL,ZZ)<=29 then if RDY=1 or RDY3=1 then for I=10 to 15 : reset zone I : next I : cls back,0,128,184 to 304,200 : cls logic,0,128,184 to 304,200 : RDY3=0 : RDY=0
goto EDITOR_ZN0

@GO_1480
rem *** selection effet pour zones/cond. ***
X=ZNE(NBPL,ZZ)-30 : if RDY3=0 then gosub GO_2600
if Z=10 then dec VAR2 : if VAR2=-1 then VAR2=4
if Z=11 then inc VAR2 : if VAR2=5 then VAR2=0
if Z<>13 then GO_1570 else if VAR2<>0 then bell : ACT$(X)=ACT$(X)+str$(ZZ)+"/"+str$(VAR2)+"/"+str$(ZNE(NBPL,ZZ))+"/" : if VAR2<>2 then GO_2420 else GO_1570
if NTS(NBPL)=1 then GO_1570 else bell : gosub GO_2330
@GO_1540
Z=zone(0) : if mouse key=1 then gosub WAIT_MOUSE1_RELEASE : if Z>=18 then GO_1620
if mouse key=2 then bell : sprite off : for I=18 to NTS(NBPL)+18 : reset zone I+NTS(NBPL) : next I : while mouse key=2 : wend : goto GO_1570
goto GO_1540
@GO_1570
if Z=12 then shoot : ACT$(X)=""
if Z=14 then if ZNE2(NBPL,X)=1 then ZNE2(NBPL,X)=0 else ZNE2(NBPL,X)=1 : bell
gosub GO_2630
goto EDITOR_ZN0
rem *** selection sprite pour zones/Act$ ***
@GO_1620
X=ZNE(NBPL,ZZ)-30 : FLC=Z-18 : AC3$=ACT$(X)
@GO_1630
FL2=val(AC3$) : gosub SET_FOUY : FL3=val(AC3$) : gosub SET_FOUY : if FL3<>0 then gosub SET_FOUY : if FL3=2 then GO_1650 else for I=1 to 8 : gosub SET_FOUY : next I : goto GO_1650
if FLC=FL2 then FOUY=instr(ACT$(X),str$(FLC)+"/0*/") : ACT$(X)=mid$(ACT$(X),1,FOUY-1)+AC3$ : ZERT=1
@GO_1650
if AC3$<>"" then GO_1630
if ZERT=0 then ACT$(X)=ACT$(X)+(str$(FLC)+"/0*/") : SSS=SP(NBPL,FLC)
ZERT=0 : X=0 : FL3=0 : gosub GO_2330 : goto GO_1540
rem *** cr‚ation zone intermittente(CZI) ***
@GO_1690
X=ZNE(NBPL,ZZ)-30 : if RDY=1 then GO_1700 else gosub GO_2520
@GO_1700
if Z=10 then dec NZID(X) : if NZID(X)=-1 then NZID(X)=100
if Z=11 then inc NZID(X) : if NZID(X)=101 then NZID(X)=0
if Z=12 then dec NZIO(X) : if NZIO(X)=0 then NZIO(X)=100
if Z=13 then inc NZIO(X) : if NZIO(X)=101 then NZIO(X)=1
if Z=14 then dec NZIF(X) : if NZIF(X)=0 then NZIF(X)=100
if Z=15 then inc NZIF(X) : if NZIF(X)=101 then NZIF(X)=1
@GO_1760
locate 17,24 : print using "###";NZID(X); : locate 23,24 : print using "###";NZIO(X); : locate 29,24 : print using "###";NZIF(X); : locate 35,24 : print using "#";ZNE2(NBPL,X);
goto EDITOR_ZN0

@GO_1780
I=0 : CZI=-1
@GO_1790
inc CZI : if ZNE2(NBPL,CZI)<>0 and ACT$(CZI)<>"" then GO_1790 else dec CZI
goto EDITOR_ZN0
@GO_1810
while mouse key<>0 : wend : pen 10 : PZNE=ZNE2(NBPL,X) : goto GO_1860
@GO_1820
Z=zone(0) : if mouse key=2 then pen 15 : if ZNE2(NBPL,X)<>2 then GO_2420 else if ZNE2(NBPL,X)<>0 then GO_1880 else ACT$(X)="" : CZI=X-1 : goto GO_1760
if mouse key<>1 then GO_1820 else gosub WAIT_MOUSE1_RELEASE
if Z=16 then dec ZNE2(NBPL,X) : if ZNE2(NBPL,X)=-1 then ZNE2(NBPL,X)=4
if Z=17 then inc ZNE2(NBPL,X) : if ZNE2(NBPL,X)=5 then ZNE2(NBPL,X)=0
@GO_1860
locate 35,24 : print using "#";ZNE2(NBPL,X);
goto GO_1820
@GO_1880
if PZNE<>2 then ACT$(X)="" : PZNE=0
FOUY=instr(ACT$(X),str$(ZZ)) : if FOUY=0 then ACT$(X)=ACT$(X)+str$(ZZ)+"/"
for I=0 to CZI : if I=X then GO_1920
if ZNE2(NBPL,I)=2 then FOUY=instr(ACT$(I),str$(ZZ)) : if FOUY<>0 then ACT$(I)=ACT$(I)-(str$(ZZ)+"/")
@GO_1920
next I : goto GO_1780
rem *** zones conditionn‚es au bouton ***
@GO_1940
X=ZNE(NBPL,ZZ)-30 : if RDY2=0 and RDY4=0 then gosub GO_2550
if KIL=0 then gosub GO_2640
if Z<>10 then GO_2010 else PVAR=VAR
@GO_1970
dec VAR : if VAR=0 then VAR=NTZ(NBPL)
gosub GO_2590
if ZNE(NBPL,VAR)>=80 and ZNE(NBPL,VAR)<=110 then bell else if VAR<>PVAR then GO_1970 else EDITOR_ZN0
swap ZZ,VAR : gosub EDITOR_ZONES_SHOW : swap ZZ,VAR : wait 5
@GO_2010
if Z<>11 then GO_2060 else PVAR=VAR
@GO_2020
inc VAR : if VAR=NTZ(NBPL)+1 then VAR=1
gosub GO_2590
if ZNE(NBPL,VAR)>=80 and ZNE(NBPL,VAR)<=110 then bell else if VAR<>PVAR then GO_2020 else EDITOR_ZN0
swap ZZ,VAR : gosub EDITOR_ZONES_SHOW : swap ZZ,VAR : wait 5
@GO_2060
if Z=13 and ZNE(NBPL,VAR)>=80 then bell : ACT$(X)=ACT$(X)+ACT$(ZNE(NBPL,VAR)-30) : gosub GO_2640
if Z=12 then shoot : ACT$(X)="" : gosub GO_2640
if Z=15 then if ZNE2(NBPL,X)=1 then ZNE2(NBPL,X)=0 else ZNE2(NBPL,X)=1 : bell
goto EDITOR_ZN0

rem *** effacement d'une zone ***
@EDITOR_ZONES_DEL_LAST
if ZNE(NBPL,ZZ)<>0 then sprite off else EDITOR_ZN2
if ZNE(NBPL,ZZ)>=30 then ACT$(ZNE(NBPL,ZZ)-30)=""
ZNE(NBPL,ZZ)=0 : X1Z(NBPL,ZZ)=1 : Y1Z(NBPL,ZZ)=1 : X2Z(NBPL,ZZ)=2 : Y2Z(NBPL,ZZ)=2
goto EDITOR_ZN0

@EDITOR_ZONES_DEL
if ZNE(NBPL,ZZ)=0 then EDITOR_ZN2
sprite off
ZZI=ZZ
while ZZ<NTZ(NBPL)
ZNE(NBPL,ZZ)=ZNE(NBPL,ZZ+1)
X1Z(NBPL,ZZ)=X1Z(NBPL,ZZ+1)
Y1Z(NBPL,ZZ)=Y1Z(NBPL,ZZ+1)
X2Z(NBPL,ZZ)=X2Z(NBPL,ZZ+1)
Y2Z(NBPL,ZZ)=Y2Z(NBPL,ZZ+1)
if ZNE(NBPL,ZZ)>=30 then ACT$(ZNE(NBPL,ZZ)-30)=ACT$(ZNE(NBPL,ZZ+1)-30)
ZZ=ZZ+1
wend
if ZNE(NBPL,ZZ)>=30 then ACT$(ZNE(NBPL,ZZ)-30)=""
ZNE(NBPL,ZZ)=0 : X1Z(NBPL,ZZ)=0 : Y1Z(NBPL,ZZ)=0 : X2Z(NBPL,ZZ)=0 : Y2Z(NBPL,ZZ)=0
NTZ(NBPL)=ZZ-1 if ZZI>NTZ(NBPL) then ZZ=NTZ(NBPL)+1 else ZZ=ZZI
goto EDITOR_ZN0

rem *** creation d'une zone ***
@EDITOR_ZONES_CREATE
if ZNE(NBPL,ZZ)<>0 then dec NTZ(NBPL) else ZNE(NBPL,ZZ)=1
sprite off : hide : Q=14
@EDITOR_ZNC0
if x mouse=319 then XB=319 else XB=(x mouse/8)*8
YB=(y mouse/8)*8
if mouse key=2 then XB=(x mouse/4)*4 : YB=(y mouse/4)*4
sprite Q,XB,YB,32
if mouse key=1 or mouse key=3 then while mouse key<>0 : wend : goto GO_2230
goto EDITOR_ZNC0

@GO_2230
if Q=14 then X1Z(NBPL,ZZ)=XB : Y1Z(NBPL,ZZ)=YB : Q=15 : goto EDITOR_ZNC0
X2Z(NBPL,ZZ)=XB : Y2Z(NBPL,ZZ)=YB : show
if X2Z(NBPL,ZZ)<X1Z(NBPL,ZZ) then swap X2Z(NBPL,ZZ),X1Z(NBPL,ZZ)
if Y2Z(NBPL,ZZ)<Y1Z(NBPL,ZZ) then swap Y2Z(NBPL,ZZ),Y1Z(NBPL,ZZ)
if X1Z(NBPL,ZZ)<>X2Z(NBPL,ZZ) then GO_2290 else if X1Z(NBPL,ZZ)>0 then X2Z(NBPL,ZZ)=X1Z(NBPL,ZZ) : dec X1Z(NBPL,ZZ) : goto GO_2290
X2Z(NBPL,ZZ)=X1Z(NBPL,ZZ)+1
@GO_2290
if Y1Z(NBPL,ZZ)<>Y2Z(NBPL,ZZ) then GO_2310 else if Y1Z(NBPL,ZZ)>0 then Y2Z(NBPL,ZZ)=Y1Z(NBPL,ZZ) : dec Y1Z(NBPL,ZZ) : goto GO_2310
Y2Z(NBPL,ZZ)=Y1Z(NBPL,ZZ)+1
@GO_2310
sprite 14,X1Z(NBPL,ZZ),Y1Z(NBPL,ZZ),94 : sprite 15,X2Z(NBPL,ZZ),Y2Z(NBPL,ZZ),94 : inc NTZ(NBPL) : return
rem *** creation d'un effet sprite(sub control) ***
@GO_2330
if NTS(NBPL)=1 then GO_2400 else FLC=0 : for I=0 to NTS(NBPL)-2 : FL(I)=0 : next I : AC3$=ACT$(ZNE(NBPL,ZZ)-30) : if AC3$="" then GO_2370
@GO_2340
FL2=val(AC3$) : gosub SET_FOUY : FL3=val(AC3$) : gosub SET_FOUY : if FL3<>0 then gosub SET_FOUY : if FL3=2 then GO_2360 else for I=1 to 8 : gosub SET_FOUY : next I : goto GO_2360
FL(FLC)=FL2 : if AC3$="" then GO_2370 else inc FLC : goto GO_2340
@GO_2360
if AC3$<>"" then GO_2340
@GO_2370
for I=2 to NTS(NBPL) : SSS=32 : for J=0 to FLC : if I=FL(J) then SSS=SP(NBPL,FL(J)) : J=FLC+1
next J
sprite I,XM(NBPL,I),YM(NBPL,I),SSS : set zone 18+I,XM(NBPL,I)-3,YM(NBPL,I)-15 to XM(NBPL,I)+3,YM(NBPL,I) : next I
@GO_2400
return
rem *** creation de briques alternatives ***
@GO_2420
X=ZNE(NBPL,ZZ)-30 : PZNE=0 : bell : TAY$=input$(1) : FOUY=0 : if ZNE(NBPL,ZZ)<80 or ZNE(NBPL,ZZ)>110 then ACT$(X)=str$(ZZ)+"/"
if X2Z(NBPL,ZZ)-X1Z(NBPL,ZZ)<Y2Z(NBPL,ZZ)-Y1Z(NBPL,ZZ) then ACT$(X)=ACT$(X)+str$((Y2Z(NBPL,ZZ)-Y1Z(NBPL,ZZ))/8*-1)+"/" else ACT$(X)=ACT$(X)+str$((X2Z(NBPL,ZZ)-X1Z(NBPL,ZZ))/8)+"/"
ACT$(X)=ACT$(X)+" "+TAY$+"/"+str$(X1Z(NBPL,ZZ))+"/"+str$(Y1Z(NBPL,ZZ))+"/"
@GO_2450
XB=(x mouse/8)*8+4 : YB=(y mouse/8)*8+4 : sprite 10,XB,YB,32 : if mouse key<>1 then GO_2450
gosub WAIT_MOUSE1_RELEASE
ACT$(X)=ACT$(X)+str$(XB-4)+"/"+str$(YB-4)+"/" : bell : inc FOUY : if FOUY=1 then XB2=XB : YB2=YB : goto GO_2450
XB=0 : YB=0 : XB2=0 : YB2=0 : FOUY=0 : sprite off 10 : goto GO_1780
rem ******** panel subs *********
@EDITOR_ZONES_SHOW
if X1Z(NBPL,ZZ)+Y1Z(NBPL,ZZ)+X2Z(NBPL,ZZ)+Y2Z(NBPL,ZZ)<>0 then sprite 14,X1Z(NBPL,ZZ),Y1Z(NBPL,ZZ),32 : sprite 15,X2Z(NBPL,ZZ),Y2Z(NBPL,ZZ),32 else sprite off
return
@GO_2520
for I=10 to 15 : reset zone I : next I : cls back,0,128,184 to 304,200 : cls logic,0,128,184 to 304,200 : RDY2=0 : RDY3=0 : RDY4=0
for I=0 to 6 step 2 : set zone 10+I,128+(I/2)*48,184 to 136+(I/2)*48,199 : set zone 11+I,160+(I/2)*48,184 to 168+(I/2)*48,199 : next I : AA=128 : BB=160 : gosub GO_4820 : AA=176 : BB=208 : gosub GO_4820 : AA=224 : BB=256 : gosub GO_4820 : AA=272 : BB=288 : gosub GO_4820 : RDY=1 : screen copy back to logic : set zone 17,288,184 to 296,199
locate 17,24 : print using "###";NZID(X); : locate 23,24 : print using "###";NZIO(X); : locate 29,24 : print using "###";NZIF(X); : locate 35,24 : print using "#";ZNE2(NBPL,X); : return
@GO_2550
for I=10 to 15 : reset zone I : next I : cls back,0,128,184 to 304,200 : cls logic,0,128,184 to 304,200 : RDY=0 : RDY3=0 : RDY4=0
for I=0 to 4 step 2 : set zone 10+I,128+(I/2)*48,184 to 136+(I/2)*48,199 : set zone 11+I,160+(I/2)*48,184 to 168+(I/2)*48,199 : next I : reset zone 15 : AA=128 : BB=160 : gosub GO_4820 : screen$(back,208,184)=IC$(30) : RDY2=1
if ZNE(NBPL,ZZ)>=60 and ZNE(NBPL,ZZ)<=79 then set zone 15,192,184 to 200,199 : screen$(back,192,184)=IC$(29) : RDY4=1 : RDY2=0
screen copy back to logic
@GO_2590
locate 17,24 : print using "###";VAR; : return
@GO_2600
for I=10 to 15 : reset zone I : next I : cls back,0,128,184 to 304,200 : cls logic,0,128,184 to 304,200
for I=0 to 4 step 2 : set zone 10+I,128+(I/2)*48,184 to 136+(I/2)*48,199 : set zone 11+I,160+(I/2)*48,184 to 168+(I/2)*48,199 : next I : reset zone 15 : AA=128 : BB=160 : gosub GO_4820 : screen$(back,176,184)=IC$(25) : screen$(back,208,184)=IC$(30) : screen$(back,224,184)=IC$(29) : RDY3=1 : RDY2=0 : RDY=0 : RDY4=0
screen copy back to logic
@GO_2630
locate 17,24 : print using "###";VAR2; : return
@GO_2640
if ACT$(X)<>"" then set zone 12,176,184 to 184,199 : screen$(back,176,184)=IC$(25) : screen$(logic,176,184)=IC$(25) : goto GO_2660
reset zone 12 : cls back,0,176,184 to 192,200 : cls logic,0,176,184 to 192,200
@GO_2660
KIL=1 : return

rem editor panel : bricks
@EDITOR_BRICKS_DRAW
SAUT=8 : gosub GO_4990
NV=0 : DC=1 : FC=380 : DF=465 : FF=516
P=9 : P2=369
gosub GO_4910 : gosub GO_4930 : gosub GO_4950
rem -------------------------------
@GO_2730
Z=zone(0) : if Z<>0 and mouse key<>0 then GO_3000
K$=inkey$ : if K$=" " then gosub LEVEL_DRAW
if y mouse>=184 then GO_2730
rem -------------------------------
hide : SAUT=8 : if CH1>=351 and CH1<=364 then SAUT=16
if CH1>=321 and CH1<=326 then SAUT=16 else if CH1=380 then SAUT=16
@GO_2780
X=(x mouse/SAUT)*SAUT : Y=(y mouse/8)*8 : sprite 1,X,Y,1
if Y>=184 then GO_2990
if mouse key=0 then GO_2780 else if Y>=184 then GO_2990
if GME=1 then bar X,Y to X+7,Y+7 : CH2=0 : CH1=0
if PRCT=1 or VRCT=1 then bell
if Y>=184 then GO_2990 else if CH1=CH2 then bar X,Y to X+7,Y+7
if GME=0 then put sprite 1
if CH2<>-1 then MP(0,X/8,Y/8)=CH2
if CH1<>-1 then MP(1,X/8,Y/8)=CH1
if GME=1 then CH2=288 : CH1=288 : goto GO_2910
if X<>0 then GO_2905 else if CH2<>-1 then screen$(back,X,Y)=BLK$(MP(0,X/8,Y/8))
if CH1<>-1 then screen$(back,X,Y)=BLK$(MP(1,X/8,Y/8))
screen copy back,X,Y,X+16,Y+8 to logic,X,Y
@GO_2905
if CH1>=321 and CH1<=326 then GO_2971 else if CH1=380 then GO_2971
@GO_2910
if PRCT=0 and VRCT=0 then GO_2780
if PRCT=2 then X2=X/8 : Y2=Y/8 : PRCT=1 : gosub GO_5050 : goto GO_2780
if VRCT=2 then X2=X/8 : Y2=Y/8 : VRCT=1 : gosub GO_5050 : goto GO_2780
if PRCT=1 then PRCT=2 else if VRCT=1 then VRCT=2
X1=X/8 : Y1=Y/8 : gosub WAIT_MOUSE1_RELEASE : goto GO_2780
if Y>=184 then GO_2990
goto GO_2780
@GO_2971
while mouse key=1 : wend : if X1Z(NBPL,NTZ(NBPL))=X and Y1Z(NBPL,NTZ(NBPL))=Y then GO_2780
inc NTZ(NBPL) : X1Z(NBPL,NTZ(NBPL))=X : Y1Z(NBPL,NTZ(NBPL))=Y : Y2Z(NBPL,NTZ(NBPL))=Y+22 : X2Z(NBPL,NTZ(NBPL))=X+16
if CH1=380 then ZNE(NBPL,NTZ(NBPL))=26 : goto GO_2780
ZNE(NBPL,NTZ(NBPL))=CH1-301 : goto GO_2780
rem -------------------------------
@GO_2990
sprite off 1 : show : X=0 : Y=0 : goto GO_2730
@GO_3000
if Z=1 then PRCT=0 : VRCT=0 : change mouse 1 : goto EDITOR_MAIN_DRAW
if Z=2 then dec P : if mouse key=1 then gosub GO_4910 else if mouse key=2 then P=0 : gosub GO_4910
if Z=3 then inc P : if mouse key=1 then gosub GO_4910 else if mouse key=2 then P=1000 : gosub GO_4910
if Z=4 then dec P2 : if mouse key=1 then gosub GO_4930 else if mouse key=2 then P2=0 : gosub GO_4930
if Z=5 then inc P2 : if mouse key=1 then gosub GO_4930 else if mouse key=2 then P2=1000 : gosub GO_4930
if Z=7 then gosub WAIT_MOUSE1_RELEASE : if PRCT=1 then PRCT=0 else PRCT=1 : VRCT=0 : change mouse 2
if Z=8 then gosub WAIT_MOUSE1_RELEASE : if VRCT=1 then VRCT=0 else VRCT=1 : PRCT=0 : change mouse 2
if PRCT=0 and VRCT=0 then change mouse 1
if Z>=10 and Z<=17 then GO_3090 else GO_3110
@GO_3090
CH1=P+(Z-10) : GME=0 : if mouse key=1 then gosub GO_4950 else if mouse key=3 then CH2=P+(Z-10) : gosub GO_4950
if mouse key=2 then CH2=-1 : gosub GO_4950
@GO_3110
if Z>=18 and Z<=25 then GO_3120 else GO_3140
@GO_3120
CH2=P2+(Z-18) : GME=0 : if mouse key=1 then gosub GO_4950 else if mouse key=3 then CH1=P2+(Z-18) : gosub GO_4950
if mouse key=2 then CH1=-1 : gosub GO_4950
@GO_3140
if Z=6 and GME=0 then PCH1=CH1 : PCH2=CH2 : if PCH1=0 then PCH1=9 : PCH2=369
if Z=6 then CH1=288 : CH2=288 : gosub GO_4950 : gosub WAIT_MOUSE1_RELEASE : if GME=0 then GME=1 else GME=0 : CH1=PCH1 : CH2=PCH2 : gosub GO_4950
goto GO_2730

rem editor panel : sprites
@EDITOR_SPRITES_DRAW
pen 15 : sprite off : hide : wait vbl : VTS=2 : gosub EDITOR_BUTTONS
cls back,0,16,184 to 304,200
cls logic,0,16,184 to 304,200 : screen$(logic,16,184)=IC$(1)
set zone 2,16,184 to 32,199 : sprite 1,40,199,22 : wait vbl : put sprite 1
set zone 3,32,184 to 48,199 : sprite 2,56,199,75 : wait vbl : put sprite 2
set zone 4,48,184 to 64,199 : sprite 3,72,199,86 : wait vbl : put sprite 3
set zone 5,64,184 to 80,199 : CHX=0
sprite 5,103,207,70 : wait vbl : put sprite 5 : set zone 7,96,184 to 112,199
sprite 6,120,199,97 : wait vbl : put sprite 6 : set zone 8,112,184 to 128,199
sprite 7,136,199,99 : wait vbl : put sprite 7 : set zone 9,128,184 to 144,199
auto back off : ink 15 : if SBLK(0,0)=0 then box 144,184 to 159,199 else sprite 10,152,184,83 : wait vbl : put sprite 10
if SBLK(1,0)=0 then box 160,184 to 175,199 else sprite 8,168,184,84 : wait vbl : put sprite 8
if SBLK(2,0)=0 then box 176,184 to 191,191 else sprite 9,184,184,85 : wait vbl : put sprite 9
if SBLK(3,0)=0 then box 176,192 to 191,199 else sprite 11,184,192,92 : wait vbl : put sprite 11
if SBLK(4,0)=0 then box 192,184 to 207,199 else sprite 12,200,199,93 : wait vbl : put sprite 12
if SBLK(5,0)=0 then box 208,184 to 223,199 else sprite 13,216,199,94 : wait vbl : put sprite 13
if SBLK(6,0)=0 then box 224,184 to 239,191 else sprite 14,232,191,95 : wait vbl : put sprite 14
if SBLK(7,0)=0 then box 224,192 to 239,199 else sprite 15,232,199,96 : wait vbl : put sprite 15
set zone 10,144,184 to 159,199 : set zone 11,160,184 to 175,199 : set zone 12,176,184 to 191,191 : set zone 13,176,192 to 191,199 : set zone 14,192,184 to 208,199 : set zone 15,208,184 to 224,199 : set zone 16,224,184 to 239,191 : set zone 17,224,192 to 239,199
sprite 4,88,199,88 : wait vbl : put sprite 4 : set zone 6,80,184 to 96,199
screen copy logic to back : auto back on : sprite off : SP=1 : NV=2 : gosub GO_3740 : show

@EDITOR_SPRITES
Z=zone(0) : if Z<>0 and mouse key=1 then gosub WAIT_MOUSE1_RELEASE : goto GO_3420
if CHX=0 then if mouse key=2 and Z>20 then NSP=Z-19 : gosub GO_4670
if CHX=0 then if mouse key=2 and Z=20 then if SP(NBPL,1)=2 then SP(NBPL,1)=11 else SP(NBPL,1)=2
while mouse key=2 : wend : sprite 1,XD,YD,SP(NBPL,1)
if CHX=0 and mouse key=2 then if Z>=10 and Z<20 then SBLK(Z-10,0)=0 : goto EDITOR_SPRITES_DRAW
K$=inkey$ : if K$=" " then gosub LEVEL_DRAW : gosub GO_3740
goto EDITOR_SPRITES

@GO_3420
if CHX=1 then GO_3820
if Z=1 then sprite off : goto EDITOR_MAIN_DRAW
if Z=2 then if NTS(NBPL)=1 then EDITOR_SPRITES else CHX=1 : goto GO_3770
if Z=3 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=22 : ST(NBPL,NSP)=0 : goto EDITOR_SPRITES_ADD
if Z=4 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=75 : ST(NBPL,NSP)=1 : goto EDITOR_SPRITES_ADD
if Z=5 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=86 : ST(NBPL,NSP)=2 : goto EDITOR_SPRITES_ADD
if Z=6 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=88 : ST(NBPL,NSP)=3 : goto EDITOR_SPRITES_ADD
if Z=7 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=70 : ST(NBPL,NSP)=4 : goto EDITOR_SPRITES_ADD
if Z=8 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=97 : ST(NBPL,NSP)=5 : goto EDITOR_SPRITES_ADD
if Z=9 and NTS(NBPL)<8 then inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=99 : ST(NBPL,NSP)=6 : goto EDITOR_SPRITES_ADD
if Z>=20 then sprite off Z-19 : NSP=Z-19 : goto EDITOR_SPRITES_ADD
if Z<9 then EDITOR_SPRITES
if Z>=14 then GO_3560 else if SBLK(Z-10,0)<>0 then if NTS(NBPL)>=8 then EDITOR_SPRITES else inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=SBLK(Z-10,0) : ST(NBPL,NSP)=4 : goto EDITOR_SPRITES_ADD
goto GO_3570
@GO_3560
if SBLK(Z-10,0)<>0 then if NTS(NBPL)>=8 then EDITOR_SPRITES else inc NTS(NBPL) : NSP=NTS(NBPL) : SP(NBPL,NSP)=SBLK(Z-10,0) : ST(NBPL,NSP)=7 : goto EDITOR_SPRITES_ADD
@GO_3570
if Z-10=0 then SBLK(Z-10,0)=83 else if Z-10=1 then SBLK(Z-10,0)=84 else if Z-10=2 then SBLK(Z-10,0)=85 else SBLK(Z-10,0)=Z+79
goto GO_4750
goto EDITOR_SPRITES
bell : goto EDITOR_SPRITES

@EDITOR_SPRITES_ADD
limit mouse 0,16 to 319,184 : UN=0 : QUATRE=0 : if ST(NBPL,NSP)=7 then QUATRE=5 else if ST(NBPL,NSP)=4 then QUATRE=5 : if SP(NBPL,NSP)<>70 then UN=1
if ST(NBPL,NSP)=3 then UN=-1
if ST(NBPL,NSP)=6 then QUATRE=1
while mouse key=0
X=(x mouse/8)*8+4-QUATRE : Y=(y mouse/8)*8-1+UN : sprite NSP,X,Y,SP(NBPL,NSP)
wend : while mouse key=1 : wend
limit mouse
if NSP=1 then XD=X : YD=Y
XM(NBPL,NSP)=X : YM(NBPL,NSP)=Y : sprite NSP,XM(NBPL,NSP),YM(NBPL,NSP),SP(NBPL,NSP) : set zone NSP+19,XM(NBPL,NSP)-3,YM(NBPL,NSP)-15 to XM(NBPL,NSP)+3,YM(NBPL,NSP)
if ST(NBPL,NSP)=4 then set zone NSP+19,XM(NBPL,NSP)-8,YM(NBPL,NSP)-24 to XM(NBPL,NSP)+8,YM(NBPL,NSP)
if ST(NBPL,NSP)=4 and SP(NBPL,NSP)<>70 then for I=0 to 10 : MOV$(NSP,I)=MVN$+"10)L" : AN$(NSP,I)="("+str$(SP(NBPL,NSP))+",0)" : next I : goto EDITOR_SPRITES
if SPR$(ST(NBPL,NSP),0)="" then for I=0 to 10 : MOV$(NSP,I)=MVN$+"10)L" : AN$(NSP,I)="("+str$(SP(NBPL,NSP))+",0)" : next I : goto EDITOR_SPRITES
for I=0 to 10 : MOV$(NSP,I)=MVN$+"10)L" : AN$(NSP,I)=SPR$(ST(NBPL,NSP),0) : next I
rem if MOV$(NSP,0)="" then for I=0 to 10 : MOV$(NSP,I)=MVN$+"10)L" : AN$(NSP,I)=SPR$(ST(NBPL,NSP),0) : next I
goto EDITOR_SPRITES

@GO_3740
sprite 1,XD,YD,SP(NBPL,1) : set zone 20,XD-3,YD-15 to XD+3,YD
if NTS(NBPL)>1 then for I=2 to NTS(NBPL) : sprite I,XM(NBPL,I),YM(NBPL,I),SP(NBPL,I) : set zone I+19,XM(NBPL,I)-3,YM(NBPL,I)-15 to XM(NBPL,I)+3,YM(NBPL,I) : next I
return

@GO_3770
cls back,0,16,184 to 304,200 : sprite off : wait vbl : screen$(back,16,184)=IC$(2) : set zone 2,16,184 to 32,199 : screen$(back,32,184)=IC$(7) : set zone 3,32,184 to 48,199 : screen$(back,48,184)=IC$(5) : set zone 4,48,184 to 64,199 : screen$(back,64,184)=IC$(9) : set zone 5,64,184 to 80,199
screen copy back to logic : SP=1 : NV=2 : NSP=2 : gosub GO_3740
anim NSP,AN$(NSP,0)
anim on
goto EDITOR_SPRITES

@GO_3820
if Z=1 then sprite off : goto EDITOR_MAIN_DRAW
if Z=2 then CHX=0 : goto EDITOR_SPRITES_DRAW
if Z=3 then bell : goto GO_3890
if Z=4 and ST(NBPL,NSP)<>0 then bell : DGER=1 : goto GO_3890
if Z=5 then bell : goto GO_4450
if Z>20 then anim off : NSP=Z-19 : anim NSP,AN$(NSP,0) : anim on : bell
goto EDITOR_SPRITES

@GO_3890
gosub WAIT_MOUSE1_RELEASE : QUATRE=0 : UN=0 : NB=0 : if DGER=1 or SS(NSP)=-1 then GO_3900 else shoot : clear key : locate 20,23 : print "Reconfigurer ?" : X$=input$(1) : locate 20,23 : print " "; : if X$<>"Y" and X$<>"y" then EDITOR_SPRITES
@GO_3900
XP=XM(NBPL,NSP) : YP=YM(NBPL,NSP) : SP2=SP(NBPL,NSP)
if DGER=1 then SS2=SS(NSP) : SS(NSP)=10 : goto GO_3930
SS(NSP)=0
@GO_3930
anim off : while mouse key<>1 : if (x mouse/8)*8=(XP/8)*8 then GO_3990
if x mouse<XP then GO_3970
if ST(NBPL,NSP)=0 then SP2=22 : goto GO_4000
if ST(NBPL,NSP)=1 then SP2=75 : goto GO_4000
@GO_3970
if ST(NBPL,NSP)=0 then SP2=25 : goto GO_4000
if ST(NBPL,NSP)=1 then SP2=79 : goto GO_4000
@GO_3990
if ST(NBPL,NSP)=0 then SP2=72
@GO_4000
sprite NSP,XP,YP,SP2
if ST(NBPL,NSP)<>1 then GO_4010 else K$=inkey$ : if K$="S" or K$="s" then SOT=4
if K$=" " then SOT=0
K$="" : clear key
@GO_4010
wend : bell : if SS(NSP)=0 then SP(NBPL,NSP)=SP2
if SP2=72 or SP2=70 then CNT=(YP+1-(y mouse/8)*8-8)/2 : goto GO_4060
if ST(NBPL,NSP)<=1 then CNT=(XP-(x mouse/8)*8-4)/2 : goto GO_4060
if ST(NBPL,NSP)=5 then QUATRE=-3 else if ST(NBPL,NSP)=6 then QUATRE=-4 else if ST(NBPL,NSP)=7 then QUATRE=5 else QUATRE=5 : UN=1
if (x mouse/8)*8<>(XP/8)*8 then CNT=(XP-(x mouse/8)*8-4+QUATRE)/2 else CNT=(YP+1-UN-(y mouse/8)*8-8)/2 : HOBA=1
@GO_4060
gosub WAIT_MOUSE1_RELEASE
if CNT<>0 then GO_4120 else HOBA=0
locate 20,23 : input "Dur‚e d'attente ";DUR; : MOV$(NSP,SS(NSP))=MVN$+str$(DUR)+") " : locate 20,23 : print " "; : STY=0
if ST(NBPL,NSP)=1 then locate 20,23 : input "Style d'attente ";STY; : locate 20,23 : print " "; : if STY<>0 then STY=4
while mouse key<>1 : wend : if x mouse>XP then if ST(NBPL,NSP)=0 or ST(NBPL,NSP)=1 then AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),1+STY) : goto GO_4290
if ST(NBPL,NSP)=7 then GO_4290 else if ST(NBPL,NSP)=4 and SP(NBPL,NSP)<>70 then GO_4290
AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),0+STY) : goto GO_4290
@GO_4120
if CNT<0 then MOV$(NSP,SS(NSP))=MVD$ else MOV$(NSP,SS(NSP))=MVG$
if ST(NBPL,NSP)=1 and SOT=4 then AN$(NSP,SS(NSP))=mid$(AN$(NSP,SS(NSP)),1,5)+str$(abs(CNT))+mid$(AN$(NSP,SS(NSP)),10,8)
if SP2>=92 then GO_4190 else if SP2>=83 and SP2<=85 then GO_4190
AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),1)
if SP2=72 then AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),4)
if SP2=75 or SP2=22 then AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),2+SOT)
if SP2=79 or SP2=25 then AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),3+SOT)
if SP2=70 then AN$(NSP,SS(NSP))=SPR$(ST(NBPL,NSP),0)
@GO_4190
MOV$(NSP,SS(NSP))=MOV$(NSP,SS(NSP))+str$(abs(CNT))+") "
if SP2=72 or SP2=70 then mid$(MOV$(NSP,SS(NSP)),1,1)="-"
if HOBA=1 then mid$(MOV$(NSP,SS(NSP)),1,1)="-"
@GO_4220
anim NSP,AN$(NSP,SS(NSP)) : if mid$(MOV$(NSP,SS(NSP)),1,1)<>"-" then move x NSP,MOV$(NSP,SS(NSP)) else MOV2$=mid$(MOV$(NSP,SS(NSP)),2,20) : move y NSP,MOV2$
move on : anim on
@GO_4240
if mouse key=2 then GO_4630
if mouse key=3 then move off : anim off : shoot : sprite NSP,XP,YP : goto GO_3930
if movon(NSP)=0 then move off : anim off : sprite NSP,XP,YP : goto GO_4220
if mouse key=1 then bell : gosub WAIT_MOUSE1_RELEASE : goto GO_4290
goto GO_4240
@GO_4290
if DGER=1 then GO_4380 else clear key : locate 20,23 : print "All‚-retour "; : X$=input$(1) : locate 20,23 : print " "; : if X$="y" or X$="Y" then HOBA=0 : goto GO_4370
clear key : locate 20,23 : print "Retour simple"; : X$=input$(1) : locate 20,23 : print " "; : if X$<>"y" and X$<>"Y" then GO_4310 else SS(NSP)=SS(NSP)+20 : HOBA=0 : goto GO_4370
@GO_4310
clear key : locate 20,23 : print "Annuler ?"; : X$=input$(1) : locate 20,23 : print " "; : if X$<>"y" and X$<>"Y" then GO_4320 else SP2=SP(NBPL,NSP) : HOBA=0 : goto GO_3930
@GO_4320
inc SS(NSP) : if SS(NSP)=10 then SS(NSP)=9 : locate 15,23 : print "Maximum atteint.." : wait 15 : locate 15,23 : print " " : goto GO_4290
move off : anim off : if SP2=72 or SP2=70 then YP=YP-CNT*2 : goto GO_3930
if HOBA=1 then YP=YP-CNT*2 : HOBA=0 : goto GO_3930
XP=XP-CNT*2
goto GO_3930
@GO_4370
anim off : move off : sprite NSP,XM(NBPL,NSP),YM(NBPL,NSP),SP(NBPL,NSP) : goto EDITOR_SPRITES
@GO_4380
HOBA=0 : SS(NSP)=SS2 : DGEM$(NSP,0)=AN$(NSP,10) : DGEM$(NSP,2)=MOV$(NSP,10) : MV$=MOV$(NSP,10) : if mid$(MV$,6,1)=" " then A$="-" else A$=" "
DGEM$(NSP,3)=mid$(MV$,1,5)+A$+mid$(MV$,7,7)
DGEM$(NSP,1)=AN$(NSP,10) : if ST(NBPL,NSP)>1 or SP(NBPL,NSP)=72 then EDITOR_SPRITES
if AN$(NSP,10)=SPR$(ST(NBPL,NSP),0) then DGEM$(NSP,1)=SPR$(ST(NBPL,NSP),1) : goto GO_4370
if AN$(NSP,10)=SPR$(ST(NBPL,NSP),1) then DGEM$(NSP,1)=SPR$(ST(NBPL,NSP),0) : goto GO_4370
if AN$(NSP,10)=SPR$(ST(NBPL,NSP),2) then DGEM$(NSP,1)=SPR$(ST(NBPL,NSP),3) else DGEM$(NSP,1)=SPR$(ST(NBPL,NSP),2)
goto GO_4370
@GO_4450
I=0 : for J=2 to NTS(NBPL) : FLP(NBPL,J)=0
if mid$(MOV$(J,I),1,1)<>"-" then move x J,MOV$(J,I) else MOV2$=mid$(MOV$(J,I),2,20) : move y J,MOV2$
anim J,AN$(J,I) : next J : J=1 : move on : anim on
@GO_4480
inc J : if J=NTS(NBPL)+1 then J=2
if mouse key=1 then bell : move off : anim off : gosub WAIT_MOUSE1_RELEASE : gosub GO_3740 : goto EDITOR_SPRITES
if movon(J)<>0 or SS(J)=-1 then GO_4480
inc FLP(NBPL,J)
if FLP(NBPL,J)=SS(J)+1 then FLP(NBPL,J)=(FLP(NBPL,J))*-1
if SS(J)>=20 then if FLP(NBPL,J)=SS(J)-19 then FLP(NBPL,J)=0 : sprite J,XM(NBPL,J),YM(NBPL,J)
if FLP(NBPL,J)>=0 then MV2$=MOV$(J,FLP(NBPL,J)) : AN2$=AN$(J,FLP(NBPL,J)) : goto GO_4580
MV2$=MOV$(J,abs(FLP(NBPL,J))-1) : AN2$=AN$(J,abs(FLP(NBPL,J))-1)
if mid$(MV2$,6,1)=" " then mid$(MV2$,6,1)="-" else mid$(MV2$,6,1)=" "
if AN2$=SPR$(ST(NBPL,J),3) then AN2$=SPR$(ST(NBPL,J),2) else if AN2$=SPR$(ST(NBPL,J),2) then AN2$=SPR$(ST(NBPL,J),3)
if mid$(AN2$,1,5)=mid$(SPR$(1,6),1,5) then AN2$=mid$(SPR$(1,7),1,5)+mid$(AN$(J,abs(FLP(NBPL,J))-1),6,4)+mid$(SPR$(1,7),10,8) else if mid$(AN2$,1,5)=mid$(SPR$(1,7),1,5) then AN2$=mid$(SPR$(1,6),1,5)+mid$(AN$(J,abs(FLP(NBPL,J))-1),6,4)+mid$(SPR$(1,6),10,8)
@GO_4580
anim J,AN2$
if mid$(MV2$,1,1)<>"-" then move x J,MV2$ else MV2$=mid$(MV2$,2,20) : move y J,MV2$
if FLP(NBPL,J)<0 then if mid$(MOV$(J,abs(FLP(NBPL,J))-1),6,1)=" " then mid$(MOV$(J,abs(FLP(NBPL,J))-1),6,1)="-" else mid$(MOV$(J,abs(FLP(NBPL,J))-1),6,1)=" "
move on J : anim on J : goto GO_4480
rem ********************** vitesse *************
@GO_4630
while mouse key=2 : wend : VTS=VTS*2 : if VTS=8 then VTS=1
if VTS=1 then CNT2=abs(CNT*2) else if VTS=4 then CNT2=abs(CNT/2) else CNT2=abs(CNT)
if ST(NBPL,NSP)=1 and SOT=4 then AN$(NSP,SS(NSP))=mid$(AN$(NSP,SS(NSP)),1,5)+str$(CNT2)+space$(4-len(str$(CNT2)))+mid$(AN$(NSP,SS(NSP)),10,8)
MOV$(NSP,SS(NSP))=mid$(MOV$(NSP,SS(NSP)),1,6)+mid$(str$(VTS),2,1)+","+str$(CNT2)+")" : move off NSP : anim off NSP : sprite NSP,XP,YP : NB=0 : goto GO_4220
rem ******* effacer sprite ********
@GO_4670
reset zone NTS(NBPL)+19 : sprite off NSP : if NSP=NTS(NBPL) then GO_4710
for I=0 to 9 : AN$(NSP,I)=AN$(NTS(NBPL),I) : MOV$(NSP,I)=MOV$(NTS(NBPL),I) : next I
ST(NBPL,NSP)=ST(NBPL,NTS(NBPL)) : SS(NSP)=SS(NTS(NBPL)) : XM(NBPL,NSP)=XM(NBPL,NTS(NBPL)) : YM(NBPL,NSP)=YM(NBPL,NTS(NBPL))
SP(NBPL,NSP)=SP(NBPL,NTS(NBPL)) : set zone NSP+19,XM(NBPL,NSP)-3,YM(NBPL,NSP)-15 to XM(NBPL,NSP)+3,YM(NBPL,NSP) : sprite NSP,XM(NBPL,NSP),YM(NBPL,NSP),SP(NBPL,NSP)
@GO_4710
ST(NBPL,NTS(NBPL))=0 : SS(NTS(NBPL))=-1 : SP(NBPL,NTS(NBPL))=0 : XM(NBPL,NTS(NBPL))=0 : YM(NBPL,NTS(NBPL))=0 : sprite off NTS(NBPL)
for I=0 to 9 : AN$(NTS(NBPL),I)="" : MOV$(NTS(NBPL),I)="" : next I
dec NTS(NBPL) : while mouse key=2 : wend : return
rem ******** get plat/danger *************
@GO_4750
FMT=2 : if SBLK(Z-10,0)=92 or SBLK(Z-10,0)=85 then FMT=1 else if SBLK(Z-10,0)>=95 then FMT=1
if FMT=2 then if SBLK(Z-10,0)>92 then YCAL=15 else YCAL=0
if FMT=1 then if SBLK(Z-10,0)>92 then YCAL=7 else YCAL=0
hide : while mouse key<>1
X=(x mouse/8)*8 : Y=(y mouse/8)*8 : sprite 15,X,Y,32 : sprite 14,X+16,Y+8*FMT,32
wend : sprite off 15 : sprite off 14 : get sprite X+7,Y+YCAL,SBLK(Z-10,0) : show : SBLK(Z-10,1)=X+7 : SBLK(Z-10,2)=Y+YCAL : goto EDITOR_SPRITES_DRAW

@GO_4820
screen$(back,AA,184)=IC$(24) : screen$(back,BB,184)=IC$(26) : return

@EDITOR_BUTTONS
screen$(back,0,184)=IC$(ZM+8)
screen$(back,304,184)=IC$(15) : set zone 1,304,184 to 319,199
return

@EDITOR_BUTTONS_ZONES
cls back,0,0,184 to 304,200 : gosub EDITOR_BUTTONS
IC_ID=24 : IC_X=2 : IC_Z=2 : gosub EDITOR_BUTTON_DRAW
IC_ID=26 : IC_X=6 : IC_Z=3 : gosub EDITOR_BUTTON_DRAW
if LK=1 then EDITOR_BUTTONS_ZONES_MODE1
IC_ID=30 : IC_X=7 : IC_Z=5 : gosub EDITOR_BUTTON_DRAW
if ZNE(NBPL,ZZ)<>0 then IC_ID=25 : IC_X=8 : IC_Z=4  : gosub EDITOR_BUTTON_DRAW
IC_ID=3 : IC_X=12 : IC_Z=6 : gosub EDITOR_BUTTON_DRAW
screen copy back to logic
return
@EDITOR_BUTTONS_ZONES_MODE1
AA=64 : BB=96 : gosub GO_4820
set zone 4,64,184 to 72,199
set zone 5,96,184 to 104,199
screen$(back,112,184)=IC$(13)
set zone 6,112,184 to 128,199
screen copy back to logic
return

@EDITOR_BUTTON_DRAW
IC_SX=ICSIZE(IC_ID,0)
IC_SY=ICSIZE(IC_ID,1)
if btst(0,IC_X)=-1 then IC_ID=IC_ID+100
screen$(back,IC_X*8,184)=IC$(IC_ID)
if IC_Z>0 and IC_SX>0 then set zone IC_Z , IC_X*8 , 184 to IC_X*8+IC_SX-1 , 184+IC_SY-1
return

@GO_4850
scroll 5 : screen copy logic,0,184,304,200 to back,0,184 : cls logic,0,0,184 to 319,199 : return
@GO_4860
set zone 2,136,184 to 144,192 : set zone 3,272,184 to 280,192 : set zone 4,136,193 to 144,199 : set zone 5,272,193 to 280,199 : return
set zone 2,136,184 to 144,199 : set zone 3,272,184 to 280,199 : return
@GO_4880
set zone 6,280,184 to 288,199 : set zone 7,289,184 to 296,199 : set zone 8,297,184 to 304,199 : return
@GO_4890
for I=0 to 7 : set zone 10+I,144+I*16,184 to 159+I*16,192 : set zone 18+I,144+I*16,193 to 159+I*16,199 : next I : return
for I=0 to 7 : set zone 10+I,144+I*16,184 to 159+I*16,199 : next I : return
@GO_4910
if P<DC then P=DC else if P>FC-7 then P=FC-7
bar 144,184 to 271,191 : A=0 : for I=P to P+7 : inc A : screen$(back,144+(A-1)*16,184)=BLK$(I) : next I : screen copy back,144,184,296,192 to logic,144,184 : return
@GO_4930
if P2<DF then P2=DF else if P2>FF-7 then P2=FF-7
bar 144,192 to 271,199 : A=0 : for I=P2 to P2+7 : inc A : screen$(back,144+(A-1)*16,192)=BLK$(I) : next I : screen copy back,144,192,296,200 to logic,144,192 : return

@GO_4950
cls back,0,112,184 to 128,200
if CH2>0 then screen$(back,112,184)=BLK$(CH2) else bell
if CH1>0 then screen$(back,112,184)=BLK$(CH1) else bell
screen copy back to logic : get sprite 112,184,1 : return

@GO_4990
screen$(logic,144,184)=IC$(34)
screen$(logic,288,184)=IC$(25) : screen$(logic,304,184)=IC$(27) : gosub GO_4850
hide : screen$(back,272,184)=IC$(35) : screen$(back,288,184)=IC$(28) : screen$(back,96,184)=IC$(22) : gosub EDITOR_BUTTONS
screen copy back to logic : show
gosub GO_4860 : gosub GO_4880 : gosub GO_4890
return

@GO_5050
if X2<X1 then swap X2,X1
if Y2<Y1 then swap Y2,Y1
if GME=1 then CH1=0 : CH2=0
if VRCT=1 then GO_5130
for I=X1 to X2 : for J=Y1 to Y2
if CH2<>-1 then MP(0,I,J)=CH2
if CH1<>-1 then MP(1,I,J)=CH1
next J : next I : goto GO_5250
@GO_5130
for J=Y1 to Y2
if CH2<>-1 then MP(0,X1,J)=CH2
if CH1<>-1 then MP(1,X1,J)=CH1
if CH2<>-1 then MP(0,X2,J)=CH2
if CH1<>-1 then MP(1,X2,J)=CH1
next J : for I=X1 to X2
if CH2<>-1 then MP(0,I,Y1)=CH2
if CH1<>-1 then MP(1,I,Y1)=CH1
if CH2<>-1 then MP(0,I,Y2)=CH2
if CH1<>-1 then MP(1,I,Y2)=CH1
next I
if GME=1 then CH1=288 : CH2=288
@GO_5250
X1=0 : Y1=0 : X2=0 : Y2=0 : gosub LEVEL_DRAW : return
@GO_5260
cls back,0,0,184 to 320,200 : return

rem GAMING LOOP
rem almost identical to game code
rem TESTS COLLISIONS / MOUVEMENTS NPC
@GAME_MAIN_SUB
sprite 1,X,Y,C
K$=inkey$ : if TEST=1 and K$=" " then GAME_LEVEL_CLEAN
if K$="+" then inc MOUSKY else if K$="-" and MOUSKY>0 then dec MOUSKY
if K$="+" or K$="-" then locate 10,23 : print using "##";MOUSKY : clear key : K$=""
if ZNETEST>0 then dec ZNETEST : return
ZNETEST=MOUSKY
rem *** mvt zones intermittentes ***
if CZI=-1 then GO_5410
inc CZ2 : if CZ2=CZI+1 then CZ2=0
AC3$=ACT$(CZ2) : inc CTIM(CZ2) : if CTIM(CZ2)=NZIF(CZ2)+NZIO(CZ2) then CTIM(CZ2)=0
@GO_5360
I=val(AC3$)
if I=0 then GO_5400 else gosub SET_FOUY
if CTIM(CZ2)=0 then IK=8 : on ZNE2(NBPL,CZ2) gosub GAME_MOBILES_UPDATE,GAME_LASER_UPDATE,GAME_MOBILES_UPDATE,GAME_MOBILES_UPDATE : if ZNE2(NBPL,CZ2)=2 then GO_5360 else GO_5400
if CTIM(CZ2)=NZIO(CZ2) then IK=1 : on ZNE2(NBPL,CZ2) gosub GAME_MOBILES_UPDATE,GAME_LASER_UPDATE,GAME_MOBILES_UPDATE,GAME_MOBILES_UPDATE : if ZNE2(NBPL,CZ2)=2 then GO_5360
@GO_5400
rem *** mvt sprites ***
@GO_5410
MZI=0 : if NTS(NBPL)=1 then GO_5630 else DRC=0 : inc NTS2 : if NTS2=NTS(NBPL)+1 then NTS2=2
if AL(NTS2)=0 and AL2(NTS2)=0 then GO_5500 else if ST(NBPL,NTS2)<>0 or ST(NBPL,NTS2)>=9 then GO_5450
rem ------ flic qui tire -------
if AL(NTS2)=1 then I=NTS2 : goto GO_9820
dec AL(NTS2) : if AL(NTS2)=1 then move on NTS2 : anim on NTS2
goto GO_5630
rem ------ autres en alerte ----
@GO_5450
if movon(NTS2)=0 and FLP(NBPL,NTS2)=-1 then GO_5460 else GO_5500
@GO_5460
anim NTS2,DGEM$(NTS2,AL2(NTS2)) : if mid$(DGEM$(NTS2,AL2(NTS2)+2),1,1)=" " then move x NTS2,DGEM$(NTS2,AL2(NTS2)+2) else DGER2$=mid$(DGEM$(NTS2,AL2(NTS2)+2),2,len(DGEM$(NTS2,AL2(NTS2)+2))) : move y NTS2,DGER2$
if AL2(NTS2)=0 then inc AL2(NTS2) else dec AL2(NTS2)
move on NTS2 : anim on NTS2
goto GO_5630
rem ------------- cpmt normal ---------------
@GO_5500
if ST(NBPL,NTS2)>9 then dec ST(NBPL,NTS2) : if ST(NBPL,NTS2)>9 then GO_5630 else ST(NBPL,NTS2)=0 : anim NTS2,RTRP$(NTS2) : move on NTS2 : anim on NTS2 : goto GO_5630
if SS(NTS2)=-1 or movon(NTS2)<>0 then GO_5630
inc FLP(NBPL,NTS2) : if FLP(NBPL,NTS2)=SS(NTS2)+1 then FLP(NBPL,NTS2)=FLP(NBPL,NTS2)*-1
if SS(NTS2)>=20 then if FLP(NBPL,NTS2)=SS(NTS2)-19 then FLP(NBPL,NTS2)=0 : sprite NTS2,XM(NBPL,NTS2),YM(NBPL,NTS2)
if FLP(NBPL,NTS2)>=0 then MV2$=MOV$(NTS2,FLP(NBPL,NTS2)) : AN2$=AN$(NTS2,FLP(NBPL,NTS2)) : goto GO_5580
MV2$=MOV$(NTS2,abs(FLP(NBPL,NTS2))-1) : AN2$=AN$(NTS2,abs(FLP(NBPL,NTS2))-1)
if mid$(MV2$,6,1)=" " then mid$(MV2$,6,1)="-" else mid$(MV2$,6,1)=" "
if AN2$=SPR$(ST(NBPL,NTS2),3) then AN2$=SPR$(ST(NBPL,NTS2),2) else if AN2$=SPR$(ST(NBPL,NTS2),2) then AN2$=SPR$(ST(NBPL,NTS2),3)
if mid$(AN2$,1,5)=mid$(SPR$(1,6),1,5) then AN2$=mid$(SPR$(1,7),1,5)+mid$(AN$(NTS2,abs(FLP(NBPL,NTS2))-1),6,4)+mid$(SPR$(1,7),10,8) else if mid$(AN2$,1,5)=mid$(SPR$(1,7),1,5) then AN2$=mid$(SPR$(1,6),1,5)+mid$(AN$(NTS2,abs(FLP(NBPL,NTS2))-1),6,4)+mid$(SPR$(1,6),10,8)
@GO_5580
anim NTS2,AN2$
if mid$(MV2$,1,1)<>"-" then move x NTS2,MV2$ else MV2$=mid$(MV2$,2,20) : move y NTS2,MV2$
if FLP(NBPL,NTS2)<0 then if mid$(MOV$(NTS2,abs(FLP(NBPL,NTS2))-1),6,1)=" " then mid$(MOV$(NTS2,abs(FLP(NBPL,NTS2))-1),6,1)="-" else mid$(MOV$(NTS2,abs(FLP(NBPL,NTS2))-1),6,1)=" "
move on NTS2 : anim on NTS2
rem --- control fin tir -----------------
@GO_5630
if movon(15)=0 then sprite off 15
if movon(14)=0 then sprite off 14
if movon(13)=0 then sprite off 13

rem ZONES TEST
@GAME_ZONE_TEST
Z=zone(1) : if Z<>0 then GAME_ZT0
if PSTZ=0 then SAM_ZT1
if ZNE2(NBPL,ZNE(NBPL,PSTZ)-30)=0 then GO_10640
PSTZ=0 : goto SAM_ZT1
@GAME_ZT0
on ZNE(NBPL,Z) goto SAM_DEATH_CONTACT,SAM_DEATH_ELECTRIC,SAM_CLR0,GAME_COLLISION_SPRITES,SPEEDWALK_LEFT,SPEEDWALK_RIGHT,GO_8830,GO_8890,GAME_LEVEL_COMPLETE

if ZNE(NBPL,Z)>=20 and ZNE(NBPL,Z)<=29 then GO_12000
if PSTZ<>0 then if Z=PSTZ then SAM_ZT1 else if ZNE2(NBPL,ZNE(NBPL,PSTZ)-30)=0 then GO_10640 else PSTZ=0 : goto SAM_ZT1
if ZNE(NBPL,Z)>=60 and ZNE(NBPL,Z)<=79 then GAME_EVENT
if ZNE(NBPL,Z)>=30 and ZNE(NBPL,Z)<=39 then on ZNE2(NBPL,ZNE(NBPL,Z)-30) goto SAM_DEATH_CONTACT,SAM_DEATH_ELECTRIC,GAME_COLLISION_SPRITES,GAME_COLLISION_SPRITES
if FEU=1 and FEU2=0 then if ZNE(NBPL,Z)>=40 and ZNE(NBPL,Z)<=59 then GO_10540
@SAM_ZT1
if FEU=1 and FEU2=0 then if C<=5 then SAM_PUNCH else if C<=14 and C>=11 then SAM_PUNCH

rem COLLISION WITH SPRITES
@GAME_COLLISION_SPRITES
if SUPERM>0 then return
TY=14 : TX=14 : if CR>=1 then TY=8 : if CR=2 then TX=18
SP=0 : FS=2 : T=collide(1,TX,TY) : if T=0 then PLAT=0 : return

for I=FS to 15 : if btst(I,T)=-1 then SP=I : I=16
next I : I=0

if SP>12 then if Y<y sprite(SP) then return else SAM_DEATH_CONTACT
@GO_5770
if ST(NBPL,SP)>=9 then return
if ST(NBPL,SP)=0 or SP(NBPL,SP)>=97 then if abs(x sprite(SP)-X)>8 then return
if ST(NBPL,SP)<>4 then GO_5810 else if x sprite(SP)-X>8 or x sprite(SP)-X<-8 then PLAT=0 : return
if ST(NBPL,SP)=4 then if SAUT=0 and PLAT<>-1 then GO_5870 else return
if Y>y sprite(SP)+2 or Y<y sprite(SP)-4 then PLAT=0 : return
@GO_5810
if SP(NBPL,SP)=93 or SP(NBPL,SP)=94 then if abs(x sprite(SP)-X)<=8 then GO_5850 else return
if Y<y sprite(SP)-8 then return
@GO_5850
on ST(NBPL,SP)+1 goto SAM_DEATH_CONTACT,SAM_DEATH_CONTACT,SAM_DEATH_SAW,SAM_DEATH_SAW,GO_5860,SAM_DEATH_SAW,SAM_DEATH_SAW,SAM_DEATH_CONTACT
@GO_5860
return

@GO_5870
if Y>y sprite(SP)+2 or Y<y sprite(SP)-4 then PLAT=0 : return
if PLAT<>SP then GO_5960 else SP2=SP : SP=0
if point(X+x sprite(PLAT)-XPLAT-E-1,y sprite(PLAT)-4)<=V and point(X+x sprite(PLAT)-XPLAT+E+1,y sprite(PLAT)-4)<=V then GO_5900 else GO_5920
@GO_5900
if CR=0 then if point(X+x sprite(PLAT)-XPLAT-E-1,y sprite(PLAT)-12)<=V and point(X+x sprite(PLAT)-XPLAT+E+1,y sprite(PLAT)-12)<=V then GO_5910 else GO_5920
@GO_5910
XPLAT2=x sprite(PLAT) : X=X+XPLAT2-XPLAT : XPLAT=XPLAT2
@GO_5920
Y=y sprite(PLAT)-1
if C=10 then C=2 else if C=19 then C=11
for I=2 to 15 : if btst(I,T)=-1 and I<>SP2 then SP=I : I=16 : SP2=0
next I : I=0 : if SP=0 then return else GO_5830
@GO_5960
XPLAT=x sprite(SP)
Y=y sprite(SP)-1
PLAT=SP : return

rem prepare game level to run : add sprites
@GAME_INIT
if NTS(NBPL)=1 then GO_6030
for I=2 to NTS(NBPL)
FLP(NBPL,I)=-1 : sprite I,XM(NBPL,I),YM(NBPL,I),SP(NBPL,I) next I
for I=0 to 7 : if SBLK(I,0)<>0 then get sprite SBLK(I,1),SBLK(I,2),SBLK(I,0)
next I

@GO_6030
if NTZ(NBPL)=0 then GO_6100
J=0 : for II=1 to NTZ(NBPL)
if ZNE(NBPL,II)>=30 and ZNE(NBPL,II)<=39 then if ACT$(ZNE(NBPL,II)-30)<>"" then CTIM(J)=NZID(J)*-1 : inc J : goto GO_6090
if ZNE(NBPL,II)<80 then GO_6080 else if ZNE2(NBPL,ZNE(NBPL,II)-30)=0 then GO_6090
IK=8 : AC3$=ACT$(ZNE(NBPL,II)-30) : INIT=1 : gosub GO_10670
@GO_6080
set zone II,X1Z(NBPL,II),Y1Z(NBPL,II) to X2Z(NBPL,II),Y2Z(NBPL,II)
@GO_6090
next II : J=0

@GO_6100
move on : anim on : timer=0 : hide : pen 15
TIR=0 : X=XD : Y=YD : C=SP(NBPL,1) : ECH=0 : V=9 : E=4 : TEST=1 : NTS2=1 : CZ2=CZI

@SAM_ROUTER
CR=0 : gosub GAME_MAIN_SUB : J=joy : if point(X,Y+1)<=V and PLAT<=0 then SAM_FALL
if PLAT=0 then SAM_R2 else if C=11 then SAM_RO else if point(X+E-1,Y-16)>V then PLAT=-1 : goto SAM_FALL
if point(X+E-1,Y)>V then PLAT=-1 : goto SAM_FALL
goto SAM_R1
@SAM_RO
if point(X-E+1,Y-16)>V then PLAT=-1 : goto SAM_FALL
if point(X-E+1,Y)>V then PLAT=-1 : goto SAM_FALL
@SAM_R1
if point(X-E,Y-12)>V or point(X-E,Y-4)>V then X=(X/8)*8+4
if point(X+E,Y-12)>V or point(X+E,Y-4)>V then X=(X/8)*8+3
@SAM_R2
gosub GAME_GET_JOY
on J goto SAM_JUMP,SAM_CROUCH_TRANSITION,SAM_ROUTER,SAM_LEFT,SAM_JUMP,SAM_CRAWL_L_TRANSITION,SAM_ROUTER,SAM_RIGHT,SAM_JUMP,SAM_CRAWL_R_TRANSITION,SAM_ROUTER,SAM_ROUTER,SAM_ROUTER,SAM_ROUTER,SAM_ROUTER
goto SAM_ROUTER

rem JOYSTICK LEFT
@SAM_LEFT
CR=0 : gosub GAME_GET_JOY : if C=2 then for C=21 to 20 step-1 : gosub GAME_MAIN_SUB : next C : C=11
restore SAM_LEFT_SPRITES
while J=4 and point(X-E,Y-12)<=V : if point(X-E,Y-4)>V then if PLAT>0 then SAM_ROUTER else C=66 : X=X+4 : goto SAM_CLL1
dec X : read C : if C=0 then restore SAM_LEFT_SPRITES : read C
if MUS=0 and FX=1 then if C=12 and C10=0 then volume 16 : envel 1,2000 : noise 25 : FX2=5
if X<8 then X=8
gosub GAME_MAIN_SUB : gosub GAME_GET_JOY
if PLAT<=0 and point(X,Y+1)<=V then C=8 : X=(X/8)*8+4 : goto SAM_FALL
wend
C=11 : gosub GAME_MAIN_SUB
goto SAM_ROUTER

rem JOYSTICK RIGHT
@SAM_RIGHT
CR=0 : gosub GAME_GET_JOY : if C=11 then for C=20 to 21 : gosub GAME_MAIN_SUB : next C : C=2
restore SAM_RIGHT_SPRITES : while J=8 and point(X+E,Y-12)<=V : if point(X+E,Y-4)>V then if PLAT>0 then SAM_ROUTER else C=59 : X=X-4 : goto SAM_CLR1
inc X : read C : if C=0 then restore SAM_RIGHT_SPRITES : read C
rem if NTS(NBPL)>4 and point(X+E+1,Y-12)<=V then inc X
rem if NTS(NBPL)>4 then inc C : if C=6 then C=3
if X>312 then X=312
gosub GAME_MAIN_SUB : gosub GAME_GET_JOY
if PLAT<=0 and point(X,Y+1)<=V then C=2 : X=(X/8)*8+3 : goto SAM_FALL
wend : C=2
gosub GAME_MAIN_SUB : goto SAM_ROUTER

rem JOYSTICK DOWN LEFT
@SAM_CRAWL_L_TRANSITION
CR=2 : if C=2 then for C=20 to 21 : gosub GAME_MAIN_SUB : next C
for C=15 to 16 : gosub GAME_MAIN_SUB : next C
@SAM_CRAWL_L
CR=2 : restore SAM_CRAWL_L_SPRITES
inc X : gosub GAME_GET_JOY : while J=4 or J=6
if MUS=0 and FX=1 then volume 16 : envel 7,500 : noise rnd(1)+9 : FX2=4
if PLAT<=0 and point(X-1,Y+1)<=V then C=11 : X=X-4 : goto SAM_FALL
if point(X-E,Y-1)>V then SAM_CWL0
dec X : read C : if C=0 then restore SAM_CRAWL_L_SPRITES : read C
if X<8 then X=8
@SAM_CWL0
gosub GAME_MAIN_SUB : gosub GAME_GET_JOY
wend : if Y<8 then SAM_CROUCH_TRANSITION else if J=2 or point(X+E-1,Y-9)>V then SAM_CWL1 else if point(X-E+1,Y-9)>V then SAM_CWL1
C=16 : goto SAM_GETUP_L
@SAM_CWL1
C=16 : sprite 1,X,Y,16 : goto SAM_CROUCH

rem JOYSTICK DOWN RIGHT
@SAM_CRAWL_R_TRANSITION
CR=2 : if C=11 then for C=21 to 20 step-1 : gosub GAME_MAIN_SUB : next C
for C=6 to 7 : gosub GAME_MAIN_SUB : next C
@SAM_CRAWL_R
CR=2 : restore SAM_CRAWL_R_SPRITES
dec X : gosub GAME_GET_JOY : while J=8 or J=10
if MUS=0 and FX=1 then volume 16 : envel 7,500 : noise rnd(1)+8 : FX2=5
if PLAT=0 and point(X+1,Y+1)<=V then C=2 : X=X+4 : goto SAM_FALL
if point(X+E,Y-1)>V then SAM_CWR0
inc X : read C : if C=0 then restore SAM_CRAWL_R_SPRITES
if X>312 then X=312
@SAM_CWR0
gosub GAME_MAIN_SUB : gosub GAME_GET_JOY
wend : if Y<8 then SAM_CROUCH_TRANSITION else if J=2 or point(X+E-1,Y-9)>V then SAM_CWR1 else if point(X-E+1,Y-9)>V then SAM_CWR1
C=7 : goto SAM_GETUP
@SAM_CWR1
C=7 : sprite 1,X,Y,7 : goto SAM_CROUCH

rem ADJUSTING CLIMB LEFT POSITION
@SAM_CLIMB_L
CR=1 : while point(X-E,Y-6)>V : dec Y : C=19 : gosub GAME_MAIN_SUB : wend
while point(X-E,Y-5)<=V : inc Y : C=19 : gosub GAME_MAIN_SUB : wend
C=62
@SAM_CLL0
inc C
if C=63 then Y=Y+5 : X=X+4
if C=64 then dec Y
if C=66 then Y=Y-2
if C=67 then Y=Y-4
if C=68 then dec Y
if C=69 then Y=Y-3 : X=X-8
if C=70 then C=16
@SAM_CLL1
gosub GAME_MAIN_SUB : gosub GAME_MAIN_SUB
if C<>16 then SAM_CLL0
goto SAM_CROUCH
SAUT=0 : if Y<8 then SAM_CROUCH_TRANSITION else if point(X-E+1,Y-8)>V or point(X+E-1,Y-8)>V then SAM_CROUCH_TRANSITION else SAM_GETUP_L
@GO_7900

rem ADJUSTING CLIMB RIGHT POSITION
@SAM_CLIMB_R
CR=1 : while point(X+E,Y-6)>V : dec Y : C=10 : gosub GAME_MAIN_SUB : wend
while point(X+E,Y-5)<=V : inc Y : C=10 : gosub GAME_MAIN_SUB : wend
C=55
@SAM_CLR0
inc C
if C=56 then Y=Y+5 : X=X-4
if C=57 then dec Y
if C=59 then Y=Y-2
if C=60 then Y=Y-4
if C=61 then dec Y
if C=62 then Y=Y-3 : X=X+8
if C=63 then C=7
@SAM_CLR1
gosub GAME_MAIN_SUB : gosub GAME_MAIN_SUB
if C<>7 then SAM_CLR0
SAUT=0 : if Y<8 then SAM_CROUCH_TRANSITION else if point(X+E-1,Y-8)>V or point(X-E+1,Y-8)>V then SAM_CROUCH_TRANSITION else SAM_GETUP

rem LADDER
@SAM_LADDER_END
if Y<16 then SAM_ROUTER
if joy=9 or joy=5 then SAM_JP2
if joy<>1 then SAM_ROUTER else C=10 : goto SAM_JP2
 
@SAM_LADDER_TEST
restore SAM_LADDER_SPRITES : C=55 : SAUT=0
@SAM_LADDER
rem if SUPERM>0 or timer<100 then wait vbl
Z=zone(1)
if Z=0 then SAM_LADDER_END : rem test from game codebase
if ZNE(NBPL,Z)=4 then SAM_LD0
if ZNE(NBPL,Z)<30 then SAM_LADDER_END else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then SAM_LADDER_END
@SAM_LD0
gosub GAME_GET_JOY
if J=0 then SAM_LD4
if J<>1 and J<>9 then if J<>5 then SAM_LD1
if HHH<>1 then HHH=1
if point(X+E-1,Y-16)>V or point(X-E+1,Y-16)>V then if DEMO=0 then HHH=-1
if J=9 and X<=315 then SAM_LD5
if J=5 and X>=4 then SAM_LD6
goto SAM_LD3
@SAM_LD1
if J<>2 and J<>6 then if J<>10 then SAM_LD2
if HHH<>0 then HHH=0
if point(X+E-1,Y+1)>V or point(X-E+1,Y+1)>V then HHH=-1
if J=10 and X<=315 then SAM_LD5
if J=6 and X>=4 then SAM_LD6
goto SAM_LD3
@SAM_LD2
HHH=-1 : if J=8 and X<=315 then SAM_LD5
if J=4 and X>=4 then SAM_LD6
goto SAM_LADDER
@SAM_LD3
read C : if C=0 then restore SAM_LADDER_SPRITES : read C
if C=53 then if MUS=0 and FX=1 then volume 16 : envel 1,1000 : noise Y/6+1 : FX2=4
if HHH=1 and C=54 then Y=Y-2
if HHH=0 then if C=53 or C=55 then Y=Y+2
if Y<16 then Y=16
@SAM_LD4
gosub GAME_MAIN_SUB : goto SAM_LADDER
@SAM_LD5
if point(X+E,Y-15)>V then SAM_LD3
if point(X+E,Y-12)>V then SAM_LD3
if point(X+E,Y-6)>V then SAM_CLIMB_R
if point(X+E,Y)>V then SAM_LD3
inc X : goto SAM_LD3
@SAM_LD6
if point(X-E,Y-15)>V then SAM_LD3
if point(X-E,Y-12)>V then SAM_LD3
if point(X-E,Y-6)>V then SAM_CLIMB_L
if point(X-E,Y)>V then SAM_LD3
dec X : goto SAM_LD3

rem ANIME DEAD : OUT OF SCREEN JUMP
@SAM_DEATH_CONTACT
for I=13 to 15 : sprite off I : next I : if X>160 then C=42 else C=43
anim off 1 : sprite 1,X,Y,C
move y 1,"(1,-2,10)(1,0,10)(1,2,10)(1,3,30)(1,4,40)" : if C=42 then move x 1,"(1,-2,70)" else move x 1,"(1,2,70)"
move on 1 : while y sprite(1)<220 : wend : move off 1 : wait 10 : boom : boom
sprite 1,x sprite(1),210,44 : anim 1,"(45,30)(46,30)(47,30)"
move y 1,"(2,-1,0)" : move on 1 : anim on 1
goto SAM_DEATH_COMMON

rem ANIME DEAD : ELECTRIC SHOCK
@SAM_DEATH_ELECTRIC
if CR<>0 and Y=Y1Z(NBPL,Z)+15 then if Y2Z(NBPL,Z)-Y1Z(NBPL,Z)<=X2Z(NBPL,Z)-X1Z(NBPL,Z) then GAME_COLLISION_SPRITES
anim off 1
anim 1,"(33,1)(34,1)L" : timer=0 : anim on 1
@GO_8690
if timer<70 then shoot : goto GO_8690
anim 1,"(35,1)(36,10)(37,8)(38,8)(39,8)(40,4)(41,8)" : move y 1,"(5,-1,0)" : anim on 1 : move on 1 : timer=0
goto SAM_DEATH_COMMON

@GO_8830
if point(X-E,Y)>V then GAME_COLLISION_SPRITES
if CR=0 then if point(X-E,Y-9)>V then GAME_COLLISION_SPRITES
if YES=0 then dec X : YES=1 : if NTS(NBPL)<=4 then GO_8870 else dec X : goto GO_8870
YES=0 : goto GAME_COLLISION_SPRITES

@GO_8870
if point(X,Y+1)<=V then if joy<>8 then X=(X/8)*8+4 else inc X
goto GAME_COLLISION_SPRITES

@GO_8890
if point(X+E,Y)>V then GAME_COLLISION_SPRITES
if CR=0 then if point(X+E,Y-9)>V then GAME_COLLISION_SPRITES
if YES=0 then inc X : YES=1 : if NTS(NBPL)<=4 then GO_8930 else INX : goto GO_8930
YES=0 : goto GAME_COLLISION_SPRITES

@GO_8930
if point(X,Y+1)<=V then if joy<>4 then X=3+(X/8)*8 else dec X
goto GAME_COLLISION_SPRITES

@SAM_DEATH_COMMON
if NTS(NBPL)=1 then GO_8980
for I=2 to NTS(NBPL) : move off I : if ST(NBPL,I)=0 or ST(NBPL,I)>=9 then anim I,"(125,7)(126,7)l"
next I : anim on
@GO_8980
TIM=10000 : while TIM>0 : dec TIM : if joy>=16 then TIM=0
wend
auto back on : goto GAME_LEVEL_CLEAN

rem editor panel : files
@EDITOR_FILE_DRAW
cls back,0,0,184 to 304,200 : gosub EDITOR_BUTTONS
cls logic,0,0,184 to 304,200 : pen 15
screen$(back,16,184)=IC$(16) : screen$(back,32,184)=IC$(17)
screen copy back to logic
set zone 2,16,184 to 32,199 : set zone 3,32,184 to 48,199
locate 10,23 : print FILE$;

@GO_9070
while mouse key=0 : wend : while mouse key<>0 : wend
Z=zone(0) : if Z=0 then GO_9070

if Z=1 then EDITOR_MAIN_DRAW
if Z=2 then EDITOR_FILE_LOAD
rem EDITOR_FILE_SAVE
FILE$=file select$("*.SAM","Sauvegarde")
if FILE$="" then GO_9070
open out #1,"SAM"+FILE$+".SAM"
PSW$=str$(MOUSKY)+"/"+FILE$
NV=-1 : print #1,PSW$;","; : OK=0 : LGEUR=len(PSW$)+1
@GO_9160
inc NV : if NV=2 then GO_9270 else L$=chr$(65+NV)
print #1,L$;","; : LGEUR=LGEUR+3
for Y=0 to 22 : for X=0 to 39
if MP(NV,X,Y)<>0 then GO_9210 else if OK=0 then GO_9240
gosub GO_9420 : OK=0 : goto GO_9240
@GO_9210
if OK=1 then GO_9220 else if LGEUR<470 then print #1,str$(X);",";str$(Y);","; else LGEUR=0 : print #1,str$(X);",";str$(Y)
LGEUR=LGEUR+len(str$(X))+2+len(str$(Y)) : OK=1 : ID2=1 : IDEM=MP(NV,X,Y) : goto GO_9240
@GO_9220
if MP(NV,X,Y)=IDEM then inc ID2 : goto GO_9240
gosub GO_9420 : ID2=1 : IDEM=MP(NV,X,Y)
@GO_9240
next X : next Y
if OK=1 then gosub GO_9420 : OK=0
goto GO_9160
@GO_9270
print #1,"C";",";str$(XD);",";str$(YD);",";str$(SP(NBPL,1));",";str$(NTS(NBPL)) : LGEUR=0
if NTS(NBPL)=1 then GO_9350
for X=2 to NTS(NBPL) : print #1,str$(XM(NBPL,X));",";str$(YM(NBPL,X));",";str$(SP(NBPL,X));",";str$(SS(X));",";str$(ST(NBPL,X))
if SS(X)>=20 then NBM=19 else NBM=0
for I=0 to SS(X)-NBM : if LGEUR<470 then print #1,AN$(X,I);"/"; else LGEUR=0 : print #1,AN$(X,I);"/"
LGEUR=LGEUR+len(AN$(X,I))+1 : next I
for I=0 to SS(X)-NBM : if LGEUR<470 then print #1,MOV$(X,I);"/"; else LGEUR=0 : print #1,MOV$(X,I);"/"
LGEUR=LGEUR+len(MOV$(X,I))+1 : next I
for I=0 to 3 : if X=NTS(NBPL) and I=3 then print #1,DGEM$(X,I) : goto GO_9330
if LGEUR<470 then print #1,DGEM$(X,I);"/"; else print #1,DGEM$(X,I);"/" : LGEUR=0
LGEUR=LGEUR+len(DGEM$(X,I))+1
@GO_9330
next I : next X : LGEUR=0
for I=0 to 7 : print #1,str$(SBLK(I,0));",";str$(SBLK(I,1));",";str$(SBLK(I,2));","; : LGEUR=LGEUR+len(str$(SBLK(I,0))+str$(SBLK(I,1))+str$(SBLK(I,2)))+3 : next I
@GO_9350
print #1,str$(NTZ(NBPL));","; : LGEUR=LGEUR+len(str$(NTZ(NBPL)))+1 : if NTZ(NBPL)=0 then GO_9370
ZNE(NBPL,0)=val(FILE$) : T=rnd(300) : TT=rnd(180) : X1Z(NBPL,0)=(T/8)*8 : X2Z(NBPL,0)=(T/8)*8+32 : Y1Z(NBPL,0)=(TT/8)*8 : Y2Z(NBPL,0)=(TT/8)*8+8
for X=0 to NTZ(NBPL)
if LGEUR<470 then print #1,str$(ZNE(NBPL,X));",";str$(X1Z(NBPL,X));",";str$(Y1Z(NBPL,X));",";str$(X2Z(NBPL,X));",";str$(Y2Z(NBPL,X));","; else print #1,str$(ZNE(NBPL,X));",";str$(X1Z(NBPL,X));",";str$(Y1Z(NBPL,X));",";str$(X2Z(NBPL,X));",";str$(Y2Z(NBPL,X)) : LGEUR=0
LGEUR=LGEUR+len(str$(ZNE(NBPL,X))+str$(X1Z(NBPL,X))+str$(Y1Z(NBPL,X))+str$(X2Z(NBPL,X))+str$(Y2Z(NBPL,X)))+5 : next X
@GO_9370
if LGEUR<490 then print #1,str$(CZI);","; else LGEUR=0 : print #1,str$(CZI)
LGEUR=LGEUR+len(str$(CZI))+1
if CZI=-1 then GO_9390
for I=0 to CZI : if LGEUR<480 then print #1,str$(NZID(I));",";str$(NZIO(I));",";str$(NZIF(I));","; else LGEUR=0 : print #1,str$(NZID(I));",";str$(NZIO(I));",";str$(NZIF(I))
LGEUR=LGEUR+len(str$(NZID(I))+str$(NZIO(I))+str$(NZIF(I)))+3 : next I
@GO_9390
for X=0 to 80 : if ACT$(X)="" then GO_9397
if LGEUR<400 then print #1,str$(X);",";ACT$(X);","; else print #1,str$(X);",";ACT$(X) : LGEUR=0
LGEUR=LGEUR+len(str$(X)+ACT$(X))+2
@GO_9397
next X : print #1,"-1";",";
for X=0 to 80 : if ZNE2(NBPL,X)=0 then GO_9409
if LGEUR<480 then print #1,str$(X);",";str$(ZNE2(NBPL,X));","; else print #1,str$(X);",";str$(ZNE2(NBPL,X)) : LGEUR=0
@GO_9409
LGEUR=LGEUR+len(str$(X)+str$(ZNE2(NBPL,X)))+2 : next X : print #1,"-1"
close #1 : bell : gosub LEVEL_DRAW : goto EDITOR_MAIN_DRAW
@GO_9420
if ID2<>1 then GO_9430 else if LGEUR<470 then print #1,str$(IDEM*-1);","; else LGEUR=0 : print #1,str$(IDEM*-1)
LGEUR=LGEUR+len(str$(IDEM*-1))+1 : goto GO_9440
@GO_9430
if LGEUR<470 then print #1,str$(IDEM*-1);"/";str$(ID2);","; else LGEUR=0 : print #1,str$(IDEM*-1);"/";str$(ID2)
LGEUR=LGEUR+len(str$(IDEM*-1))+2+len(str$(ID2))
@GO_9440
return

@EDITOR_FILE_LOAD
FILE$=file select$("*.SAM"," Chargez!") : if FILE$="" then GO_9070
open in #1,FILE$
if FILE$="" then GO_9070
for I=0 to 3 : for J=0 to 22 : for K=0 to 39 : MP(I,K,J)=0 : next K : next J : next I : for I=1 to 110 : ZNE(NBPL,I)=0 : next I
NV=-1 : input #1,PSW$ : MOUSKY=val(PSW$)
input #1,L$ : NV=0
@GO_9520
input #1,X$ : if asc(X$)>64 then inc NV : if NV<2 then GO_9520 else GO_9650
@GO_9530
input #1,Y$ : if asc(Y$)>64 then inc NV : if NV<2 then GO_9530 else GO_9650
@GO_9540
X=val(X$) : Y=val(Y$)
@GO_9550
input #1,X$
if val(X$)<0 then MP(NV,X,Y)=val(X$)*-1 else GO_9610
FOUY=instr(X$,"/") : if FOUY<>0 then ID2=val(mid$(X$,FOUY+1,6))-1 : IND=val(X$)*-1
@GO_9580
inc X : if X>39 then X=0 : inc Y : if Y=23 then Y=0 : goto GO_9640
if ID2=0 then GO_9550
dec ID2 : MP(NV,X,Y)=IND : goto GO_9580
@GO_9610
if asc(X$)<65 then input #1,Y$ : goto GO_9540
@GO_9620
inc NV : if NV>=2 then GO_9650 else input #1,X$ : if asc(X$)<65 then input #1,Y$ : goto GO_9540
goto GO_9620
@GO_9640
input #1,X$ : inc NV : if NV<2 then GO_9520
@GO_9650
input #1,X$,Y$,Z$ : XD=val(X$) : YD=val(Y$) : SP(NBPL,1)=val(Z$)
input #1,Y$ : NTS(NBPL)=val(Y$) : if NTS(NBPL)=1 then GO_9730
for X=2 to NTS(NBPL) : input #1,X$,Y$,Z$,ZE$,ZF$ : XM(NBPL,X)=val(X$) : YM(NBPL,X)=val(Y$) : SP(NBPL,X)=val(Z$) : SS(X)=val(ZE$) : ST(NBPL,X)=val(ZF$)
NBM=0 : if SS(X)>=20 then NBM=19
for I=0 to SS(X)-NBM : line input #1,47,AN$(X,I)
if asc(mid$(AN$(X,I),1,1))=13 then AN$(X,I)=mid$(AN$(X,I),3,len(AN$(X,I))-2)
next I
for I=0 to SS(X)-NBM : line input #1,47,MOV$(X,I)
if asc(mid$(MOV$(X,I),1,1))=13 then MOV$(X,I)=mid$(MOV$(X,I),3,len(MOV$(X,I))-2)
next I
line input #1,47,DGEM$(X,0) : line input #1,47,DGEM$(X,1) : line input #1,47,DGEM$(X,2) : if X<>NTS(NBPL) then line input #1,47,DGEM$(X,3) else line input #1,DGEM$(X,3)
next X
for I=0 to 7 : input #1,X$,Y$,Z$ : SBLK(I,0)=val(X$) : SBLK(I,1)=val(Y$) : SBLK(I,2)=val(Z$) : next I
@GO_9730
input #1,X$ : NTZ(NBPL)=val(X$) : if NTZ(NBPL)=0 then GO_9750
for X=0 to NTZ(NBPL) : input #1,X$,Y$,Z$,A$,B$ : ZNE(NBPL,X)=val(X$) : X1Z(NBPL,X)=val(Y$) : Y1Z(NBPL,X)=val(Z$) : X2Z(NBPL,X)=val(A$) : Y2Z(NBPL,X)=val(B$) : next X
@GO_9750
input #1,X$ : CZI=val(X$) : if CZI=-1 then GO_9770
for X=0 to CZI : input #1,X$,Y$,Z$ : NZID(X)=val(X$) : NZIO(X)=val(Y$) : NZIF(X)=val(Z$) : next X
@GO_9770
input #1,X$ : X=val(X$) : if X=-1 then GO_9780
input #1,ACT$(X)
goto GO_9770
@GO_9780
input #1,X$ : X=val(X$) : if X=-1 then GO_9790
input #1,X$ : ZNE2(NBPL,X)=val(X$)
goto GO_9780
@GO_9790
close #1 : bell
gosub LEVEL_DRAW : goto EDITOR_MAIN_DRAW
rem ****** evenements
@GO_9820
if movon(15)=0 then BAL=0 else if movon(14)=0 then BAL=1 else if movon(13)=0 then BAL=2
if BAL=-1 then GO_5500
FLP2=FLP(NBPL,I) : if FLP2<0 then D$=mid$(MOV$(I,abs(FLP2)-1),6,1) else D$=mid$(MOV$(I,FLP2),6,1)
if FLP2<0 then if D$="-" then D$=" " else D$="-"
if X>x sprite(I) and D$=" " then SPF=28 : goto GO_9900
if X<x sprite(I) and D$="-" then SPF=29 : goto GO_9900
goto GO_5500
@GO_9900
move freeze I : anim freeze I : AL(I)=20
SPF=SPF+rnd(1)*2 : if SPF=30 or SPF=31 then SPF2=-4 else SPF2=0
sprite I,x sprite(I),y sprite(I),SPF
if SPF=28 or SPF=30 then SPF=4 else SPF=-4
sprite 15-BAL,x sprite(I)+SPF,y sprite(I)-10-SPF2,32
if SPF=-4 then move x 15-BAL,"(1,-4,40)" else move x 15-BAL,"(1,4,40)"
move on 15-BAL : shoot
FLP2=0
BAL=-1
goto GAME_ZONE_TEST

rem PUNCH OR ACTION LEFT OR RIGHT
@SAM_PUNCH
TIM=200 : COUP=0 : if C<=5 then anim 1,"(101,9)(102,12)" else anim 1,"(105,9)(106,12)" : COUP=3
anim on : FEU2=1
@GO_10390
DB=2 : T=collide(1,TX+1,TY) : if T=0 then dec TIM : if TIM>0 then GO_10390 else anim off 1 : goto GO_5860
@GO_10400
for I=DB to 15 : if btst(I,T)=-1 then SP=I : I=16
next I : I=0 : if ST(NBPL,SP)>=9 then DB=SP+1 : SP=0 : goto GO_10400
if ST(NBPL,SP)<>0 then GO_10530
if Y>y sprite(SP)+2 or Y<y sprite(SP)-2 then GO_10530
if C<=5 and x sprite(SP)<X then GO_10530 else if C>=11 and x sprite(SP)>X then GO_10530
anim freeze SP : move freeze SP : if C<=5 then anim 1,"(103,8)(104,18)(103,8)" else anim 1,"(107,8)(108,18)(107,8)"
sprite SP,x sprite(SP),y sprite(SP),109+COUP : shoot : while TIM>0 : dec TIM : wend : anim on 1 : sprite SP,x sprite(SP),y sprite(SP),110+COUP
TIM=200 : CFLIC=110+COUP
while TIM>0 : dec TIM : if TIM=100 then CFLIC=111+COUP : shoot
sprite SP,x sprite(SP),y sprite(SP),CFLIC
wend : anim SP,"(115,12)(116,12)L" : anim on : ST(NBPL,SP)=200/NTS(NBPL) : if FLP(NBPL,SP)>=0 then RTRP$(SP)=AN$(SP,FLP(NBPL,SP)) : goto GO_10530
if AN$(SP,abs(FLP(NBPL,SP))-1)=SPR$(0,4) then RTRP$(SP)=SPR$(0,4) : goto GO_10530
if AN$(SP,abs(FLP(NBPL,SP))-1)=SPR$(0,2) then RTRP$(SP)=SPR$(0,3) else RTRP$(SP)=SPR$(0,2)
@GO_10530
TIM=0 : anim off 1 : goto GO_5770

@GO_10540
rem *********************************************
W=ZNE(NBPL,Z)-30
if ZNE2(NBPL,W)=2 and NKEY>0 then dec NKEY : ZNE2(NBPL,W)=4 : goto GO_10660
if ZNE2(NBPL,W)=3 and OKEY>0 then dec OKEY : ZNE2(NBPL,W)=5 : goto GO_10660
if ZNE2(NBPL,W)>1 then GAME_COLLISION_SPRITES
if X2Z(NBPL,Z)-X1Z(NBPL,Z)=16 and (X1Z(NBPL,Z)/16)*16<>X1Z(NBPL,Z) then CAL=8
if X2Z(NBPL,Z)-X1Z(NBPL,Z)=24 then CAL=8
if C<=10 and X+2>X1Z(NBPL,Z)+CAL then GAME_COLLISION_SPRITES
if C>10 and X-8<X1Z(NBPL,Z)+CAL then GAME_COLLISION_SPRITES
if ZNE2(NBPL,W)=1 then ZNE2(NBPL,W)=0 else ZNE2(NBPL,W)=1
if C<=5 then sprite 1,X,Y,90 else if C>=11 and C<=14 then sprite 1,X,Y,91
BR=MP(1,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)
if MP(0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)<>0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(MP(0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8))
screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR+ZNE2(NBPL,W)) : goto GO_10660
@GO_10640
W=ZNE(NBPL,PSTZ)-30 : PSTZ=0 : goto GO_10660

rem ------- modif aire de jeu ----------
@GAME_EVENT
if ZNE(NBPL,Z)>=60 and ZNE(NBPL,Z)<=79 then W=ZNE(NBPL,Z)-30 : PSTZ=Z : BR=0
@GO_10660
AC3$=ACT$(W)
@GO_10670
I=val(AC3$) : gosub SET_FOUY : if I=0 then GO_10750
ZBNE=val(AC3$) : gosub SET_FOUY : if ZBNE<>0 then GO_10700 else if AL(I)=0 then AL(I)=1 else AL(I)=0 : move on I : anim on I
goto GO_10670
@GO_10700
ZBNE2=val(AC3$) : gosub SET_FOUY
if ZNE(NBPL,I)=ZBNE then ZNE(NBPL,I)=ZBNE2 else ZNE(NBPL,I)=ZBNE
if ZNE(NBPL,I)=ZBNE then IK=8 else IK=1
on ZBNE gosub GAME_MOBILES_UPDATE,GAME_LASER_UPDATE,GAME_MOBILES_UPDATE,GAME_MOBILES_UPDATE
goto GO_10670
@GO_10750
if INIT=1 then INIT=0 : return
if PSTZ<>0 then GO_10800
FEU2=1 : if BR<MANETS or ZNE2(NBPL,W)>1 then GO_10800 else ZNE2(NBPL,W)=0
if MP(0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)<>0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(MP(0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR)
@GO_10800
CAL=0 : goto GAME_COLLISION_SPRITES

rem re-initialise level values
@GAME_LEVEL_CLEAN
pop
fade 1 : sprite off : reset zone
reset zone : BTIM=0 : for I=2 to NTS(NBPL) : if ST(NBPL,I)>=9 then ST(NBPL,I)=0
next I
NKEY=0 : OKEY=0 : BOUT=0 : SC=0 : FEU=0 : FEU2=0 : PSTZ=0
for I=0 to 8 : AL2(I)=0 : AL(I)=0 : next I
for II=50 to 80 : AC3$=ACT$(II) : if AC3$="" then GAME_LC1
@GAME_LC0
I=val(AC3$) : gosub SET_FOUY : if I=0 then GAME_LC1 else ZBNE=val(AC3$) : gosub SET_FOUY : if ZBNE=0 then GAME_LC0
ZBNE2=val(AC3$) : gosub SET_FOUY : ZNE(NBPL,I)=ZBNE2
IK=1 : if ZBNE=2 then gosub GAME_LASER_UPDATE else gosub GAME_MOBILES_UPDATE
goto GAME_LC0
@GAME_LC1
next II : Z=0
@GAME_LC2
inc Z : if Z>NTZ(NBPL) then Z=0 : goto GO_10990
if ZNE(NBPL,Z)<40 or ZNE(NBPL,Z)>59 then GAME_LC2
if ZNE2(NBPL,ZNE(NBPL,Z)-30)=4 then ZNE2(NBPL,ZNE(NBPL,Z)-30)=2 : goto GAME_LC2
if ZNE2(NBPL,ZNE(NBPL,Z)-30)=5 then ZNE2(NBPL,ZNE(NBPL,Z)-30)=3 : goto GAME_LC2
if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>1 then goto GAME_LC2
ZNE2(NBPL,ZNE(NBPL,Z)-30)=0 : CAL=0

if X2Z(NBPL,Z)-X1Z(NBPL,Z)=16 and (X1Z(NBPL,Z)/16)*16<>X1Z(NBPL,Z) then CAL=8
if X2Z(NBPL,Z)-X1Z(NBPL,Z)=24 then CAL=8
BR=MP(1,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)
if MP(0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)<>0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(MP(0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8))
screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR)
goto GAME_LC2
@GO_10990
for II=0 to 9 : AC3$=ACT$(II) : if AC3$="" then II=20 : goto GO_11030
@GO_11000
I=val(AC3$) : gosub SET_FOUY : if I=0 then GO_11030
IK=1 : if ZNE2(NBPL,ZNE(NBPL,I)-30)=2 then gosub GAME_LASER_UPDATE else gosub GAME_MOBILES_UPDATE
goto GO_11000
@GO_11030
next II : II=0
show : goto EDITOR_MAIN_DRAW

@GO_12000
reset zone Z : screen$(back,X1Z(NBPL,Z),Y1Z(NBPL,Z))=BLK$(MP(0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
if Y<>Y1Z(NBPL,Z)+7 then screen$(logic,X1Z(NBPL,Z),Y1Z(NBPL,Z))=BLK$(MP(0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
on ZNE(NBPL,Z)-19 goto GO_12040,GO_12030,GO_12007,GO_12010,GO_12045,GO_12020
@GO_12007
BOUT=50 : goto GAME_COLLISION_SPRITES
@GO_12010
SC=SC+500 : goto GO_12050
@GO_12020
SC=SC+100 : goto GO_12050
@GO_12030
inc OKEY : bell : goto GAME_COLLISION_SPRITES
@GO_12040
inc NKEY : bell : goto GAME_COLLISION_SPRITES
@GO_12045
MOUSKY=10 : bell : goto GAME_COLLISION_SPRITES
@GO_12050
locate 0,23 : print using "#######";SC : goto GAME_COLLISION_SPRITES

rem LEVEL COMPLETED
@GAME_LEVEL_COMPLETE
anim off : move off : anim 1,"(127,4)(128,5)l"
TIM=4000 : anim on : while TIM>0 : dec TIM : if joy>=16 then TIM=0
wend : anim off : sprite 1,X,Y,20 : wait 2
goto GAME_LEVEL_CLEAN

rem define the max number of memory bank
rem we can set on this machine
@SUB_GET_BANKCOUNT
BANKCOUNT=1
return

rem specific editor
@SUB_SCROLLS_EDITOR
def scroll 4,0,16 to 320,32,-8,0
def scroll 7,0,32 to 320,64,8,0
def scroll 5,0,184 to 320,200,-8,0
def scroll 6,0,0 to 320,184,4,4
def scroll 2,0,0 to 320,184,-4,-4
return
