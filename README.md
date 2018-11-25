# $HOME
all the things in $HOME

# file hiearchy system
```
$HOME/var -> personal files
$HOME/usr/src -> projects
$HOME/usr/fonts -> fonts
$HOME/bin -> one file scripts
$HOME/usr/repos -> repos that are not modified*
$HOME/usr/man -> man pages
$HOME/usr/local/bin -> binaries of various programs
$HOME/etc -> config files
$HOME/tmp -> junk**
```

\* exceptions include `config.mk` and `Makefile`

\** `~/tmp` can contain some info which will be used by scripts. For example, `invcurwin` writes the `WM_CLASS` and 0 or 1 to `~/tmp`. FIFOs aren't really junk.

I symlink `~/usr/fonts` to `~/.fonts` because it's better than making a custom config file for fontconfig.

# managing colors
I use [tm](https://github.com/Th3-Hum4n/tm) to create themes from raw text files. Makes my life easier when I want to change themes in an instant. To change the theme, I run `tm -c ~/etc/colors/colors_name && rice` which will create color files and recompile all the suckless software.

# scrots
![scrot](https://github.com/Th3-Hum4n/home/blob/master/var/pictures/scrots/viking_with_rust.png)

![scrot2](https://github.com/Th3-Hum4n/home/blob/master/var/pictures/scrots/viking_with_solid_bg.png)

![scrot3](https://github.com/Th3-Hum4n/home/blob/master/var/pictures/scrots/Sun_Nov_04-13:45.png)

# keybindings
**Usually** the meta key is used for launching applications. alt for window manager actions and ctrl for window specific actions.

to change layouts in dwm, you have to press `SUPER + N` where N -> {1 2 3 4 5 6 7}. Most used layouts are given a lower number.

1 -> Tiling

2 -> Bottom stack

3 -> Monocle

4 -> Deck

5 -> Floating

{6, 7} -> I have no clue but it's probably the fibonacci ones

I use `sxhkd` for launching applications because the syntax is quite simple and the program itself is quite painless to setup unlike xbindkeys which refused to work in some machines.

I remapped CAPS_LOCK to ESC as I tend to use ESC a lot (vi-like keybinds). Capslock is closer to the home row and I don't use it often... so yea.

# wallpapers
I ~~steal~~ get my wallpapers from unsplash and r/unixporn posts.

# programming languages
I try to use dash wherever possible. If I cannot do something with dash, then I fallback to bash and then fallback to python. Scripts which involve json data like `say`, I programmed in python because JSON.sh or jq is just bloat when there's a json module in python.

# browser
firefox is my choice, it's riceable and it cares about the user's privacy. For viewing documents, like the rust's book, however, I tend to use surf. surf is small and does the job I need.


I might switch to [kiwmi](https://github.com/buffet/kiwmi) once it's ready as it seems to have a cool concept.
