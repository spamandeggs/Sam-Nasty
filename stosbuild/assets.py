'''
stosbuild
copyright (c) 2020, jerome mahieux
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

FLOPPIES = {
	'samnasty' : {
		'ASSETS' : [
			"SAM0.BLK",		# title as a PI1 Degas Elite file, compressed
			"SAM1.BLK",		# bricks and art
			"SAM2.BLK",		# menu screen
			"MUSIC.MBK",	# music STOS library
			"SPRITES.MBK",	# sprites STOS library
			"NIVO.SAM",
			"SAM1.SAM",		# 1st game level
			"SAM2.SAM",		# etc...
			"SAM3.SAM",
			"SAM4.SAM",
			"SAM5.SAM",
			"SAM6.SAM",
			"SAM7.SAM",
			"SAM8.SAM",
			"SAM9.SAM",
			"SCORES.SAM",	# hall of fame
			"ASSETS",		# cc BY-SA licence notice
			],
		'SOURCES' : [
			"SAMNAS01.ASC",	# game
			"SAMNLE01.ASC",	# level editor
			"COPYING",		# gplv3 licence
			],
		# 'TEMPLATES' : { wip
			# "SAMNAS01.ASC" : [
				# "licence.asc.tpl",
				# "game.asc.tpl",
				# "common.asc.tpl",
				# ],
			# },
		},
	}