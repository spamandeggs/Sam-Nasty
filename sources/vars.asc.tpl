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

rem COMMON VARIABLES
dim BLK$(600),IC$(150),ICSIZE(150,1)
BGD=365 : MANETS=357 : FMANETS=361 : OPTN=110 : PTIT=11
MVG$=" ( 3,-2," : MVD$=" ( 3, 2," : MVN$=" (10, 0,"

rem MOBILE ZONE DIMENSIONS
dim X1Z(BANKCOUNT,110),X2Z(BANKCOUNT,110)
dim Y1Z(BANKCOUNT,110),Y2Z(BANKCOUNT,110)

rem zone total, types
dim NTZ(BANKCOUNT)
dim ZNE(BANKCOUNT,110),ZNE2(BANKCOUNT,80)

rem NPC sprites total, sprite to draw, start location,type
dim NTS(BANKCOUNT)
dim SP(BANKCOUNT,8),XM(BANKCOUNT,8),YM(BANKCOUNT,8)
dim ST(BANKCOUNT,9),FLP(BANKCOUNT,8)

rem demo movements
dim JDEM(50),TDEM(50)

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
rem "(115,12)(116,12)L" knocked out
rem elevator
SPR$(4,0)="(70,0)"