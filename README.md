Sam Nasty
=========
[updated 2020/07/30]

a board game for Atari ST with a level editor written in STOS Basic. GNU GPL v3.0  
More infos on this board : https://jmx.alwaysdata.net/samnasty

The content of this repo allows you to prepare Atari floppies from sources and assets,  
with the complete game and/or the level editor, as available in the board.  
A python module cares about generating the floppy(ies?) content and generate basic code from sources templates.

- board : https://jmx.alwaysdata.net/samnasty
- sources and builder : https://github.com/spamandeggs/Sam-Nasty
- donations : https://en.tipeee.com/sam-nasty

Sources are in the `sources` folder : `SAMNAS01.ASC` is the complete game, and `SAMNLE01.ASC`  
the complete level editor. These two source files will be replaced by the sources templates files in a near  
future, *if it confirms that this is more easy to work with* :).  
Sprites, musics, art, and game levels are in the assets folder.  

I released the project under the GNU GPL v3 and later licence, because I don't have much time  
to continue to maintain it, the project could be interesting for retro-coding aficionados, and would like,  
who knows, to co-maintain it with some other old buddies.  

The board is the place for ideas, directions, arts, forked projects etc... it also propose the game
as an .st file, containing the TOS compiled version, against a small donation. Maybe real floppies if you ask for it.

From this repo you can build (and modify) the very same game with a little patience.

Roadmap / todo
--------------

- Continue to work on the code generator and the code templates idea (see stosbuild/README)
- Code cleaning, readability, organisation, improvement,
- Make it run on Atari 520 and not only 1040,
- Merge game and editor codes in one,
- Documentation, mainly about the level editor.

Prerequisites
-------------

- Steem or Hatari emulators and/or an Atari 1040 (for now... working on it for 520's...)
- If run from a real Atari, you need a gamepad (aka a *joystick* omg)
- the STOS language for Atari ST. (todo define exact release)
- Python 3.8 (not mandatory but highly recommended to generate the floppies)
- the STOS compiler (not mandatory, the game can be run directly from the STOS editor)

Personnaly I use Steem, I make the assumption that this will work in Hatari (I think I made it work on a rapsberry  
distro that use Hatari, but Im not sure..)

Generate the floppies contents
------------------------------

### using Python 3.8

You don't need to learn the Python language to use the generator. Simply download it on https://www.python.org/,  
install it, browse to the project root then type :
	
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
> If using git, you need to set `core.autocrlf` to false in your project configuration :
>
>		git config core.autocrlf false
>
> https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

Compiling
---------

Before to compile, you need to change/verify some values in the code. These are located at the beginning  
of the .ASC file :  

	COMPILED=1
	COMPDELAY=1
	
`COMPILED` is a flag that adds a delay when run as a PRG/TOS runtime, since its faster than the ASC version run  
from the STOS editor. 1 adds a delay, 0 no delay. `COMPDELAY` is the delay to add when flag is 1.  

	DEVEL=0
	
`DEVEL` forbid the escape key (which is like a CTRL-C in a STOS code) to work during the game.
	
	TRACE=0

`TRACE` with 1 is susceptible to print debug info during the execution.  

You need to build the .BAS version before to compile it. It's the ASC file with the MBK files merged together  
in a binary file. To do this type something like :

	load "SAMNAS01.ASC"
	load "SPRITES.MBK"
	load "MUSIC.MBK"
	save "SAMNAS01.BAS"

.BAS are only readable by the STOS Editor, it's not a text file anymore.  
Then you can use the STOS compilator program to generate either a .PRG or .TOS runtime from the .BAS file.  

(todo : more info to come.)
 
Distributing, licences, forks...
--------------------------------

Sam Nasty is licenced under GPL v3 or later, so be my guest and contribute or fork !  

There's actually 3 parts in this project. Each comes with its own GNU GPLv3 licence (see the `COPYING` file at root level).  
So if you rework a part of it and distribute this part, you don't need to share the whole project but only the specific part.

- **stobuild** is the BASIC code generator. It's everything contained in the `stosbuild` tree.  
  *copy it apart if you plan to do something to build your own retro basic project.*  
  * I believe you can use it for an Atari project with the licence you want,* ***provided you use your own assets***  
  ***and sources files, and not the ones provided here***, *since the generator does not add any code in the templates and only assemble them.*
- **Sam Nasty Template** files - which are in the `assets` folder *with a .tpl extension*  
  existing files with a *.asc only extension* in the `assets` folder are not concerned.  
  *it has no direct use alone, these files are used by stosbuild*  
- **Sam Nasty** files. These are the game and/or editor themselves, generated by stosbuild in a subfolder of the `build` directory.  
  *so once generated, from *stosbuild* and the *Sam Nasty Template*, you can redistribute only the whole `build` subfolder apart  
  from the other files and folders.*

And finally **the assets** (music, sprites, game, levels, ..) are licenced under the Creative Common CC-BY-SA 4.0, which is  
one-way compatible with GPL v3 : https://creativecommons.org/licenses/by-sa/4.0/  
The licence notice in the `assets` folder and is named `ASSETS`  
Some or all of these assets are susceptible to be used in a Sam Nasty build(s).  
the whole `assets` folder content, and only it, is concerned by the CC-BY-SA 4.0 licence.  

> ... this is my comprehension, *and my first in depth research/serious exercice about licencing...* of how this should work,
> any advice/feedback highly appreciated ...

https://www.gnu.org/licenses/gpl-faq.en.html
https://softwarefreedom.org/resources/2012/ManagingCopyrightInformation.html
https://opensource.stackexchange.com/questions/9780/license-of-code-generated-by-a-code-generator



