Sam Nasty
=========
[updated 2020/07/28]

a board game for Atari ST with a level editor written in STOS Basic.
More infos on this board : https://jmx.alwaysdata.net/samnasty
GNU GPL v3.0

The content of this repo allows you to prepare Atari floppies from sources and assets,  
with the complete game and/or the level editor, as available in the board.  
A python module cares about generating the floppy(ies?) content and generate basic code  
from sources templates.

- board : https://jmx.alwaysdata.net/samnasty
- sources and builder : https://github.com/spamandeggs/Sam-Nasty
- donations : https://en.tipeee.com/sam-nasty

sources are in the `sources` folder : SAMNAS01.ASC is the complete game, and SAMNLE01.ASC the complete level editor,    
sprites, musics, art, game levels are in the assets folder.  
The two source files will be replaced by the sources templates files in a near future,  
*if it confirms that this is more easy to work with* :).

I released the project under the GNU GPL v3 and later licence, because I don't have much time  
to continue to maintain it, could be interesting for retro-coding aficionados, and would like,  
who knows, to co-maintain it with some other old buddies.  

The board is the place for ideas, directions, arts, forked projects etc... it also propose the game
as an .st file, containing the TOS compiled version, against a small donation. Maybe real floppies  
if you ask for it. But in this repo you can obtain the very same result with a little patience.

Roadmap
-------

- Continue to work on the code generator and the code templates idea (see stosbuild/README)
- Code cleaning, readability, organisation, improvement,
- Make it run on Atari 520 and not only 1040,
- Merge game and editor codes in one,

Prerequisites
-------------

- Steem/Hatari emulators and/or an Atari 1040 (for now... working on it for 520's...)
- If run from a real Atari, you need a gamepad (aka a *joystick* omg)
- the STOS language for Atari ST. (todo define exact release)
- Python 3.8 (not mandatory but highly recommended to generate the floppies)
- the STOS compiler (not mandatory, the game can be run directly from the STOS editor)

Generate the floppies contents
------------------------------

### using Python 3.8

You don't need to learn the Python language to use the generator. Simply download it on https://www.python.org/ and read below.  
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

This is a discouraged method since the builder may use sources templates files, which will be hard to merge by hand.

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

> If you modify the .ASC source files, or fork the project, you need to save them with windows CRLF end of lines,  
> else the STOS editor won't be able to read them.
> If using git, you need to set `core.autocrlf` to false in your project configuration  :
>	git config core.autocrlf false
> https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

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

There's actually 3 projects, each with its own GNU GPLv3 licence :
- stobuild is the BASIC code generator. everything in the `stosbuild` tree.
- 

Sam Nasty is licenced under GPL v3 or later, so be my guest and fork!  
https://www.gnu.org/licenses/gpl-faq.en.html


