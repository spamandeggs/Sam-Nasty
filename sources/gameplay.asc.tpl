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

rem MISC's
@SET_FOUY
FOUY=instr(AC3$,"/") : AC3$=mid$(AC3$,FOUY+1,len(AC3$)-FOUY)
return

@GAME_MOBILES_UPDATE
REP=val(AC3$) : gosub SET_FOUY
TAY=val(AC3$) : gosub SET_FOUY
XDEST=val(AC3$) : gosub SET_FOUY
YDEST=val(AC3$) : gosub SET_FOUY
XPIC=val(AC3$) : gosub SET_FOUY
YPIC=val(AC3$) : gosub SET_FOUY
XPIC2=val(AC3$) : gosub SET_FOUY
YPIC2=val(AC3$) : gosub SET_FOUY
if IK=8 then set zone I,X1Z(NBPL,I),Y1Z(NBPL,I) to X2Z(NBPL,I),Y2Z(NBPL,I) : goto GMU0
reset zone I : XPIC=XPIC2 : YPIC=YPIC2
@GMU0
if TAY=1 or TAY=3 then SBNK=71 else SBNK=1
if TAY=3 then TAY=2
get sprite XPIC,YPIC,SBNK : wait vbl
if abs(REP)=1 then sprite 9,XDEST,YDEST,SBNK : wait vbl : put sprite 9 : wait vbl : goto GMU3
if REP<0 then REP=abs(REP) : goto GMU1
if TAY=1 and REP>4 then REP=4 else if TAY=2 then REP=REP/2 : if REP>4 then REP=4
for I=0 to REP-1 : sprite 9+I,XDEST+I*8*TAY,YDEST,SBNK : next I : wait vbl
goto GMU2
@GMU1
if TAY=1 and REP>4 then REP=4 else if TAY=2 then REP=REP/2 : if REP>4 then REP=4
for I=0 to REP-1 : sprite 9+I,XDEST,YDEST+I*8*TAY,SBNK : next I : wait vbl
@GMU2
for I=0 to REP-1 : put sprite 9+I : next I : wait vbl
@GMU3
for I=0 to REP-1 : sprite off 9+I : next I : wait vbl
return

rem JOYSTICK READ / DEMO CONT/END
rem ### PLAYER INPUTS
@GAME_GET_JOY
if DEMO=0 then J=joy : goto GAME_GJ0
rem ### DEMO INPUTS
if timer>800 or joy>=16 or inkey$<>"" then goto GAME_DEMO_END
dec DEMTIM : if DEMTIM>0 then GAME_GJ0
J=JDEM(DEMP) : DEMTIM=TDEM(DEMP) : inc DEMP
@GAME_GJ0
if COMPILED then wait COMPDELAY
if BOUT>0 then gosub SAM_DRUNK
if J<16 then FEU2=0 : FEU=0 : return
J=J-16 : if FEU2=0 then FEU=1
return

rem JOYSTICK UP
@SAM_JUMP
if Y<16 then SAM_ROUTER
Z=zone(1)
if Z=0 then SAM_JP1 : rem this test was only in game code
if ZNE(NBPL,Z)=4 then SAM_JP0 else if ZNE(NBPL,Z)<30 then SAM_JP1 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then SAM_JP1
@SAM_JP0
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then SAM_LADDER_TEST
@SAM_JP1
CR=0 : if J<>5 then if point(X+E-1,Y-16)>V then SAM_ROUTER
if J<>9 then if point(X-E+1,Y-16)>V then SAM_ROUTER
if C=11 then C=19 else C=10
gosub GAME_GET_JOY : if J=9 and PLAT=0 then if point(X+1,Y+1)<=V then X=X+4 : if X>312 then X=312
if J=5 and PLAT=0 then if point(X-1,Y+1)<=V then X=X-4 : if X<8 then X=8
@SAM_JP2
SAUT=0 : while SAUT<18 : if point(X+E-1,Y-12)>V or point(X-E+1,Y-12)>V then SAM_FALL
inc SAUT
Z=zone(1) : gosub GAME_GET_JOY
if Z=0 then SAM_JP4 : rem this test was only in game code
if ZNE(NBPL,Z)=4 then SAM_JP3 else if ZNE(NBPL,Z)<30 then SAM_JP4 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then SAM_JP4
@SAM_JP3
if J<>1 and J<>9 then if J<>5 then SAM_JP5
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then SAM_LADDER_TEST
@SAM_JP4
if J=5 or J=9 then SAM_JP5
if J=1 then SAM_JP5 else SAM_FALL
@SAM_JP5
if SAUT<10 then DXY=2 : Y=Y-2
goto SAM_JP6
if SAUT<12 then dec Y
DXY=1
rem TRACELOG$=str$(SAUT) : gosub TRACESUB
rem TRACELOG$="3520" : gosub TRACESUB
@SAM_JP6
if J=9 and PLAC=0 then gosub SAM_JUMP_LIMIT_R
if J=5 and PLAC=0 then gosub SAM_JUMP_LIMIT_L
if Y<16 then Y=16
gosub GAME_MAIN_SUB
if MUS=0 and FX=1 then volume 16 : envel 1,200 : play 96-Y/2,1
wend : goto SAM_FALL

@SAM_JUMP2
CR=0
while SAUT<4
DXY=2
inc SAUT
rem TRACELOG$="3900" : gosub TRACESUB
gosub GAME_GET_JOY : Z=zone(1)
if Z=0 then SAM_JP21 : rem this test was only in game code
if ZNE(NBPL,Z)=4 then SAM_JP20 else if ZNE(NBPL,Z)<30 then SAM_JP21 else if ZNE2(NBPL,ZNE(NBPL,Z)-30)<>4 then SAM_JP21
@SAM_JP20
if J<>1 and J<>9 then if J<>5 then SAM_JP21
if point(X+E-1,Y-16)<=V and point(X-E+1,Y-16)<=V then SAM_LADDER_TEST
@SAM_JP21
if J=8 or J=9 then gosub SAM_JUMP_LIMIT_R : goto SAM_JP22
if J=5 or J=4 then gosub SAM_JUMP_LIMIT_L : goto SAM_JP22
if J<>9 and J<>8 then if C=10 then gosub SAM_JUMP_LIMIT_R
if J<>5 and J<>4 then if C=19 then gosub SAM_JUMP_LIMIT_L
@SAM_JP22
Y=Y-2
if Y<16 then Y=16
gosub GAME_MAIN_SUB
wend
@SAM_FALL
SAUT=0 : if Y<8 then Y=15
if PLAT>0 then SAM_ROUTER
DXY=1
if C<=10 then C=10 else C=19
while point(X+E-1,Y+1)<=V : if point(X-E+1,Y+1)>V then SAM_LAND
DXY=1
gosub GAME_GET_JOY : Z=zone(1)
if Z=0 or btst(0,J)<>-1 then SAM_F1
if ZNE(NBPL,Z)=4 then SAM_LADDER_TEST
if ZNE(NBPL,Z)>=30 and ZNE2(NBPL,ZNE(NBPL,Z)-30)=4 then SAM_LADDER_TEST
@SAM_F1
if J=8 or J=9 then gosub SAM_JUMP_LIMIT_R
if J=4 or J=5 then gosub SAM_JUMP_LIMIT_L
Y=Y+2
if MUS=0 and FX=1 then volume 16 : envel 1,200 : play 96-Y/2,1
if Y>184 then gosub SAM_DEATH_CONTACT
gosub GAME_MAIN_SUB : if PLAT<>0 then SAM_JUMP_END
wend
@SAM_LAND
if point(X,Y+1)<=V then if point(X+E-1,Y+1)>V then X=X+3 else X=X-3
while point(X,Y)>V : dec Y : wend
while point(X,Y+1)<=V : inc Y : wend
@SAM_JUMP_END
SAUT=0 : if C=19 or C=11 then C=11 else C=2
goto SAM_ROUTER


rem JOYSTICK DOWN
@SAM_CROUCH_TRANSITION
CR=1 : if C=11 then for C=15 to 16 : gosub GAME_MAIN_SUB : next C : C=16 : goto SAM_CROUCH
if C=2 then for C=6 to 7 : gosub GAME_MAIN_SUB : next C : C=7
@SAM_CROUCH
CR=1 : gosub GAME_GET_JOY : while J=2 : gosub GAME_GET_JOY : gosub GAME_MAIN_SUB
if PLAT<=0 then if point(X+E-1,Y+1)<=V and point(X-E+1,Y+1)<=V then Y=Y+6 : goto SAM_FALL
wend
if PLAT<=0 then SAM_CR0
if J=0 and Y>7 then if point(X+E-1,Y-9)<=V and point(X-E+1,Y-9)<=V then SAM_GETUP
if J<=6 then C=16 else C=7
gosub GAME_MAIN_SUB : goto SAM_CROUCH
@SAM_CR0
gosub GAME_GET_JOY : if Y<8 then SAM_CR1
if J=5 and C=16 then if point(X-1,Y+1)<=V then C=19 : goto SAM_CR2
if J=9 and C=7 then if point(X+1,Y+1)<=V then C=10 : goto SAM_CR2
@SAM_CR1
if J=6 or J=4 then SAM_CRAWL_L else if J=10 or J=8 then SAM_CRAWL_R
if Y>7 and J=0 then if point(X+E-1,Y-9)<=V and point(X-E+1,Y-9)<=V then SAM_GETUP
gosub GAME_MAIN_SUB : gosub GAME_GET_JOY : goto SAM_CR0
@SAM_CR2
Y=Y+6
if C=19 then X=X-2 else X=X+2
CR=0 : goto SAM_JUMP2

rem GET UP RIGHT
@SAM_GETUP
if C=16 then SAM_GETUP_L
for C=7 to 6 step-1 : sprite 1,X,Y,C
if ZNE(NBPL,Z)<>5 and ZNE(NBPL,Z)<>6 then gosub GAME_MAIN_SUB
next C : C=2 : sprite 1,X,Y,C : goto SAM_ROUTER

rem GET UP LEFT
@SAM_GETUP_L
for C=16 to 15 step-1 : sprite 1,X,Y,C
if ZNE(NBPL,Z)<>5 and ZNE(NBPL,Z)<>6 then gosub GAME_MAIN_SUB
next C : C=11 : sprite 1,X,Y,C : goto SAM_ROUTER

rem X LEFT LIMIT
@SAM_JUMP_LIMIT_L
if X<8 then X=8
C=19 : if point(X-E,Y-4)>V and point(X-E,Y-12)<=V then pop : goto SAM_CLIMB_L
if point(X-E-DXY+1,Y)<=V then if point(X-E-DXY+1,Y-4)<=V and point(X-E-DXY+1,Y-8)<=V then X=X-DXY
return

rem X RIGHT LIMIT
@SAM_JUMP_LIMIT_R
if X>312 then X=312
C=10 : if point(X+E,Y-4)>V and point(X+E,Y-12)<V+1 then pop : goto SAM_CLIMB_R
if point(X+E+DXY-1,Y)<=V then if point(X+E+DXY-1,Y-4)<=V and point(X+E+DXY-1,Y-8)<=V then X=X+DXY
return

rem DRUNK, SHUFFLE INPUTS
@SAM_DRUNK
dec BOUT : if J>=16 then J=J-16
if J=2 then J=9 else if J=10 then J=1 else if J=8 then J=5 else if J=9 then J=4 else if J=1 then J=6 else if J=5 then J=2 else if J=4 then J=10 else if J=6 then J=8
if BOUT=0 then transpose PLR : tempo 100
return

rem LASER ON/OFF
@GAME_LASER_UPDATE
if X2Z(NBPL,I)-X1Z(NBPL,I)>=Y2Z(NBPL,I)-Y1Z(NBPL,I) then LSRUPD0
ink IK : draw X1Z(NBPL,I)+4,Y1Z(NBPL,I)+3 to X1Z(NBPL,I)+4,Y2Z(NBPL,I)-4 : goto LSRUPD1
@LSRUPD0
ink IK : draw X1Z(NBPL,I)+3,Y1Z(NBPL,I)+4 to X2Z(NBPL,I)-4,Y1Z(NBPL,I)+4
@LSRUPD1
if IK=1 then reset zone I else set zone I,X1Z(NBPL,I),Y1Z(NBPL,I) to X2Z(NBPL,I),Y2Z(NBPL,I)
if FX=0 or INIT=1 then return else music on : music freeze : volume 16
if IK=1 then envel 1,750 : play 95,1 : FX2=15 : return
envel 4,750 : play 96,1 : FX2=15 : return

rem SPEED WALK LEFT
@SPEEDWALK_LEFT
if point(X-E,Y)>V then GAME_COLLISION_SPRITES
if CR=0 then if point(X-E,Y-9)>V then GAME_COLLISION_SPRITES
dec X
if point(X,Y+1)<=V then X=(X/8)*8+4
goto GAME_COLLISION_SPRITES

rem SPEED WALK RIGHT
@SPEEDWALK_RIGHT
if point(X+E,Y)>V then GAME_COLLISION_SPRITES
if CR=0 then if point(X+E,Y-9)>V then GAME_COLLISION_SPRITES
inc X
if point(X,Y+1)<=V then X=(X/8)*8+3
goto GAME_COLLISION_SPRITES

rem ANIME DEAD : SPLITTED BY A SAW
@SAM_DEATH_SAW
for I=13 to 15 : sprite off I : next I
anim off 1 : while point(X,Y+1)<=V : inc Y : sprite 1,X,Y : if Y=183 then SAM_DS0
wend : wait 15
@SAM_DS0
D=19 : if C<=10 then D=2 else if C>=56 and C<=62 then D=2 else if C=90 then D=2
sprite 1,X,Y,D : wait 3 : if D=2 then sprite 1,X,Y,21 else sprite 1,X,Y,20
wait 15 : anim 1,"(48,30)(49,10)(50,10)(51,10)(52,10)" : anim on 1
wait 70 : anim 1,"(51,4)(52,4)l" : anim on 1
goto SAM_DEATH_COMMON

rem SAM ANIMATIONS
@SAM_LEFT_SPRITES
data 12,12,12,13,13,13,14,14,14,0

@SAM_RIGHT_SPRITES
data 3,3,3,4,4,4,5,5,5,0

@SAM_CRAWL_L_SPRITES
data 17,17,17,18,18,18,0

@SAM_CRAWL_R_SPRITES
data 8,8,8,9,9,9,0

@SAM_LADDER_SPRITES
data 54,55,54,53,0
