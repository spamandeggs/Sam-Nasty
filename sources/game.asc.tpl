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

# NOT WORKING YET !
# need to replace any goto/gosub/on .. goto <LINE> by <KEYWORD>

clear
COMPILED=0 : COMPDELAY=1 : DEVEL=0 : TRACE=0

on error goto GO_EXIT
if COMPILED=1 then break off
clear key : hide : mode 0 : curs off : reset zone : colour 14,$0 : key off
reserve as data 2,5585
bload "SAM0.BLK",2 : unpack 2,back : erase 2
get palette (back) : screen copy back to logic
dim COLINTRO(15) : for I=0 to 15 : COLINTRO(I)=colour(I) : next I
click off : PTIT=11

gosub SUB_SCROLLS_DEF
rem VARIABLES
dim BLK$(600),IC$(50),MPBL(1),LVL(1),COEUR$(1)
dim SC(1),NAM$(9),SCO$(9),TXT$(16)
dim GAMEMDE$(2) : GAMEMDE$(0)="EASY  " : GAMEMDE$(1)="NORMAL" : GAMEMDE$(2)="HARD  " : GMID=1
BGD=365 : MANETS=357 : FMANETS=361 : OPTN=110
dim JDEM(50),TDEM(50),VV(1) : SAM$="SAM"
JDEM(1)=4 : TDEM(1)=106 : JDEM(2)=1 : TDEM(2)=23 : JDEM(3)=9 : TDEM(3)=4 : JDEM(0)=1 : TDEM(0)=10
JDEM(4)=8 : TDEM(4)=10 : JDEM(5)=8 : COD$="TELEPORT-ME-NOW" : TDEM(5)=125 : JDEM(6)=1 : TDEM(6)=23
JDEM(7)=4 : TDEM(7)=91 : JDEM(8)=1 : TDEM(8)=23
JDEM(9)=8 : TDEM(9)=35 : JDEM(10)=0 : TDEM(10)=190 : JDEM(11)=8 : TDEM(11)=40 : JDEM(12)=16 : TDEM(12)=3
JDEM(13)=4 : TDEM(13)=100 : TDEM(14)=rnd(4) : JDEM(14)=58
TXT$(1)="UP : TO JUMP OR TO CLIMB UP" : TXT$(2)="DOWN : TO STOOP OR TO GO DOWN"
TXT$(9)="UP : TO JUMP AND TO CLIMB UP" : TXT$(10)="    TO CREEP OR TO GO DOWN    " : TXT$(5)="UP : TO JUMP AND TO CLIMB UP" : TXT$(6)="    TO CREEP OR TO GO DOWN    " : TXT$(16)="TO HIT A GUARD,TO USE A HANDLE OR A KEY" : TXT$(4)="LEFT : TO GO LEFT ( WHAT A SURPRISE...)" : TXT$(8)="RIGHT : TO GO RIGHT..."
dim SCXY(39,18) : dim LINEXCLU(18) : rem TEXT FX RELATED
NBP=1 : NWLVL=1 : MUS=1 : FX=1 : NBPL=0 : LVL(0)=1 : LVL(1)=1
MVG$=" ( 3,-2," : MVD$=" ( 3, 2," : MVN$=" (10, 0,"

rem SPRITES ANIMES DEFS
dim SPR$(8,7)
rem circular saw ceiling (3)
SPR$(3,0)="(88,0)"
SPR$(3,1)="(88,4)(89,4)L"
rem circular saw floor (2)
SPR$(2,0)="(86,0)"
SPR$(2,1)="(86,4)(87,4)L"
rem circular saw wall right (5)
SPR$(5,0)="(97,0)"
SPR$(5,1)="(97,4)(98,4)L"
rem circular saw wall left (6)
SPR$(6,0)="(99,0)"
SPR$(6,1)="(99,4)(100,4)L"
rem watchdog (1)
SPR$(1,0)="(79,4)(80,4)L"
SPR$(1,1)="(75,4)(76,4)L"
SPR$(1,2)="(77,6)(78,6)L"
SPR$(1,3)="(81,6)(82,6)L"
SPR$(1,4)="(121,6)(122,6)L"
SPR$(1,5)="(123,6)(124,6)L"
SPR$(1,6)="(117,100 )(118,3)"
SPR$(1,7)="(119,100 )(120,3)"
rem guard (0)
SPR$(0,0)="(25,0)"
SPR$(0,1)="(22,0)"
SPR$(0,2)="(22,4)(23,4)(24,4)L"
SPR$(0,3)="(25,4)(26,4)(27,4)L"
SPR$(0,4)="(72,4)(73,4)(74,4)(73,4)L"
rem elevator
SPR$(4,0)="(70,0)"
dim HLP$(20) : rem help panel 2. todo why here.
rem BRICKS CREATION
gosub SUB_LEVEL_ARRAYS : cls back : reserve as data 2,16613
bload "SAM1.BLK",2 : fade 1 : wait 7 : cls logic : unpack 2,back
erase 2

get palette (back) : wait 50 : dim COLLVL(15) : for I=0 to 15 : COLLVL(I)=colour(I) : colour I,0 : next I
LOD$=screen$(back,32,104 to 230,142)
LVLPIC$=screen$(back,16,149 to 80,177)
LVLPIC2$=screen$(back,80,142 to 144,170)
ink 0 : bar 192,138 to 204,145 : PAUSE$=screen$(back,205,139 to 320,183)
COE$=screen$(back,96,80 to 112,88)
screen$(logic,0,160)=COE$
screen$(logic,0,168)=COE$
scroll 4 : scroll 10
COEUR$(0)=screen$(logic,0,160 to 16,168)
COEUR$(1)=screen$(logic,0,168 to 16,176)
screen copy back,0,0,320,8*PTIT to logic,0,0
screen copy logic,0,0,320,8*PTIT to logic,0,8*PTIT
scroll 3 : screen copy logic to back
ink 0 : for X=1 to 40 step 2 : bar X*8,0 to X*8+7,8*PTIT*2 : next X
DEP=0 : ARR=7 : XDEP=0 : XARR=28
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
if CISO=10 then DEP=9 : ARR=9 : XDEP=39 : XARR=39 : CISO=13 : goto CUT_LOOP
if CISO=13 then DEP=9 : ARR=9 : XDEP=34 : XARR=34 : CISO=17 : goto CUT_LOOP
BLK$(365)=BLK$(291)
for I=1 to 30 : inc IND : BLK$(IND)=BLK$(56) : next I
swap BLK$(323),BLK$(320) : swap BLK$(328),BLK$(325) : swap BLK$(329),BLK$(326) : swap BLK$(326),BLK$(327)
for I=365 to 368 : BLK$(I+100)=BLK$(I) : BLK$(I)=BLK$(56) : next I
for I=369 to 415 : BLK$(I+101)=BLK$(I) : BLK$(I)=BLK$(56)
next I
IND=364 : DEP=10 : ARR=10 : XDEP=26 : XARR=40 : CISO=15 : goto CUT_LOOP
@CUT_END
BLK$(469)=BLK$(319) : BLK$(379)=BLK$(416) : BLK$(380)=BLK$(417)
O=1

rem gomme coeur
cls logic : cls back
screen$(logic,16,168)=BLK$(483)
scroll 9
BLK$(600)=screen$(logic,16,168 to 32,176)

cls back : cls logic
gosub FADE_TO_LEVELCOL : gosub LEVEL_LOAD
reserve as data 2,17117 : bload "SAM2.BLK",2 : LVLMX=9
gosub 10600
goto 1310


rem RETURN POINT
@MENU
cls back : cls logic : while joy>=16 : wend
if MUS=1 then music 4 else MUS2=1
rem MENU PANEL
@MENU_2
gosub FADE_TO_BLACK : mode 0 : pen 15 : paper 3
timer=0
unpack 2,back : palette $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
screen copy back to logic : YSC=6 : O=NWLVL
INITMENU=1 : gosub 1740 : gosub 1780 : gosub 1822 : gosub 1860 : gosub 1831 : INITMENU=0
VV(0)=0 : VV(1)=0 : LVL(0)=NWLVL : LVL(1)=NWLVL : PLR=0 : SC(0)=0 : SC(1)=0 : NPBL=-1 : FX2=0 : WIN=-1 : COD2$=left$(COD$,1) : COD=1
PYSC=10 : J=2 : if FX>1 then FX=1
clear key : X$=""
fade 3,$2,$0,$556,$445,$334,$700,$77,$666,$333,$353,$373,$773,$320,$737,$357,$777
while X$="" : X$=inkey$
gosub DEMO_RUN : if DEMO=1 then INTER_LEVEL
rem PAD UP/DOWN
if J<>1 and J<>2 and scancode<>72 and scancode<>80 then 1510
timer=0
if J=1 or scancode=72 then YSC=YSC-2 if YSC=6 then YSC=22
if J=2 or scancode=80 then YSC=YSC+2 if YSC=24 then YSC=8
for I=10 to 30 : rem II=((I-30)*-1)+10
pen 15 : A2$=chr$(scrn(I,PYSC)) : if A2$=" " then 1470
locate I,PYSC : print A2$
next I
for I=10 to 30
pen 5 : A2$=chr$(scrn(I,YSC)) : if A2$=" " then 1500
locate I,YSC : print A2$
next I : PYSC=YSC : wait 7
rem FIRE SELECT
if J>=16 or X$=" " then 1515 else 1530
if YSC<=12 then on YSC/2-3 gosub 1730,1770,1820
if YSC=20 then gosub 1830
if YSC>=14 then on YSC/2-6 goto 8630,8900,9350,1530,INTER_LEVEL
while J>=16 : J=joy : timer=0 : wend
J=joy : wend
if COMPILED=0 and asc(X$)=27 then goto GO_EXIT
if X$="2" then NBP=2 : gosub 1740
if X$="1" then NBP=1 : gosub 1740
rem FUNCTION KEYS FROM F1 (59) TO F7
on scancode-58 gosub 1730,1770,1820
on scancode-61 goto 8630,8900,9350
if X$<>"" then if upper$(X$)=COD2$ then timer=0 : inc COD : if COD=len(COD$)+1 then 10120 else COD2$=mid$(COD$,COD,1) : gosub WAIT_RELEASE : goto 1670
COD=1 : COD2$=left$(COD$,1)
if DEVEL=1 then locate 5,5 : print COD2$; : locate 5,6 : print COD;
transpose COD-1 : clear key : X$="" : goto 1390
rem PLAYER(S)
if NBP=1 then NBP=2 else NBP=1
locate 12,8 : A$=mid$(str$(NBP),2,1)+" PLAYER" : if NBP=2 then A$=A$+"S" else A$=A$+" "
if YSC<>8 then pen 15 else pen 5
goto MENU_1900
rem MUSIQUE ON/OFF
if MUS=0 then MUS=1 else MUS=0
locate 12,10 : A$="MUSIC" : if MUS=0 then A$=A$+" OFF" : music freeze : goto 1800
A$=A$+" ON " : music on : if MUS2=1 then MUS2=0 : music 4
if YSC<>10 then pen 15 else pen 5
goto MENU_1900
rem FX ON/OFF
if FX=1 then FX=0 else FX=1
if YSC<>12 then pen 15 else pen 5
locate 12,12 : A$="FX" : if FX=0 then A$=A$+" OFF" else A$=A$+" ON "
goto MENU_1900
rem GAME MODE
inc GMID : GMID=GMID mod 3
if YSC<>20 then pen 15 else pen 5
locate 12,20 : A$="MODE "+GAMEMDE$(GMID)
on GMID+1 gosub SUB_VAR_ESY,SUB_VAR_NRMAL,SUB_VAR_HARD
MPBL(0)=LIFES : MPBL(1)=LIFES
gosub HELP_TEXTDEF : goto MENU_1900
rem PRINT MENU ENTRIES
locate 18,14 : print "SCORE"
locate 18,16 : print "HELP"
locate 18,18 : print "INFOS"
locate 12,22 : print "LET'S GO !" : return
@MENU_1900
SELTIM=0 : print A$ : if INITMENU=0 then gosub WAIT_RELEASE
return
rem GAME IS OVER (no live left or abandon)
gosub FADE_TO_BLACK
pen 15 : locate 10,11
print "GAME OVER PLAYER";PLR+1
gosub FADE_TO_LEVELCOL
if MUS=1 then music 3 : transpose-10 : tempo 45
gosub WAIT_4SECS : gosub HALL_OF_FAME_ADD
rem GAME IS OVER (game completed and cont.)
LVL(PLR)=NWLVL
if NBP=2 and MPBL(PPLR)>0 then 2160
gosub BANK_NEXT : goto MENU
rem AFTER DEATH
music off : pop : gosub 8524 : for I=2 to NTS(NBPL) : if ST(NBPL,I)=0 or ST(NBPL,I)>=9 then anim I,"(125,7)(126,7)l" : move off I
next I : anim on
if MPBL(PLR)>0 then dec MPBL(PLR)
if MPBL(PLR)>0 then if MUS=1 then music 3
gosub WAIT_4SECS
if DEMO=1 then DEMO=-1 : goto MENU
auto back on : gosub LEVEL_OUT
if MPBL(PLR)=0 then 1940
if NBP=1 or MPBL(PPLR)=0 then INTER_LEVEL
rem PLAYER SWITCH
PLR=PPLR : O=LVL(PLR)
gosub BANK_NEXT
goto INTER_LEVEL

rem INTER-LEVEL PANEL
@INTER_LEVEL
gosub FADE_TO_BLACK : gosub 11500 : if DEMO=1 then gosub FADE_TO_LEVELCOL : goto 2270
music off : if MUS=1 then music 2
sprite 1,64,95,125 : sprite 2,236,95,125 : anim 1,"(125,5)(126,5)l" : anim 2,"(125,5)(126,5)l" : anim on
locate 10,11 : pen 15 : print "GET READY PLAYER";PLR+1
gosub FADE_TO_LEVELCOL
gosub WAIT_4SECS
music off : gosub FADE_TO_BLACK : screen copy FIRSTLVLSCR+BANK to back : screen copy FIRSTLVLSCR+BANK to logic
goto 3340
rem SAM MADE IT
pop : music on : anim off : move off : anim 1,"(127,4)(128,5)l"
anim on : gosub WAIT_4SECS
anim off : sprite 1,X,Y,21 : wait 2 : gosub LEVEL_OUT : inc LVL(PLR) : O=LVL(PLR)
gosub 9650 : if LVL(PLR)<=LVLMX then gosub BANK_NEXT
while BONUSDONE=0 : gosub SCORE_INC : wend
gosub WAIT_4SECS
gosub FADE_TO_BLACK
if LVL(PLR)>LVLMX then 9870
goto INTER_LEVEL
rem TESTS COLLISIONS / MOUVEMENTS NPC
if timer<100 or SUPERM>0 then sprite 1,340,100 : wait vbl : if SUPERM>0 then dec SUPERM : if SUPERM=3 then transpose PLR
sprite 1,X,Y,C : if DEMO=1 then 2550
X$=inkey$
if X$=" " then gosub 9540
if asc(X$)=27 then MPBL(0)=0 : MPBL(1)=0 : goto 5900
if upper$(X$)="A" then X$="" : clear key : goto 6060
gosub 12000
if MUS=1 and FX2>0 then dec FX2 : if FX2=0 then music on
if MUS=0 and FX>=1 then if FX2=0 then FX=1 else dec FX2 : FX=2
if ZNTEST>0 then dec ZNTEST : return
ZNTEST=MOUSKY(NBPL)
if CZI(NBPL)=-1 then 2680 else 2610
MZI=1 : inc CZ2 : if CZ2=CZI(NBPL)+1 then CZ2=0
AC3$=ACT$(NBPL,CZ2) : inc CTIM(NBPL,CZ2) : if CTIM(NBPL,CZ2)=NZIF(NBPL,CZ2)+NZIO(NBPL,CZ2) then CTIM(NBPL,CZ2)=0
I=val(AC3$)
if I=0 then 2680 else gosub FOUY
if CTIM(NBPL,CZ2)=0 then IK=8 : on ZNE2(NBPL,CZ2) gosub 7120,7050,7120,7120 : music on : if ZNE2(NBPL,CZ2)=2 then 2630
if CTIM(NBPL,CZ2)=NZIO(NBPL,CZ2) then IK=1 : on ZNE2(NBPL,CZ2) gosub 7120,7050,7120,7120 : music on : if ZNE2(NBPL,CZ2)=2 then 2630
MZI=0 : if NTS(NBPL)=1 then 2930 else DRC=0 : inc NTS2 : if NTS2=NTS(NBPL)+1 then NTS2=2
if AL(NBPL,NTS2)=0 and AL2(NBPL,NTS2)=0 then 2790 else if ST(NBPL,NTS2)>=9 then 2790 else if ST(NBPL,NTS2)<>0 then 2730
if AL(NBPL,NTS2)=1 then I=NTS2 : goto 6860
dec AL(NBPL,NTS2) : if AL(NBPL,NTS2)=5 then move on NTS2 : anim on NTS2
goto 2930
if movon(NTS2)=0 and FLP(NBPL,NTS2)=NPBL then 2740 else 2790
anim NTS2,DGEM$(NBPL,NTS2,AL2(NBPL,NTS2)) : if mid$(DGEM$(NBPL,NTS2,AL2(NBPL,NTS2)+2),1,1)=" " then move x NTS2,DGEM$(NBPL,NTS2,AL2(NBPL,NTS2)+2) else DGER2$=mid$(DGEM$(NBPL,NTS2,AL2(NBPL,NTS2)+2),2,len(DGEM$(NBPL,NTS2,AL2(NBPL,NTS2)+2))+NPBL) : move y NTS2,DGER2$
if AL2(NBPL,NTS2)=0 then inc AL2(NBPL,NTS2) else dec AL2(NBPL,NTS2)
move on NTS2 : anim on NTS2
goto 2930
if ST(NBPL,NTS2)>9 then dec ST(NBPL,NTS2) : if ST(NBPL,NTS2)>9 then 2930 else ST(NBPL,NTS2)=0 : anim NTS2,RTRP$(NBPL,NTS2) : move on NTS2 : anim on NTS2 : goto 2930
if SS(NBPL,NTS2)=-1 or movon(NTS2)<>0 then 2930
inc FLP(NBPL,NTS2) : if FLP(NBPL,NTS2)=SS(NBPL,NTS2)+1 then FLP(NBPL,NTS2)=FLP(NBPL,NTS2)*-1
if SS(NBPL,NTS2)>=20 then if FLP(NBPL,NTS2)=SS(NBPL,NTS2)-19 then FLP(NBPL,NTS2)=0 : sprite NTS2,XM(NBPL,NTS2),YM(NBPL,NTS2)
if FLP(NBPL,NTS2)>=0 then MV2$=MOV$(NBPL,NTS2,FLP(NBPL,NTS2)) : AN2$=AN$(NBPL,NTS2,FLP(NBPL,NTS2)) : goto 2880
MV2$=MOV$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1) : AN2$=AN$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1)
if mid$(MV2$,6,1)=" " then mid$(MV2$,6,1)="-" else mid$(MV2$,6,1)=" "
if AN2$=SPR$(ST(NBPL,NTS2),3) then AN2$=SPR$(ST(NBPL,NTS2),2) else if AN2$=SPR$(ST(NBPL,NTS2),2) then AN2$=SPR$(ST(NBPL,NTS2),3)
if mid$(AN2$,1,5)=mid$(SPR$(1,6),1,5) then AN2$=mid$(SPR$(1,7),1,5)+mid$(AN$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1),6,4)+mid$(SPR$(1,7),10,8) else if mid$(AN2$,1,5)=mid$(SPR$(1,7),1,5) then AN2$=mid$(SPR$(1,6),1,5)+mid$(AN$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1),6,4)+mid$(SPR$(1,6),10,8)
anim NTS2,AN2$
if mid$(MV2$,1,1)<>"-" then move x NTS2,MV2$ else MV2$=mid$(MV2$,2,20) : move y NTS2,MV2$
if FLP(NBPL,NTS2)<0 then if mid$(MOV$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1),6,1)=" " then mid$(MOV$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1),6,1)="-" else mid$(MOV$(NBPL,NTS2,abs(FLP(NBPL,NTS2))-1),6,1)=" "
move on NTS2 : anim on NTS2
if movon(15)=0 then sprite off 15
if movon(14)=0 then sprite off 14
if movon(13)=0 then sprite off 13
rem SUBSCRIPT OUT OF RANGE
Z=zone(1) : if Z<>0 then 2985 else 2975
if PSTZ=0 and ZNE(NBPL,Z)=O then 3040
if ZNE(NBPL,PSTZ)>30 then if ZNE2(NBPL,ZNE(NBPL,PSTZ)-30)=0 then 7810
PSTZ=0 : goto 3040
on ZNE(NBPL,Z) goto 5980,6060,5350,3060,6160,6210,6260,6320,2290
if ZNE(NBPL,Z)>=20 and ZNE(NBPL,Z)<=29 then 8250
if PSTZ<>0 then if Z=PSTZ then 3040 else if ZNE2(NBPL,ZNE(NBPL,PSTZ)-30)=0 then 7810 else PSTZ=0 : goto 3040
if ZNE(NBPL,Z)>=60 and ZNE(NBPL,Z)<=79 then 7820
if ZNE(NBPL,Z)>=30 and ZNE(NBPL,Z)<=39 then on ZNE2(NBPL,ZNE(NBPL,Z)-30) goto 5980,6060,3060,3060
if FEU=1 and FEU2=0 then if ZNE(NBPL,Z)>=40 and ZNE(NBPL,Z)<=59 then 7670
if FEU=1 and FEU2=0 then if C<=5 then GAME_ACTION else if C<=14 and C>=11 then GAME_ACTION
rem #######################
@
if SUPERM>0 then return
TY=14 : TX=14 : if CR>=1 then TY=8 : if CR=2 then TX=18
SP=0 : FS=2 : T=collide(1,TX,TY) : if T=0 then PLAT=0 : return
for I=FS to 15 : if btst(I,T)=-1 then SP=I : I=16
next I : I=0
if SP>12 then if Y<y sprite(SP) or y sprite(SP)=0 then return else 5980
if ST(NBPL,SP)>=9 then FS=SP+1 : SP=0 : if FS<15 then 3090 else return
if ST(NBPL,SP)=0 or SP(NBPL,SP)>=97 then if abs(x sprite(SP)-X)>8 then return else if DEMO=0 then 3190 else GAME_ACTION
if ST(NBPL,SP)<>4 then 3170 else if x sprite(SP)-X>8 or x sprite(SP)-X<-8 then PLAT=0 : return
if SAUT=0 and PLAT<>-1 then 3210 else return
if Y>y sprite(SP)+2 or Y<y sprite(SP)-4 then PLAT=0 : return
PLAT=0 : if SP(NBPL,SP)=93 or SP(NBPL,SP)=94 then if abs(x sprite(SP)-X)<=8 then 3190 else return
if ST(NBPL,SP)<>3 and Y<y sprite(SP)-8 then 3200 else if CR>=1 and Y>=y sprite(SP) then 3200
on ST(NBPL,SP)+1 goto 5980,5980,5900,5900,3200,5900,5900,5980
return
if Y>y sprite(SP)+2 or Y<y sprite(SP)-4 then PLAT=0 : goto 3200
if PLAT<>SP then 3300 else SP2=SP : SP=0
if point(X+x sprite(PLAT)-XPLAT-E-1,y sprite(PLAT)-4)<=V and point(X+x sprite(PLAT)-XPLAT+E+1,y sprite(PLAT)-4)<=V then 3240 else 3260
if CR=0 then if point(X+x sprite(PLAT)-XPLAT-E-1,y sprite(PLAT)-12)<=V and point(X+x sprite(PLAT)-XPLAT+E+1,y sprite(PLAT)-12)<=V then 3250 else 3260
XPLAT2=x sprite(PLAT) : X=X+XPLAT2-XPLAT : XPLAT=XPLAT2
Y=y sprite(PLAT)-1
if C=10 then C=2 else if C=19 then C=11
for I=2 to 15 : if btst(I,T)=-1 and I<>SP2 then SP=I : I=16 : SP2=0
next I : I=0 : if SP=0 then return else 3110
XPLAT=x sprite(SP)
Y=y sprite(SP)-1
PLAT=SP : goto 3200

rem PREPARE DES SPRITES
PPLR=(PLR+1) mod 2
if NTS(NBPL)=1 then 3370
for I=2 to NTS(NBPL)
FLP(NBPL,I)=NPBL : sprite I,XM(NBPL,I),YM(NBPL,I),SP(NBPL,I) : next I
if NTZ(NBPL)=0 then 3430 else J=0 : for II=1 to NTZ(NBPL)
if ZNE(NBPL,II)>=30 and ZNE(NBPL,II)<=39 then if ACT$(NBPL,ZNE(NBPL,II)-30)<>"" then CTIM(NBPL,J)=NZID(NBPL,J)*NPBL : inc J : goto 3420
if ZNE(NBPL,II)<80 then 3410 else if ZNE2(NBPL,ZNE(NBPL,II)-30)=0 then 3420
IK=8 : AC3$=ACT$(NBPL,ZNE(NBPL,II)-30) : INIT=1 : gosub 7840
set zone II,X1Z(NBPL,II),Y1Z(NBPL,II) to X2Z(NBPL,II),Y2Z(NBPL,II)
next II : J=0
for I=0 to 7 : if SBLK(NBPL,I,0)<>0 then get sprite SBLK(NBPL,I,1),SBLK(NBPL,I,2),SBLK(NBPL,I,0)
next I
FX2=0 : gosub 8440
gosub FADE_TO_LEVELCOL : move on : anim on : hide
TMRDSPL=0 : TIR=0 : X=XD(NBPL) : Y=YD(NBPL) : C=SP(NBPL,1) : ECH=0 : E=4 : V=9 : TEST=1 : NTS2=1 : CZ2=CZI(NBPL) : SUPERM=0 : clear key : timer=0 : volume 16 : if MUS=1 then music 1 : transpose PLR
if TRACE=1 then locate 18,23 : print "NL"+str$(NBPL)+" BK"+str$(BANK)+" PL"+str$(PLR)+" LV"+str$(LVL(PLR)) : locate 0,20
CR=0 : gosub 2510 : gosub GAME_NEXT : if point(X,Y+1)<=V and PLAT<=0 then 4040
rem TRACELOG$="3520" : gosub TRACESUB
if PLAT=0 then 3600 else if C=11 then 3560 else if point(X+E-1,Y-16)>V then PLAT=-1 : goto 4040
if point(X+E-1,Y)>V then PLAT=-1 : goto 4040
goto 3580
if point(X-E+1,Y-16)>V then PLAT=-1 : goto 4040
if point(X-E+1,Y)>V then PLAT=-1 : goto 4040
if point(X-E,Y-12)>V or point(X-E,Y-4)>V then X=(X/8)*8+4
if point(X+E,Y-12)>V or point(X+E,Y-4)>V then X=(X/8)*8+3
gosub GAME_NEXT
on J goto 3640,4610,3620,4370,3640,4870,3620,4490,3640,5020,3620,3620,3620,3620,3620
goto 3520
rem JOYSTICK UP
if Y<16 then 3520
Z=zone(1) : if Z=0 then 3670 else if ZNE(NBPL,Z)=4 then 3660 else if ZNE(NBPL,Z)<30 then 3670 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then 3670
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then 5510
CR=0 : if J<>5 then if point(X+E-1,Y-16)>V then 3520
if J<>9 then if point(X-E+1,Y-16)>V then 3520
if C=11 then C=19 else C=10
gosub GAME_NEXT : if J=9 and PLAT=0 then if point(X+1,Y+1)<=V then X=X+4 : if X>312 then X=312
if J=5 and PLAT=0 then if point(X-1,Y+1)<=V then X=X-4 : if X<8 then X=8
SAUT=0 : while SAUT<18 : if point(X+E-1,Y-12)>V or point(X-E+1,Y-12)>V then 4040
inc SAUT
Z=zone(1) : gosub GAME_NEXT : if Z=0 then 3770 else if ZNE(NBPL,Z)=4 then 3750 else if ZNE(NBPL,Z)<30 then 3770 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then 3770
if J<>1 and J<>9 then if J<>5 then 3790
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then 5510
if J=5 or J=9 then 3790
if J=1 then 3790 else 4040
if SAUT<10 then DXY=2 : Y=Y-2
goto 3830
if SAUT<12 then dec Y
DXY=1
rem TRACELOG$=str$(SAUT) : gosub TRACESUB
rem TRACELOG$="3520" : gosub TRACESUB
if J=9 and PLAC=0 then gosub 4310
if J=5 and PLAC=0 then gosub 4260
if Y<16 then Y=16
gosub 2510
if MUS=0 and FX=1 then volume 16 : envel 1,200 : play 96-Y/2,1
wend : goto 4040
CR=0
while SAUT<4
DXY=2
inc SAUT
rem TRACELOG$="3900" : gosub TRACESUB
gosub GAME_NEXT : Z=zone(1) : if Z=0 then 3960 else if ZNE(NBPL,Z)=4 then 3940 else if ZNE(NBPL,Z)<30 then 3960 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then 3960
if J<>1 and J<>9 then if J<>5 then 3960
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then 5510
if J=8 or J=9 then gosub 4310 : goto 4000
if J=5 or J=4 then gosub 4260 : goto 4000
if J<>9 and J<>8 then if C=10 then gosub 4310
if J<>5 and J<>4 then if C=19 then gosub 4260
Y=Y-2
if Y<16 then Y=16
gosub 2510
wend
SAUT=0 : if Y<8 then Y=15
rem TRACELOG$="4040" : gosub TRACESUB
if PLAT>0 then 3520
DXY=1
if C<=10 then C=10 else C=19
while point(X+E-1,Y+1)<=V : if point(X-E+1,Y+1)>V then 4210
DXY=1
gosub GAME_NEXT : Z=zone(1) : if Z=0 then 4140 else if ZNE(NBPL,Z)=4 then 4120
if ZNE(NBPL,Z)<30 then 4140 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then 4140
if J<>1 and J<>9 then if J<>5 then 4140
goto 5510
if J=8 or J=9 then gosub 4310
if J=4 or J=5 then gosub 4260
Y=Y+2
if MUS=0 and FX=1 then volume 16 : envel 1,200 : play 96-Y/2,1
if Y>184 then gosub 5980
gosub 2510 : if PLAT<>0 then 4240
wend
rem LANDING
if point(X,Y+1)<=V then if point(X+E-1,Y+1)>V then X=X+3 else X=X-3
while point(X,Y)>V : dec Y : wend
while point(X,Y+1)<=V : inc Y : wend
SAUT=0 : if C=19 or C=11 then C=11 else C=2
goto 3520
rem X LEFT LIMIT
if X<8 then X=8
C=19 : if point(X-E,Y-4)>V and point(X-E,Y-12)<=V then pop : goto 5170
if point(X-E-DXY+1,Y)<=V then if point(X-E-DXY+1,Y-4)<=V and point(X-E-DXY+1,Y-8)<=V then X=X-DXY : goto 4350
goto 4350
goto 4350
rem X RIGHT LIMIT
if X>312 then X=312
C=10 : if point(X+E,Y-4)>V and point(X+E,Y-12)<V+1 then pop : goto 5320
if point(X+E+DXY-1,Y)<=V then if point(X+E+DXY-1,Y-4)<=V and point(X+E+DXY-1,Y-8)<=V then X=X+DXY
return
rem JOYSTICK LEFT
CR=0 : if C=2 then for C=21 to 20 step-1 : gosub 2510 : next C : C=11
restore 4470
while J=4 and point(X-E,Y-12)<=V : if point(X-E,Y-4)>V then if PLAT>0 then 3520 else C=66 : X=X+4 : goto 5280
dec X : read C : if C=0 then restore 4470 : read C
if MUS=0 and FX=1 then if C=12 and C10=0 then volume 16 : envel 1,2000 : noise 25 : FX2=5
if X<8 then X=8
gosub 2510 : gosub GAME_NEXT
if PLAT<=0 and point(X,Y+1)<=V then C=19 : X=(X/8)*8+4 : goto 4040
wend
C=11 : gosub 2510
goto 3520
data 12,12,12,13,13,13,14,14,14,0
rem JOYSTICK RIGHT
CR=0 : if C=11 then for C=20 to 21 : gosub 2510 : next C : C=2
restore 4580 : while J=8 and point(X+E,Y-12)<=V : if point(X+E,Y-4)>V then if PLAT>0 then 3520 else C=59 : X=X-4 : goto 5430
inc X : read C : if C=0 then restore 4580 : read C
if MUS=0 and FX=1 then if C=3 and C10=0 then volume 16 : envel 1,2000 : noise 25 : FX2=5
if X>312 then X=312
gosub 2510 : gosub GAME_NEXT
if PLAT<=0 and point(X,Y+1)<=V then C=10 : X=(X/8)*8+3 : goto 4040
wend : C=2
gosub 2510 : goto 3520
data 3,3,3,4,4,4,5,5,5,0
rem JOYSTICK DOWN
CR=1 : if C=11 then for C=15 to 16 : gosub 2510 : next C : C=16 : goto 4630
if C=2 then for C=6 to 7 : gosub 2510 : next C : C=7
CR=1 : gosub GAME_NEXT : while J=2 : gosub GAME_NEXT : gosub 2510
if PLAT<=0 then if point(X+E-1,Y+1)<=V and point(X-E+1,Y+1)<=V then Y=Y+6 : goto 4040
wend
if PLAT<=0 then 4700
if J=0 and Y>7 then if point(X+E-1,Y-9)<=V and point(X-E+1,Y-9)<=V then 4790
if J<=6 then C=16 else C=7
gosub 2510 : goto 4630
gosub GAME_NEXT : if Y<8 then 4730
if J=5 and C=16 then if point(X-1,Y+1)<=V then C=19 : goto 4760
if J=9 and C=7 then if point(X+1,Y+1)<=V then C=10 : goto 4760
if J=6 or J=4 then 4890 else if J=10 or J=8 then 5040
if Y>7 and J=0 then if point(X+E-1,Y-9)<=V and point(X-E+1,Y-9)<=V then 4790
gosub 2510 : gosub GAME_NEXT : goto 4700
Y=Y+6
if C=19 then X=X-2 else X=X+2
CR=0 : goto 3890
rem GET UP RIGHT
if C=16 then 4830
for C=7 to 6 step-1 : sprite 1,X,Y,C
if ZNE(NBPL,Z)<>5 and ZNE(NBPL,Z)<>6 then gosub 2510
next C : C=2 : sprite 1,X,Y,C : goto 3520
rem GET UP LEFT
for C=16 to 15 step-1 : sprite 1,X,Y,C
if ZNE(NBPL,Z)<>5 and ZNE(NBPL,Z)<>6 then gosub 2510
next C : C=11 : sprite 1,X,Y,C : goto 3520
rem JOYSTICK DOWN LEFT
CR=2 : if C=2 then for C=20 to 21 : gosub 2510 : next C
for C=15 to 16 : gosub 2510 : next C
CR=2 : restore 4990
inc X : gosub GAME_NEXT : while J=4 or J=6
if MUS=0 and FX=1 then volume 16 : envel 7,500 : noise rnd(1)+9 : FX2=4
if PLAT<=0 and point(X-1,Y+1)<=V then C=11 : X=X-4 : goto 4040
if point(X-E,Y-1)>V then 4960
dec X : read C : if C=0 then restore 4990 : read C
if X<8 then X=8
gosub 2510 : gosub GAME_NEXT
wend : if Y<8 then 4790 else if J=2 or point(X+E-1,Y-9)>V then 5000 else if point(X-E+1,Y-9)>V then 5000
C=16 : goto 4830
data 17,17,17,18,18,18,0
C=16 : sprite 1,X,Y,16 : goto 4630
rem JOYSTICK DOWN RIGHT
CR=2 : if C=11 then for C=21 to 20 step-1 : gosub 2510 : next C
for C=6 to 7 : gosub 2510 : next C
CR=2 : restore 5140
dec X : gosub GAME_NEXT : while J=8 or J=10
if MUS=0 and FX=1 then volume 16 : envel 7,500 : noise rnd(1)+8 : FX2=5
if PLAT=0 and point(X+1,Y+1)<=V then C=2 : X=X+4 : goto 4040
if point(X+E,Y-1)>V then 5110
inc X : read C : if C=0 then restore 5140
if X>312 then X=312
gosub 2510 : gosub GAME_NEXT
wend : if Y<8 then 4790 else if J=2 or point(X+E-1,Y-9)>V then 5150 else if point(X-E+1,Y-9)>V then 5150
C=7 : goto 4790
data 8,8,8,9,9,9,0
C=7 : sprite 1,X,Y,7 : goto 4630
rem ADJUSTING CLIMB LEFT POSITION
CR=1 : while point(X-E,Y-6)>V : dec Y : C=19 : gosub 2510 : wend
while point(X-E,Y-5)<=V : inc Y : C=19 : gosub 2510 : wend
C=62
inc C
if C=63 then Y=Y+5 : X=X+4
if C=64 then dec Y
if C=66 then Y=Y-2
if C=67 then Y=Y-4
if C=68 then dec Y
if C=69 then Y=Y-3 : X=X-8
if C=70 then C=16
ZNTEST=1 : gosub 2510
if C<>16 then 5200 else gosub GAME_NEXT : gosub GAME_NEXT
SAUT=0 : if J=2 or Y<8 then 4630 else if point(X-E+1,Y-8)>V or point(X+E-1,Y-8)>V then 4630 else 4830
rem ADJUSTING CLIMB RIGHT POSITION
CR=1 : while point(X+E,Y-6)>V : dec Y : C=10 : gosub 2510 : wend
while point(X+E,Y-5)<=V : inc Y : C=10 : gosub 2510 : wend
C=55
inc C
if C=56 then Y=Y+5 : X=X-4
if C=57 then dec Y
if C=59 then Y=Y-2
if C=60 then Y=Y-4
if C=61 then dec Y
if C=62 then Y=Y-3 : X=X+8
if C=63 then C=7
ZNTEST=1 : gosub 2510
if C<>7 then 5350 else gosub GAME_NEXT : gosub GAME_NEXT
SAUT=0 : if J=2 or Y<8 then 4630 else if point(X+E-1,Y-8)>V or point(X-E+1,Y-8)>V then 4630 else 4790
rem LADDER RELATED
if Y<16 then 3520
if joy=9 or joy=5 then 3720
if joy<>1 then 3520 else C=10 : goto 3720
rem LADDER
restore 5780 : C=55 : SAUT=0
if SUPERM>0 or timer<100 then wait vbl
Z=zone(1) : if Z=0 then 5460 else if ZNE(NBPL,Z)=4 then 5550
if ZNE(NBPL,Z)<30 then 5460 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then 5460
gosub GAME_NEXT
if J=0 then 5770
if J<>1 and J<>9 then if J<>5 then 5630
if HHH<>1 then HHH=1
if point(X+E-1,Y-16)>V or point(X-E+1,Y-16)>V then if DEMO=0 then HHH=-1
if J=9 and X<=315 then 5790
if J=5 and X>=4 then 5840
goto 5720
if J<>2 and J<>6 then if J<>10 then 5690
if HHH<>0 then HHH=0
if point(X+E-1,Y+1)>V or point(X-E+1,Y+1)>V then HHH=-1
if J=10 and X<=315 then 5790
if J=6 and X>=4 then 5840
goto 5720
HHH=-1 : if J=8 and X<=315 then 5790
if J=4 and X>=4 then 5840
goto 5520
read C : if C=0 then restore 5780 : read C
if C=53 then if MUS=0 and FX=1 then volume 16 : envel 1,1000 : noise Y/6+1 : FX2=4
if HHH=1 and C=54 then Y=Y-2
if HHH=0 then if C=53 or C=55 then Y=Y+2
if Y<16 then Y=16
gosub 2510 : goto 5520
data 54,55,54,53,0
if point(X+E,Y-15)>V then 5720
if point(X+E,Y-12)>V then 5720
if point(X+E,Y-6)>V then 5320
if point(X+E,Y)>V then 5720
inc X : goto 5720
if point(X-E,Y-15)>V then 5720
if point(X-E,Y-12)>V then 5720
if point(X-E,Y-6)>V then 5170
if point(X-E,Y)>V then 5720
dec X : goto 5720
rem ANIME DEAD : SPLITED BY SAW
for I=13 to 15 : sprite off I : next I
anim off 1 : while point(X,Y+1)<=V : inc Y : sprite 1,X,Y : if Y=183 then 5930
wend : wait 15
D=19 : if C<=10 then D=2 else if C>=56 and C<=62 then D=2 else if C=90 then D=2
sprite 1,X,Y,D : wait 3 : if D=2 then sprite 1,X,Y,21 else sprite 1,X,Y,20
wait 15 : anim 1,"(48,30)(49,10)(50,10)(51,10)(52,10)" : anim on
wait 70 : anim 1,"(51,4)(52,4)l" : anim on
goto 2080
rem ANIME DEAD : OUT OF SCREEN JUMP
if SUPERM>0 and Y<184 then return
for I=13 to 15 : sprite off I : next I : if X>160 then C=42 else C=43
anim off 1 : sprite 1,X,Y,C
move y 1,"(1,-2,10)(1,0,10)(1,2,10)(1,3,30)(1,4,40)" : if C=42 then move x 1,"(1,-2,70)" else move x 1,"(1,2,70)(2,1,50)"
move on 1 : while y sprite(1)<220 : wend : move off 1 : wait 10 : if FX>=1 then music freeze : volume 16 : envel 1,15000 : noise 31
sprite 1,x sprite(1),210,44 : anim 1,"(45,30)(46,30)(47,30)"
move y 1,"(2,-1,0)" : move on 1 : anim on : if FX>=1 then wait 50
goto 2080
rem ANIME DEAD : ELECTRIC SHOCK
if SUPERM>0 then return
if CR<>0 and Y=Y1Z(NBPL,Z)+15 then if Y2Z(NBPL,Z)-Y1Z(NBPL,Z)<=X2Z(NBPL,Z)-X1Z(NBPL,Z) then 3060
anim off 1
anim 1,"(33,1)(34,1)L" : timer=0 : anim on
if MUS=1 and FX>=1 then music off : volume 16
if FX>=1 then envel 1,300 : noise 15 : noise 30 : noise 5
if timer<70 then 6110
anim 1,"(35,1)(36,10)(37,8)(38,8)(39,8)(40,4)(41,8)" : move y 1,"(5,-1,0)" : anim on 1 : move on 1 : timer=0
goto 2080
rem COLLISION TESTS
if point(X-E,Y)>V then 3060
if CR=0 then if point(X-E,Y-9)>V then 3060
dec X
if point(X,Y+1)<=V then X=(X/8)*8+4
goto 3060
if point(X+E,Y)>V then 3060
if CR=0 then if point(X+E,Y-9)>V then 3060
inc X
if point(X,Y+1)<=V then X=(X/8)*8+3
goto 3060
if point(X-E,Y)>V then 3060
if CR=0 then if point(X-E,Y-9)>V then 3060
if YES=0 then dec X : YES=1
YES=0 : goto 3060
if point(X,Y+1)<=V then if joy<>8 then X=(X/8)*8+4 else inc X
goto 3060
if point(X+E,Y)>V then 3060
if CR=0 then if point(X+E,Y-9)>V then 3060
if YES=0 then inc X : YES=1
YES=0 : goto 3060
if point(X,Y+1)<=V then if joy<>4 then X=3+(X/8)*8 else dec X
goto 3060

rem SUB READ LEVEL FILE
@LEVEL_LOAD
FILE$=SAM$+mid$(str$(LVL(PLR)),2,2)+".SAM" : gosub LL_ANIME
if TRACE=1 then locate 20,23 : pen 1 : print "LOAD "+FILE$+" NB"+str$(NBPL)+" BK"+str$(BANK)+" PLR"+str$(PLR) : locate 0,20
LVLBANK(BANK)=LVL(PLR) : NBPL=BANK
open in #1,FILE$ : pof(#1)=0 : NV=0 : for I=0 to 1 : for J=0 to 22 : for K=0 to 39 : MP(NBPL,I,K,J)=0 : next K : next J : next I : for I=1 to 110 : ZNE(NBPL,I)=0 : if I<=80 then ZNE2(NBPL,I)=0 : ACT$(NBPL,I)=""
next I
NV=-1 : input #1,X$ : MOUSKY(NBPL)=val(X$) : if SAM$="SAM" then X=instr(X$,"/") : Y=val(mid$(X$,X+1,len(X$)-X))
input #1,L$ : NV=0
input #1,X$ : if asc(X$)>64 then inc NV : if NV<2 then 9360 else LL_6670
input #1,Y$
X=val(X$) : Y=val(Y$)
if BONUSDONE=0 then gosub SCORE_INC
@LL_6560
input #1,X$
if val(X$)<0 then MP(NBPL,NV,X,Y)=val(X$)*-1 else LL_6630
FOUY=instr(X$,"/") : if FOUY<>0 then ID2=val(mid$(X$,FOUY+1,6))-1 : IND=val(X$)*-1
inc X : if X>39 then X=0 : inc Y : if Y=23 then Y=0 : goto 6660
if BONUSDONE=0 then gosub SCORE_INC
if ID2=0 then LL_6560
dec ID2 : MP(NBPL,NV,X,Y)=IND : goto 6590
@LL_6630
if asc(X$)<65 then input #1,Y$ : goto 6540
inc NV : if NV>=2 then 6670 else input #1,X$ : if asc(X$)<65 then input #1,Y$ : goto 6540
goto 6640
input #1,X$ : inc NV : if NV<2 then 6520
@LL_6670
input #1,X$,Y$,Z$ : XD(NBPL)=val(X$) : YD(NBPL)=val(Y$) : SP(NBPL,1)=val(Z$)
input #1,Y$ : NTS(NBPL)=val(Y$) : if NTS(NBPL)=1 then 6750
for X=2 to NTS(NBPL) : input #1,X$,Y$,Z$,ZE$,ZF$ : XM(NBPL,X)=val(X$) : YM(NBPL,X)=val(Y$) : SP(NBPL,X)=val(Z$) : SS(NBPL,X)=val(ZE$) : ST(NBPL,X)=val(ZF$)
NBM=0 : if SS(NBPL,X)>=20 then NBM=19
for I=0 to SS(NBPL,X)-NBM : line input #1,47,AN$(NBPL,X,I)
if asc(mid$(AN$(NBPL,X,I),1,1))=13 then AN$(NBPL,X,I)=mid$(AN$(NBPL,X,I),3,len(AN$(NBPL,X,I))-2)
next I
for I=0 to SS(NBPL,X)-NBM : line input #1,47,MOV$(NBPL,X,I)
if asc(mid$(MOV$(NBPL,X,I),1,1))=13 then MOV$(NBPL,X,I)=mid$(MOV$(NBPL,X,I),3,len(MOV$(NBPL,X,I))-2)
next I
line input #1,47,DGEM$(NBPL,X,0) : line input #1,47,DGEM$(NBPL,X,1) : line input #1,47,DGEM$(NBPL,X,2) : if X<>NTS(NBPL) then line input #1,47,DGEM$(NBPL,X,3) else line input #1,DGEM$(NBPL,X,3)
next X
for I=0 to 7 : input #1,X$,Y$,Z$ : SBLK(NBPL,I,0)=val(X$) : SBLK(NBPL,I,1)=val(Y$) : SBLK(NBPL,I,2)=val(Z$) : next I
input #1,X$ : NTZ(NBPL)=val(X$) : if NTZ(NBPL)=0 then 6770
for X=0 to NTZ(NBPL) : input #1,X$,Y$,Z$,A$,B$ : ZNE(NBPL,X)=val(X$) : X1Z(NBPL,X)=val(Y$) : Y1Z(NBPL,X)=val(Z$) : X2Z(NBPL,X)=val(A$) : Y2Z(NBPL,X)=val(B$) : next X
input #1,X$ : CZI(NBPL)=val(X$) : if CZI(NBPL)=-1 then 6790
for X=0 to CZI(NBPL) : input #1,X$,Y$,Z$ : NZID(NBPL,X)=val(X$) : NZIO(NBPL,X)=val(Y$) : NZIF(NBPL,X)=val(Z$) : next X
input #1,X$ : X=val(X$) : if X=-1 then LL_6800
input #1,ACT$(NBPL,X)
goto 6790
@LL_6800
input #1,X$ : X=val(X$) : if X=-1 then 6810
input #1,X$ : ZNE2(NBPL,X)=val(X$)
goto LL_6800
close #1 : gosub FADE_TO_BLACK
if TRACE=1 then locate 0,23 : centre "                                     " : locate 0,20
rem PREPARE PLR LEVEL
gosub SUB_LEVEL_DRAW
screen copy logic to FIRSTLVLSCR+BANK : cls back : cls logic
return
rem WARDERS SHOOT ?
if movon(15)=0 then BAL=0 else if movon(14)=0 then BAL=1 else if movon(13)=0 then BAL=2
if BAL=-1 then 2790
FLP2=FLP(NBPL,I) : if FLP2<0 then D$=mid$(MOV$(NBPL,I,abs(FLP2)-1),6,1) else D$=mid$(MOV$(NBPL,I,FLP2),6,1)
if FLP2<0 then if D$="-" then D$=" " else D$="-"
if X>x sprite(I) and D$=" " then SPF=28 : goto 6930
if X<x sprite(I) and D$="-" then SPF=29 : goto 6930
goto 2790
rem WARDERS SHOOT !
AL(NBPL,I)=20 : move freeze I : anim freeze I
SPF=SPF+rnd(1)*2 : if SPF=30 or SPF=31 then SPF2=-4 else SPF2=0
sprite I,x sprite(I),y sprite(I),SPF
if SPF=28 or SPF=30 then SPF=4 else SPF=-4
sprite 15-BAL,x sprite(I)+SPF,y sprite(I)-10-SPF2,32
if SPF=-4 then move x 15-BAL,"(1,-4,40)" else move x 15-BAL,"(1,4,40)"
move on 15-BAL : if FX>=1 then music on : music freeze : volume 16 : envel 1,5000 : noise 25 : FX2=10 : if MUS=0 then FX2=25 : FX=2
FLP2=0
BAL=-1
goto 2970
rem LASER ON/OFF
if X2Z(NBPL,I)-X1Z(NBPL,I)>=Y2Z(NBPL,I)-Y1Z(NBPL,I) then 7070
ink IK : draw X1Z(NBPL,I)+4,Y1Z(NBPL,I)+3 to X1Z(NBPL,I)+4,Y2Z(NBPL,I)-4 : goto 7080
ink IK : draw X1Z(NBPL,I)+3,Y1Z(NBPL,I)+4 to X2Z(NBPL,I)-4,Y1Z(NBPL,I)+4
if IK=1 then reset zone I else set zone I,X1Z(NBPL,I),Y1Z(NBPL,I) to X2Z(NBPL,I),Y2Z(NBPL,I)
if FX=0 or INIT=1 then return else music on : music freeze : volume 16
if IK=1 then envel 1,750 : play 95,1 : FX2=15 : return
envel 4,750 : play 96,1 : FX2=15 : return
REP=val(AC3$) : gosub FOUY
TAY=val(AC3$) : gosub FOUY
XDEST=val(AC3$) : gosub FOUY
YDEST=val(AC3$) : gosub FOUY
XPIC=val(AC3$) : gosub FOUY
YPIC=val(AC3$) : gosub FOUY
XPIC2=val(AC3$) : gosub FOUY
YPIC2=val(AC3$) : gosub FOUY
if IK=8 then set zone I,X1Z(NBPL,I),Y1Z(NBPL,I) to X2Z(NBPL,I),Y2Z(NBPL,I) : goto 7220
reset zone I : XPIC=XPIC2 : YPIC=YPIC2
if TAY=1 or TAY=3 then SBNK=71 else SBNK=1
if TAY=3 then TAY=2
get sprite XPIC,YPIC,SBNK : wait vbl
if abs(REP)=1 then sprite 9,XDEST,YDEST,SBNK : wait vbl : put sprite 9 : wait vbl : goto 7330
if REP<0 then REP=abs(REP) : goto 7300
if TAY=1 and REP>4 then REP=4 else if TAY=2 then REP=REP/2 : if REP>4 then REP=4
for I=0 to REP-1 : sprite 9+I,XDEST+I*8*TAY,YDEST,SBNK : next I : wait vbl
goto 7320
if TAY=1 and REP>4 then REP=4 else if TAY=2 then REP=REP/2 : if REP>4 then REP=4
for I=0 to REP-1 : sprite 9+I,XDEST,YDEST+I*8*TAY,SBNK : next I : wait vbl
for I=0 to REP-1 : put sprite 9+I : next I : wait vbl
for I=0 to REP-1 : sprite off 9+I : next I : wait vbl
return

@FOUY
FOUY=instr(AC3$,"/") : AC3$=mid$(AC3$,FOUY+1,len(AC3$)-FOUY)
return

rem JOYSTICK READ / DEMO CONT/END
rem ### PLAYER INPUTS
@GAME_NEXT
if DEMO=0 then J=joy : goto GAME_PADVALUES
rem ### DEMO INPUTS
if timer>800 or joy>=16 or inkey$<>"" then goto DEMO_END
dec DEMTIM : if DEMTIM>0 then GAME_PADVALUES
J=JDEM(DEMP) : DEMTIM=TDEM(DEMP) : inc DEMP
@GAME_PADVALUES
if COMPILED then wait COMPDELAY
if BOUT>0 then gosub GAME_DRUNK
if J<16 then FEU2=0 : FEU=0 : return
J=J-16 : if FEU2=0 then FEU=1
return

rem DRUNK, SHUFFLE INPUTS
@GAME_DRUNK
dec BOUT : if J>=16 then J=J-16
if J=2 then J=9 else if J=10 then J=1 else if J=8 then J=5 else if J=9 then J=4 else if J=1 then J=6 else if J=5 then J=2 else if J=4 then J=10 else if J=6 then J=8
if BOUT=0 then transpose PLR : tempo 100
return

rem PUNCH OR ACTION LEFT OR RIGHT
@GAME_ACTION
TIM=200 : COUP=0 : if C<=5 then anim 1,"(101,5)(102,12)" else anim 1,"(105,9)(106,12)" : COUP=3
anim on : FEU2=1 : SP=0 : if DEMO=1 then FEU=0 : FEU2=0
if timer<100 then wait vbl
DB=2 : T=collide(1,TX+1,TY) : if T=0 then dec TIM : if TIM>0 then 7480 else anim off 1 : goto 3200
for I=DB to 15 : if btst(I,T)=-1 then SP=I : I=16
next I : I=0 : if SP>8 then 3060
if ST(NBPL,SP)>=9 then DB=SP+1 : SP=0 : goto 7490
if ST(NBPL,SP)<>0 then GA_7650
if Y>y sprite(SP)+4 or Y<y sprite(SP)-2 then GA_7650
if C<=5 and x sprite(SP)<X then GA_7650 else if C>=11 and x sprite(SP)>X then GA_7650
anim freeze SP : move freeze SP : if C<=5 then anim 1,"(103,8)(104,18)(103,8)" else anim 1,"(107,8)(108,18)(107,8)"
sprite SP,x sprite(SP),y sprite(SP),109+COUP : if FX>=1 then music on : music freeze : volume 16 : envel 1,5000 : noise 24 : FX2=20
while TIM>0 : dec TIM : wend : anim on 1 : sprite SP,x sprite(SP),y sprite(SP),110+COUP
TIM=200 : CFLIC=110+COUP
while TIM>0 : dec TIM : if TIM=100 then CFLIC=111+COUP : if FX>=1 then envel 1,5000 : noise 27 : FX2=10 : if MUS=0 then FX2=30
sprite SP,x sprite(SP),y sprite(SP),CFLIC
wend : anim SP,"(115,12)(116,12)L" : anim on : ST(NBPL,SP)=100/NTS(NBPL) : if FLP(NBPL,SP)>=0 then RTRP$(NBPL,SP)=AN$(NBPL,SP,FLP(NBPL,SP)) : goto 7640
if AN$(NBPL,SP,abs(FLP(NBPL,SP))-1)=SPR$(0,4) then RTRP$(NBPL,SP)=SPR$(0,4) : goto GA_GUARD_KO
if AN$(NBPL,SP,abs(FLP(NBPL,SP))-1)=SPR$(0,2) then RTRP$(NBPL,SP)=SPR$(0,3) else RTRP$(NBPL,SP)=SPR$(0,2)
@GA_GUARD_KO
SC(PLR)=SC(PLR)+PTSGUARD
@GA_7650
I=PLR : gosub 8480 : TIM=0 : anim off 1 : goto 3110
W=ZNE(NBPL,Z)-30
if ZNE2(NBPL,W)=2 and NKEY>0 then dec NKEY : ZNE2(NBPL,W)=4 : goto 7830
if ZNE2(NBPL,W)=3 and OKEY>0 then dec OKEY : ZNE2(NBPL,W)=5 : goto 7830
if ZNE2(NBPL,W)>1 then 3060
if X2Z(NBPL,Z)-X1Z(NBPL,Z)=16 and (X1Z(NBPL,Z)/16)*16<>X1Z(NBPL,Z) then CAL=8
if X2Z(NBPL,Z)-X1Z(NBPL,Z)=24 then CAL=8
if C<=10 and X+2>X1Z(NBPL,Z)+CAL then 7760
if C>10 and X-8<X1Z(NBPL,Z)+CAL then 7760
if C<=5 then sprite 1,X,Y,90 else if C>=11 and C<=14 then sprite 1,X,Y,91
if ZNE2(NBPL,W)=1 then ZNE2(NBPL,W)=0 else ZNE2(NBPL,W)=1
BR=MP(NBPL,1,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)
if MP(NBPL,0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)<>0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(MP(NBPL,0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
if FX=1 then music on : music freeze : volume 16 : envel 4,750 : if BR<357 then noise 1 else play 40,1
screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR+ZNE2(NBPL,W)) : goto 7830
W=ZNE(NBPL,PSTZ)-30 : if PSTZ<>0 then PSTZ3=1
PSTZ=0 : goto 7830
if ZNE(NBPL,Z)>=60 and ZNE(NBPL,Z)<=79 then W=ZNE(NBPL,Z)-30 : PSTZ=Z : BR=0
AC3$=ACT$(NBPL,W) : if Z<=0 and PSTZ3=0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR+ZNE2(NPBL,W))
I=val(AC3$) : gosub FOUY : if I=0 then 7930
ZBNE=val(AC3$) : gosub FOUY : if ZBNE<>0 then 7870 else if AL(NBPL,I)=0 and ST(NBPL,I)<9 then AL(NBPL,I)=1 else AL(NBPL,I)=0 : if ST(NBPL,I)<9 then move on I : anim on I
goto 7840
ZBNE2=val(AC3$) : gosub FOUY
if ZNE(NBPL,I)=ZBNE then ZNE(NBPL,I)=ZBNE2 else ZNE(NBPL,I)=ZBNE
if ZNE(NBPL,I)=ZBNE then IK=8 : goto 7910
IK=1
on ZBNE gosub 7120,7050,7120,7120
FX2=10 : goto 7840
if INIT=1 then INIT=0 : return
if PSTZ<>0 then 7980
FEU2=1 : if BR<=MANETS or ZNE2(NBPL,W)>1 then 7980 else ZNE2(NBPL,W)=0
if MP(NBPL,0,(X1Z(NBPL,Z)+CAL)/8,Y1Z(NBPL,Z)/8)<>0 then screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(MP(NBPL,0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
screen$(back,X1Z(NBPL,Z)+CAL,Y1Z(NBPL,Z))=BLK$(BR)
PSTZ3=0 : CAL=0 : goto 3060

rem SUB GETTING OUT OF A LEVEL
@LEVEL_OUT
gosub FADE_TO_BLACK : reset zone : BTIM=0 : for I=2 to NTS(NBPL) : if ST(NBPL,I)>=9 then ST(NBPL,I)=0
next I : cls back : cls logic
FEU=0 : FEU2=1 : PLAT=0 : BOUT=0 : NKEY=0 : OKEY=0 : PSTZ=0 : FX2=0
for I=0 to 8 : AL2(NBPL,I)=0 : AL(NBPL,I)=0 : next I : PLAT=0
for II=50 to 80 : AC3$=ACT$(NBPL,II) : if AC3$="" then LO_8090
@LO_8050
I=val(AC3$) : gosub FOUY : if I=0 then LO_8090 else ZBNE=val(AC3$) : gosub FOUY : if ZBNE=0 then LO_8050 else ZBNE2=val(AC3$) : gosub FOUY
ZNE(NBPL,I)=ZBNE2
IK=1 : if ZBNE<>2 then for J=0 to 7 : gosub FOUY : next J
goto LO_8050
@LO_8090
next II : Z=0 : CAL=0
@LO_8100
inc Z : if Z>NTZ(NBPL) then Z=0 : goto LO_8170
if ZNE(NBPL,Z)<40 or ZNE(NBPL,Z)>59 then LO_8100
if ZNE2(NBPL,ZNE(NBPL,Z)-30)=4 then ZNE2(NBPL,ZNE(NBPL,Z)-30)=2 : goto LO_8100
if ZNE2(NBPL,ZNE(NBPL,Z)-30)=5 then ZNE2(NBPL,ZNE(NBPL,Z)-30)=3 : goto LO_8100
if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>1 then goto LO_8100
ZNE2(NBPL,ZNE(NBPL,Z)-30)=0
goto LO_8100
@LO_8170
return

rem OBJECTS CONSEQUENCES
reset zone Z : screen$(back,X1Z(NBPL,Z),Y1Z(NBPL,Z))=BLK$(MP(NBPL,0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
if Y<>Y1Z(NBPL,Z)+7 then screen$(logic,X1Z(NBPL,Z),Y1Z(NBPL,Z))=BLK$(MP(NBPL,0,X1Z(NBPL,Z)/8,Y1Z(NBPL,Z)/8))
on ZNE(NBPL,Z)-19 goto 8350,8330,8280,8290,8390,8310,8370
rem WINE
BOUT=600/NTS(NBPL) : transpose-20 : tempo 50 : goto 3060
rem WREATH
SC(PLR)=SC(PLR)+PTSWREATH : I=PLR : gosub 8480 : if FX=1 then music on : music freeze : volume 16 : envel 1,7000 : play 70,3 : play 80,1 : FX2=15 : if MUS=0 then FX2=25 : FX=2
goto 3060
rem COIN
SC(PLR)=SC(PLR)+PTSCOIN : I=PLR : gosub 8480 : if FX>=1 then music on : music freeze : volume 16 : envel 1,5000 : play 90,1 : FX2=10 : if MUS=0 then FX2=25 : FX=2
goto 3060
rem KEY 2
inc OKEY : if FX>=1 then music on : music freeze : volume 16 : envel 1,10000 : play 90,1 : FX2=10 : if MUS=0 then FX2=25 : FX=2
goto 3060
rem KEY 1
inc NKEY : if FX>=1 then music on : music freeze : volume 16 : envel 1,10000 : play 85,1 : FX2=10 : FX=2
goto 3060
rem INVICIBLE
SUPERM=300 : transpose 5+PLR : if FX>=1 then music on : music freeze : volume 16 : envel 1,5000 : play 40,1 : play 41,1 : play 42,1 : play 43,1 : play 44,1 : play 45,1 : play 46,1 : play 47,1 : play 48,1 : play 49,1 : play 50,1 : play 51,1 : FX2=10
goto 3060
rem EXTRA LIFE
inc MPBL(PLR) : if FX>=1 then music on : music freeze : volume 16 : envel 1,5000 : play 35,3 : play 55,5 : play 50,1 : FX2=10 : if MUS=0 then FX2=20 : FX=2
screen copy back,X1Z(NBPL,Z),Y1Z(NBPL,Z)-8,X1Z(NBPL,Z)+16,Y1Z(NBPL,Z) to back,X1Z(NBPL,Z),Y1Z(NBPL,Z)
screen copy back,X1Z(NBPL,Z),Y1Z(NBPL,Z)-8,X1Z(NBPL,Z)+16,Y1Z(NBPL,Z) to logic,X1Z(NBPL,Z),Y1Z(NBPL,Z)
gosub 8520 : goto 3060
rem SCORE DISPLAY INIT
THISPLR=PLR
for PLR=0 to NBP-1
screen$(back,0,184+PLR*8)=BLK$(328+PLR) : screen$(logic,0,184+PLR*8)=BLK$(328+PLR)
if MPBL(PLR)>0 then for COEPOS=0 to MPBL(PLR)-1 : gosub 8521 : next COEPOS
if PLR=THISPLR then pen 15 else pen 12
WIN=-1 : gosub 8480
next PLR
PLR=THISPLR
return
rem SCORE UPDATE
C$=mid$(str$(SC(PLR)),2) : L=7-len(C$)
while L>0 : C$="0"+C$ : dec L : wend
locate 1,23+PLR : print using ".~~~~~~~";C$;
gosub 8560

@EXTRA_LIFE_CHECK
if SC(PLR)>999 and int(SC(PLR)/PTSEXTRALIFE)>=VV(PLR)+1 then EXTRA_LIFE
return

rem LIFES DISPLAY ADD
@LIFE_ADD
screen$(back,COEX,COEY)=COEUR$(COEID) : screen$(logic,COEX,COEY)=COEUR$(COEID) : return
COEPOS=MPBL(PLR)-1
gosub 8526 : COEX=COEFIRST+COEPOS16*8 : COEY=184+PLR*8 : gosub 8519
return

rem LIFES DISPLAY DEL
@LIFE_DEL
COEPOS=MPBL(PLR)-1 : gosub 8526 : if COEID=0 then GOM=483 else GOM=600
screen$(back,COEFIRST+COEPOS16*8,184+PLR*8)=BLK$(GOM) : screen$(logic,COEFIRST+COEPOS16*8,184+PLR*8)=BLK$(GOM)
COEFIRST=64+16*NBP : COEID=COEPOS mod 2 : if COEID=0 then COEPOS16=COEPOS else COEPOS16=COEPOS-1
return

rem EXTRA LIFE BY SCORE
@EXTRA_LIFE
inc VV(PLR) : inc MPBL(PLR)
if DEVEL=1 then locate 0,VV(PLR) : print VV(PLR)
if FX=1 then music on : music freeze : volume 16 : envel 1,5000 : play 40,1 : play 41,1 : play 42,1 : play 43,1 : play 44,1 : play 45,1 : play 46,1 : play 47,1 : play 48,1 : play 49,1 : play 50,1 : play 51,1 : if TTBO=0 then FX2=10 else wait 5
if TTBO=0 then gosub 8520
return

rem NEW LEADER - ANIME WREATH
if DEMO=0 and NBP=2 and SC(PLR)>=SC((PLR+1) mod 2) and WIN<>PLR then 8565 else return
if PLR=0 then YSC=184 : MSC=192 : goto 8580
YSC=192 : MSC=184
cls back,0,80,MSC to 96,MSC+7 : cls logic,0,80,MSC to 96,MSC+7
if SC(PLR)=SC((PLR+1) mod 2) then return
screen$(back,80,YSC)=BLK$(324) : screen$(logic,80,YSC)=BLK$(324)
if FX=1 and WIN<>-1 then music on : music freeze : volume 16 : envel 1,10000 : play 40,3 : play 60,1 : FX2=20
WIN=PLR
return

rem SCORE PANEL
gosub FADE_TO_BLACK : if MUS=0 then MUS2=1
gosub 11200
locate 0,23 : pen 15 : centre "(any key to return)"
gosub WAIT_RELEASE : X$=""
while X$="" : X$=inkey$
if joy>=16 then 8880
if movon(4)=0 then gosub HALL_OF_FAME_ANIME
gosub DEMO_RUN : if DEMO=1 then gosub FADE_TO_BLACK : goto INTER_LEVEL
wend
gosub WAIT_RELEASE : goto MENU_2

rem HELP PANEL
mode 0 : timer=0 : X$="" : clear key : fade 3 : wait 21 : cls : if MUS=0 then MUS2=1
locate 0,3 : pen 15 : centre "TAKE YOUR JOYSTICK AND TRY"
locate 0,23 : pen 15 : centre "(help to continue)"
X=160 : Y=90 : sprite 1,160,90,2 : gosub FADE_TO_LEVELCOL
gosub WAIT_RELEASE
sprite 1,160,90,2 : while J=0 : J=joy : X$=inkey$ : if X$=" " then 9340 else if scancode=98 then 9230
wend : if J>16 then J=16
if J=1 or J=5 then C=10 else if J=9 then C=10 else 9030
if J=1 or J=5 then 8980 else if J=9 then 8980 else YY=1
if YY=0 then dec Y : if Y=70 then YY=1
if J=9 or J=8 then inc X : C=10
if J=5 or J=4 then dec X : C=19
if YY=1 then inc Y : if Y=91 then YY=0 : goto 9220
gosub 9190 : J=joy : goto 8970
if J<>8 then 9060 else C=2
inc C : if C=6 then C=3
wait 2 : gosub 9190 : J=joy : if J=8 then 9040 else 9220
if J<>4 then 9090 else C=11
inc C : if C=15 then C=12
wait 2 : gosub 9190 : J=joy : if J=4 then 9070 else 9220
if J<>2 then 9110 else for C=6 to 7 : wait 2 : gosub 9190 : next C
while J=2 : J=joy : wend : if J=10 or J=6 then 9110 else for C=7 to 6 step-1 : wait 2 : gosub 9190 : next C : goto 9220
TEXTE=0 : if J<>10 then 9140 else C=7
inc C : if C=10 then C=8
wait 2 : gosub 9190 : if joy=10 then 9120 else 9220
if J<>6 then 9170 else C=16
inc C : if C=19 then C=17
wait 2 : gosub 9190 : if joy=6 then 9150 else 9220
for C=101 to 104 : wait 5 : gosub 9190 : next C
for C=104 to 101 step-2 : wait 5 : gosub 9190 : next C : if joy>=16 then 9170 else 9220
wait 1 : sprite 1,X,Y,C : if TEXTE=0 then TEXTE=1 : locate 0,15 : centre TXT$(J)
return
TEXTE=0 : X=160 : Y=90 : J=0 : locate 0,15 : print space$(100) : goto 8940
X$="" : fade 3 : wait 21 : cls : MUS2=1
sprite 1,160,172,127 : anim 1,"(127,8)(128,8)L" : anim on 1 : X=0 : Y=0
locate 0,23 : pen 15 : centre "(any key to return)"
gosub 11000
ZTIM=0 : gosub FADE_TO_LEVELCOL : pen 2 : gosub 9341 : pen 15 : gosub WAIT_RELEASE
TXTFX=0
while inkey$="" : if joy>=16 then gosub 9341 else if TXTFX=1 then 9262
Y=rnd(18) : YTEST=Y
if LINEXCLU(YTEST)=0 then Y=YTEST : goto 9250
YTEST=(YTEST+1) mod 19 : if YTEST<>Y then 9248 else TXTFX=1 : goto 9262
LINELENGHT=len(HLP$(Y)) : CENTERED=20-(LINELENGHT/2) : if LINELENGHT=1 then LINEXCLU(Y)=1 : goto 9262
if LINELENGHT mod 2=1 then dec CENTERED
X=rnd(LINELENGHT-1) : XTEST=X
if scrn(XTEST+CENTERED,Y)<>0 and SCXY(XTEST+CENTERED,Y)=0 then HLPT$=mid$(HLP$(Y),XTEST+1,1) : X=XTEST+CENTERED : gosub 9346 : goto 9262
XTEST=(XTEST+1) mod LINELENGHT : if XTEST<>X then 9253
LINEXCLU(Y)=1
wend
gosub WAIT_RELEASE : goto MENU_2
for I=0 to 18 : locate 0,I : centre HLP$(I) : next I
return
HERE$=chr$(scrn(X,Y))
locate X,Y : print HLPT$; : SCXY(X,Y)=1 : return
rem CREDIT PANEL
gosub FADE_TO_BLACK : mode 1
pen 3 : locate 0,2 : centre "SAM NASTY - V1.0" : pen 1
ink 2 : box 220,6 to 419,32 : box 110,92 to 530,138
locate 0,6 : centre "developped in STOS Basic (Mandarin software) in the early 90s,"
locate 0,7 : centre "reworked/compiled in 2019 :)"
locate 0,8 : centre " "
locate 0,9 : centre " "
locate 0,11 : centre "Level Editor, Extra levels, Infos, Forum :"
pen 3
locate 0,13 : centre "https://samnasty.mondes-electriques.fr"
locate 0,14 : centre "https://en.tipeee.com/sam-nasty"
locate 0,15 : centre "sam@mondes-electriques.fr"
pen 1
locate 0,18 : centre "Want to see more ?"
locate 0,19 : centre "Support Sam development on Tipeee !"
locate 0,20 : pen 3 : centre "Many thanks for your tip !" : pen 1
locate 0,22 : centre "Jerome - april 5, 2019"
palette $752,$740,$730,$765
gosub WAIT_RELEASE
gosub WAIT_KEY_OR_FIRE
if MUS=0 then MUS2=1
gosub WAIT_RELEASE : goto MENU_2
rem SPACE KEY : PAUSE
music on : music freeze : move freeze : PTIMER=timer : anim freeze : X$=""
UNPAUSE$=screen$(back,80,72 to 240,130) : screen$(logic,80,72)=PAUSE$ : if FX=1 then volume 16 : envel 1,5000 : play 75,4 : envel 1,3000 : play 65,6
gosub WAIT_RELEASE
gosub WAIT_KEY_OR_FIRE
gosub WAIT_RELEASE
if FX=1 then volume 16 : envel 1,5000 : play 65,4 : envel 1,3000 : play 75,6
screen$(logic,80,72)=UNPAUSE$ : X$="" : clear key : anim on : if NTS=1 then 9630 else for I=2 to NTS(NBPL) : if ST(NBPL,I)<9 then move on I
next I : for I=13 to 15 : if x sprite(I)+y sprite(I)<>0 then move on I
next I
music on : timer=PTIMER : FX2=0 : return
rem SUB SCORE BONUS PANEL - PREPARE
if LVL(PLR)=1 or LVL(PLR)>LVLMX then BONUSDONE=1 : return
pen 15 : locate 10,2 : print " WELL DONE PLAYER"+str$(PLR+1)+"!"
if NWLVL<>1 then BONUSDONE=1 : gosub FADE_TO_LEVELCOL : return
locate 10,10 : if LVLTIME>0 then print " TIME BONUS" else print "   NO TIME BONUS"
locate 10,12 : print " LIFE BONUS"
locate 10,14 : print "LEVEL BONUS"
locate 10,16 : print "TOTAL BONUS"
pen 9 : locate 0,19 : centre "TOTAL"+str$(SC(PLR)) : pen 15
if MPBL(PLR)>0 then for COEPOS=0 to MPBL(PLR)-1 : gosub 8526 : COEX=112+COEPOS16*8 : COEY=160 : gosub 8519 : next COEPOS
if MUS=1 and FX>=1 then music freeze : volume 16
screen$(back,16,149)=LVLPIC$ : zoom back,16,149,80,177 to logic,112,40,208,68
LV2=LVL(PLR) if LV2>6 then LV2=6
SND=0 : BONUSDONE=0 : TBO=0 : LVBO=0 : LBO=0 : LVB=0 : TTBO=0 : VIBO=MPBL(PLR)
return

rem SUB SCORE BONUS PANEL - INCREMENT
@SCORE_INC
if NWLVL<>1 or LVL(PLR)=1 or LVL(PLR)>LVLMX then return
if TTBO=0 then gosub FADE_TO_LEVELCOL : flash 2,"(777,7)(555,7)(000,5)"
rem ### TIME BONUS
dec LVLTIME : if LVLTIME<0 then SI_LIVES
TBO=TBO+PTSTIME : locate 22,10 : print using "######";TBO
TTBO=TTBO+PTSTIME : gosub SI_TOTAL : return
rem ### LIVE LEFT BONUS
@SI_LIVES
dec VIBO : if VIBO<0 then SI_LEVEL else LVB=LVB+PTSLIVES
locate 22,12 : print using "######";LVB
TTBO=TTBO+PTSLIVES : gosub SI_TOTAL : return
rem ### LEVEL BONUS
@SI_LEVEL
if LVBO<LV2*PTSLVL then LVBO=LVBO+PTSLVL else SI_DONE
locate 22,14 : print using "######";LVBO
TTBO=TTBO+PTSLVL : gosub SI_TOTAL : return
rem ### TOTAL BONUS
@SI_TOTAL
pen 2 : locate 22,16 : print using "######";TTBO : pen 15 : if FX>=1 then inc SND : if SND=97 then SND=96
if FX>=1 then volume 16 : envel 1,5000 : play SND,1
return
@SI_DONE
BONUSDONE=1 : SC(PLR)=SC(PLR)+TTBO : pen 9 : locate 0,19 : centre "TOTAL"+str$(SC(PLR))
VVLST=VV(PLR) : gosub 8510
if VVLST=VV(PLR) then 9865
COEPOS=MPBL(PLR)-1 : gosub 8526 : COEX=112+COEPOS16*8 : COEY=160 : gosub 8519 : goto 9862
wait 30 : screen$(back,16,149)=LVLPIC2$ : zoom back,16,149,80,177 to logic,112,40,208,68
wait 40 : music on : TTBO=0 : return
rem GAME MASTERED - WELL DONE
gosub FADE_TO_BLACK
pen 15 : locate 0,11 : centre "WELL DONE PLAYER"+str$(PLR+1)+" !"
gosub FADE_TO_LEVELCOL
MPBL(PLR)=0 : if MUS=1 then music 1 : transpose 19 : tempo 100
wait 200 : gosub HALL_OF_FAME_ADD : goto 2020

@HALL_OF_FAME_ADD
if SC(PLR)<val(SCO$(9)) or NWLVL<>1 or SAM$<>"SAM" then return
SCP=SC(PLR) : gosub FADE_TO_BLACK : if MUS=0 then MUS2=1
I=-1
inc I : if SCP>=val(SCO$(I)) then if I=9 then 9920 else for J=9 to I+1 step-1 : NAM$(J)=NAM$(J-1) : SCO$(J)=SCO$(J-1) : next J : goto 9920
goto 9900
NAM$(I)="___" : SCO$(I)=mid$(str$(SCP),2,7) : SCP=I+8
gosub 11200
pen 15 : locate 0,21 : centre "CONGRATULATIONS !" : locate 0,23 : centre "ENTER YOUR INITIALS (joystick)"
flash 13,"(557,5)(447,5)(227,5)(117,5)(227,5)(337,5)(447,5)" : X=65 : XCP=13 : goto 10020
if joy=8 then inc X : if X=176 then X=65 else if X=91 then X=174
if joy=4 then dec X : if X=173 then X=90 else if X=64 then X=175
if joy>=16 then if X=174 or X=175 then 10040 else inc XCP : if XCP=16 then 10090 else 10080
if joy=0 then 10030
wait 3 : locate XCP,SCP : print chr$(X)
if movon(4)=0 then gosub HALL_OF_FAME_ANIME
goto 9980
rem << or >> selected
locate XCP,SCP : print " "
if X=175 then 10070 else dec XCP : if XCP=12 then XCP=13
goto 10080
inc XCP : if XCP=16 then 10090
gosub WAIT_RELEASE : goto 10030
NAM$(SCP-8)=chr$(scrn(13,SCP))+chr$(scrn(14,SCP))+chr$(scrn(15,SCP))
if DEVEL=0 then open out #1,"SCORES.SAM" : for I=0 to 9 : print #1,NAM$(I);",";SCO$(I) : next I : close #1
return

rem CHEAT : START LEVEL
X$="" : clear key : gosub FADE_TO_BLACK : home : pen 15 : locate 0,3 : centre "THE SLEAZY PAGE" : NWLVLLST=NWLVL : COD=1
locate 0,10 : centre "BEGIN AT LEVEL"
locate 0,23 : centre "(Space to return)" : gosub FADE_TO_LEVELCOL : NWLVL=1 : gosub WAIT_RELEASE
if joy=8 or joy=24 then inc NWLVL : if NWLVL=LVLMX+1 then NWLVL=LVLMX
if joy=4 or joy=20 then dec NWLVL : if NWLVL=0 then NWLVL=1
locate 0,12 : centre " "+str$(NWLVL)+" " : wait 5
if inkey$<>" " then 10150
clear key : gosub WAIT_4SECS : LVL(0)=NWLVL : LVL(1)=NWLVL
if NWLVL<>NWLVLLST then O=LVL(PLR) : gosub BANK_NEXT
goto MENU_2

rem SCORES READ
open in #1,"SCORES.SAM"
for I=0 to 9 : input #1,NAM$(I),SCO$(I) : next I
close #1
return

rem SUB INTRO COLOR
palette COLINTRO(0),COLINTRO(1),COLINTRO(2),COLINTRO(3),COLINTRO(4),COLINTRO(5),COLINTRO(6),COLINTRO(7),COLINTRO(8),COLINTRO(9),COLINTRO(10),COLINTRO(11),COLINTRO(12),COLINTRO(13),COLINTRO(14),COLINTRO(15)
return

rem DEMO RUN TEST
@DEMO_RUN
if NWLVL=1 and timer>750 then DEMO=1 : NBP=1 : PLR=0 : DEMP=0
if TRACE=1 then locate 1,1 : print timer
return

rem LEAVING DEMO
@DEMO_END
gosub WAIT_RELEASE
pop : gosub LEVEL_OUT
DEMO=0 : MDEMTIM=0 : DEMP=0 : DEMTIM=0 : goto MENU
rem INIT HELP PANEL 2 TEXT FX
for X=0 to 39 : for Y=0 to 18 : SCXY(X,Y)=0 : next Y : next X
for Y=0 to 18 : LINEXCLU(Y)=0 : next Y
return

rem SUB RETURNS LEVEL BANK ID OF CURRENT PLAYER
@BANK_NEXT
gosub BANK_EXIST
rem NIVEAU DEJA CHARGE DANS BANK
if BANK<>-1 then NBPL=BANK : return
rem DEFINI UNE BANQUE LIBRE ET PART CHARGER LE FICHIER DU NIVEAU
gosub BANK_AVAILABLE : NBPL=BANK : gosub LEVEL_LOAD : return
rem DRAW HALL OF FAME
screen$(back,0,0)=LOD$ : ink 0 : bar 181,33 to 195,40 : bar 190,20 to 200,30 : screen copy back,0,0,160,38 to back,192,0
screen copy back to logic
for I=0 to 9
pen I+1
locate 13,I+8 : print NAM$(I);space$(11-len(SCO$(I)));SCO$(I)
next I
gosub HALL_OF_FAME_ANIME
anim 2,"(53,5)(54,5)(55,5)(54,5)L"
anim 3,"(12,5)(13,5)(14,5)L"
anim 1,"(3,5)(4,5)(5,5)L"
anim 4,"(53,5)(54,5)(55,5)(54,5)L"
anim on
gosub FADE_TO_FAMECOL
flash 13,"(557,10)(447,10)(227,10)(117,10)(227,10)(337,10)(447,10)" : flash 1,"(770,10)(550,1)(330,1)(000,10)(330,1)(550,1)"
return

rem DRAW HALL OF FAME ANIMES
@HALL_OF_FAME_ANIME
sprite 1,96,60 : sprite 2,222,60
sprite 4,96,144 : sprite 3,222,144
move x 1,"(2,3,42)" : move y 2,"(2,2,42)"
move x 3,"(2,-3,42)" : move y 4,"(2,-2,42)"
move on : return

rem ask wether the level player exists in one bank
@BANK_EXIST
BANK=-1
for I=0 to BANKCOUNT
if LVLBANK(I)=LVL(PLR) then BANK=I : I=BANKCOUNT
next I
return
rem search an available bank
@BANK_AVAILABLE
BANK=-1
for I=0 to BANKCOUNT
if LVLBANK(I)=-1 then BANK=I : I=BANKCOUNT
next I
if BANK<>-1 then return
rem TODO OPTIMISATION
BANK=1 : return
rem SUB display START AT LEVEL CODE
if NWLVL<>1 or LVL(PLR)<>HINTATLVL then return
locate 0,10 : pen 14 : centre COD$ : locate 0,12 : centre "(DURING THE MENU SCREEN...)" : pen 15
gosub FADE_TO_LEVELCOL : colour 14,$755 : HINTATLVL=-1
wait 200 : gosub FADE_TO_BLACK : return
rem ask wether this level exists in one bank
BANK=-1
for I=0 to BANKCOUNT
if LVLBANK(I)=THISLVL then BANK=I : I=BANKCOUNT
next I
return
rem in-game timer
if timer-TMRDSPL<50 then return
LVLTIME=LVLMAXTIME-(timer/50) : if LVLTIME<0 then pen 9 else pen 15
locate 36,23 : print using "###";LVLTIME; : TMRDSPL=timer : pen 15
return

rem floppy access animation
@LL_ANIME
if movon(2)=1 then return
sprite 1,-10,198,125 : anim 1,"(3,4)(4,4)(5,4)L"
sprite 2,-60,198,125 : anim 2,SPR$(0,2)
sprite 3,-100,198,125 : anim 3,SPR$(1,2) : anim on
move x 1,"(2,2,170)(2,-340,1)L"
move x 2,"(3,2,200)(3,-400,1)L"
move x 3,"(1,1,440)(2,-440,1)L" : move on
return

rem help page 2 text
@HELP_TEXTDEF
HLP$(0)=" " : HLP$(1)="KEYS ALLOW YOU TO OPEN SOME OF THE"
HLP$(2)="DOORS. HANDLES ALLOW TO OPEN DOORS,"
HLP$(3)="MOVE THINGS,DISCOVER SECRET"
HLP$(4)="PASSAGES, OR SOMETIMES TO BE KILLED."
HLP$(5)=" "
HLP$(6)="TIME LEFT BONUS"+str$(PTSTIME)+" PTS/SEC"
HLP$(7)="LEVEL BONUS"+str$(PTSLVL)+" PTS"
HLP$(8)="LIVES LEFT BONUS"+str$(PTSLIVES)+" PTS"
HLP$(9)=" "
HLP$(10)="EACH COIN"+str$(PTSCOIN)+" PTS"
HLP$(11)="EACH WREATH"+str$(PTSWREATH)+" PTS"
HLP$(12)="HIT A GUARD"+str$(PTSGUARD)+" PTS"
HLP$(13)=" "
HLP$(14)="EXTRA LIFE EACH"+str$(PTSEXTRALIFE)+" PTS."
HLP$(15)=" "
HLP$(16)="THERE IS OTHER OBJECTS,LIKE BOTTLES"
HLP$(17)="OF WINE,OR EXTRA LIFES THAT YOU'LL"
HLP$(18)="SOON MEET.OPEN YOUR EYES..."
HLP$(19)=" "
return
