# introduction
dotfiles is an important part of a unix machine as they define how your programs
work. most config files are hidden and a hidden file is created by adding a dot
at the beginning and hence the name "dotfiles". however, I don't really like to
hide my config files because I'm too lazy to add a dot at the beginning and imo
it gets pretty messy once you have a lot of them. so I generally avoid hidden files.
generally as in config files are in `$HOME/etc` and not anywhere else. however some
files like xinitrc, shellrc and profile are symlinked to `$HOME/.xinitrc`, etc.

# structure of $HOME
as you might have noticed, the repo is structured according to the unix file
hierarchy system with some deviations in some places. I like to store binaries
which aren't needed by other users and which I use on a daily basis on my home
dir. one way would've been to shove everything `$HOME/.local`. while that works,
it's not really elegant (imo). so I started to structure my home dir according
to the unix file hierarchy system.

there was another benefit to the structure. my home dir wasn't a mess anymore
as I knew where to put "stuff". the general idea of the structure is as follows:
- `$HOME/bin` contains one file scripts which are mostly used to automate boring
  tasks
- `$HOME/etc` contains the config files. moreover, `$XDG_CACHE_HOME` is set to
  use this dir
- `$HOME/opt` contains tex, rustup, cargo, etc. this dir contains programs which
  really can't be put in `$HOME/usr` or `$HOME/var`.
- `$HOME/tmp` contains test scripts, other junk and fifos. in the future, I
  might make it like `/tmp` wherein the contents in `$HOME/tmp` gets deleted
  every time I boot up.
- `$HOME/usr/src` contains my personal projects and other software I have
  modified quite a lot
- `$HOME/usr/man` contains the man pages
- `$HOME/usr/local` contains scripts which launch programs in `$HOME/usr/src`.
  moreover, binaries are stored in `$HOME/usr/local/bin`
- `$HOME/usr/repos` contains cloned repos which are needed from time to time.
  the files aren't modified except for `config.mk` or `Makefile`
- `$HOME/var` contains all my personal junk. it has pictures, videos, docs
  (projects and whatnot). this folder contains certain special folders too.
  `$HOME/var/logs` contains logs and `$HOME/var/cache` is set to
  `$XDG_CACHE_HOME`

# shell
my interactive shell of choice, as of now, is `mksh`. previously I used `bash`
but I recently switched to mksh because it was a nicer interactive shell than
bash. to understand mksh, I read the man page :)

for scripting purposes, I use `dash` most of the time but I might use `bash`
when things get a little complicated

# editor
`nvim` is the editor which I like and use. honestly, anything with a vi-like
keybinding would be comfy for me. if you give me an emacs setup which has
everything configured to be vi-like, I would happily use it without complaining.
in fact, I tried to use evil a couple of times before but I lost interest in
configuring due to laziness.

moreover, I use `nvim` as my terminal mutliplexer, unironically. it has a nice
terminal built in and splits are comfy so I decided to use it as my terminal
multiplexer

# browser
qutebrowser is my current browser because I like how easily configurable it is.
I used firefox but got tired of the fact that I had to use an extension to get a
custom new tab

# suckless software
I like suckless software. I love how easy it is to add your own stuff you want
to the source code without much pain. it is minimal and does just enough. if
you're not compiling suckless software yourself, then you're wrong. suckless
software's configuration is done by editing the source code, this allows the
program to be more flexible as you're literally editing the program to make
changes.

as I'm a lazy snob who likes to not do stuff by himself, I wrote
[`tm`](https://github.com/Th3-Hum4n/tm) to create header files for suckless
software and other files/configs which involve colors. I give it a colorscheme
of 16 colors in a raw text file (see `$HOME/etc/colors`) and tm creates the
files for me. I have a wrapper script which recompiles suckless software and
does a couple more things to reload dwm

# window management
I'm a fan of tiling window managers. for lazy snobs like me who don't like to
arrange their windows themselves, tiling wms are a boon. dwm is my first and
favorite window manager. I'm so used to dwm that I switch back to it after I use
some other window manager for five minutes. I tried bspwm, awesome, xmonad and
other window managers, but I kept going back to dwm because I liked it. it is
simple and hackable and I'm a big fan of the layouts it uses.

*why not i3?*

I hate it. it's not fully layout based like dwm nor it is fully manual like
[kiwmi](https://github.com/buffet/kiwmi). I don't think the default keybindings
are sane at all and the configuraton file is really hard to navigate. so I never
really bother to use it

as you might have noticed, my dwm configuration can use lemonbar which is not
something that can be achieved ootb or by a patch. [Mitch
Weaver](https://github.com/MitchWeaver)'s dwm configuration has fifo functions
which can be used to script a bar. in fact, that's what I use

# scrots
![](https://github.com/Th3-Hum4n/home/blob/master/var/pictures/scrots/viking_with_solid_bg.png)
![](https://github.com/Th3-Hum4n/home/blob/master/var/pictures/scrots/Tue_Oct_30-20:23.png)

---
*I thank the authors of the scripts which I might have stolen and forgot about*
*feel free to steal my crap too*
---
