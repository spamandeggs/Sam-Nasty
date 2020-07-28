Sam Nasty
=========
[updated 2020/07/28]

a board game for Atari ST.
GNU GPL v3.0

sources are in dev/alpha. SAMNAS01.ASC is the game, and SAMNLE01.ASC the level editor.
assets (sprites, MUS, PI1's) will be pushed soon.

- repo : https://github.com/spamandeggs/Sam-Nasty  
- board : https://jmx.alwaysdata.net/samnasty

Prerequisites
-------------

- Steem/Hatari emulators and/or an Atari 1040 (for now... working on it for 520's...)
- If run from a real Atari, you need a gamepad (aka a *joystick*)
- the STOS language for Atari ST. (todo define exact release)
- Python 3.8 (not mandatory but highly recommended to generate the floppies)
- the STOS compiler (not mandatory, the game can be run directly from the STOS editor)

Generate the floppies contents
------------------------------

### using Python 3.8

Browse to the project root then type :
	
	python stosbuild

This will generate a `builds` folder, then one or several subfolders : each subfolder correspond to an Atari ST floppy. 
the `assets.py` file in the `stosbuild` folder define how it behaves.  

*For now*, If you regenerate, each existing file of each `builds` subfolder **is updated**, 
and filenames removed from `assets.py` **are kept**. Other existing files are kept too.

> ... so watch out if you edit the code directly in the Atari STOS editor.

### by hand

Have a look to the `assets.py` file in the `stosbuild` folder : it defines the required  
files needed for each floppy.

Copy the defined file in a dedicated folder in the `builds` folder.

Accessing floppy folders from GEM
---------------------------------

(GEM is the Atari environment.) 

### Using Steem or an ST emulator

In Steem, The easiest way is to mount a new Atari virtual hardrive with the `builds` folder as a root.  
From there you will access each generated floppy.

### Using your Atari

(todo)

Run STOS
--------

- Switch on your Atari/emulator then run STOS
- From the STOS editor, browse to the subfolder.  
  In the following snippet I used `D` as a virtual hardrive, with the `builds` folder as a root,  
  and `SAMNASTY` in the subfolder/floppy name :

		new
		drive$="D"
		dir$="\SAMNASTY"

- To run the game :

		load "SAMNAS01.ASC"
		load "SPRITES.MBK"
		load "MUSIC.MBK"
		run

- Or to run the level editor :

		load "SAMNLE01.ASC"
		load "SPRITES.MBK"
		run

Compiling
---------

(todo : more info to come.)

Before to compile the .BAS into .PRG or .TOS, you need to change some values in the code.  
These are located at the beginning of the file.  

	COMPILED=1
	COMPDELAY=1
	
`COMPILED` is a flag that adds a delay when run as a PRG/TOS, since its faster than from the STOS editor.  
1 add a delay, 0 no delay. `COMPDELAY` is the delay to add when flag is 1. 

	DEVEL=0
	
This forbid the escape key (which is like a CTRL-C in a STOS code) to work during the game.
	
	TRACE=0
	
Hacking/Distributing
--------------------

Sam Nasty is licenced under GPL v3 or later, so be my guest and fork.  
(todo)


