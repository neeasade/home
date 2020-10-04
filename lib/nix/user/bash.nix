{
  enable = false;
  historyFile = "\$HOME/.cache/bash_history";
  historyFileSize = 10000000000;
  historyIgnore = [ "ls" ];
  historySize = 10000000000;

  shellAliases = {
    cmd = "command";
    rkt = "racket";
    py = "python3";
    mpf = "zathura";
    resxhkd = "pkill -USR1 -x sxhkd";
    doas = "doas ";
    uwugivemerootpleaseuwu = "doas ";

    mki = "make install";
    mka = "make all";
    mku = "make uninstall";
    mkc = "make clean";
    mk = "make";

    cl = "clear";
    cle = "clear";
    clea = "clear";

    "c.." = "cd ..";

    SU = "doas bash";

    sl = "ls";
    rsc = "resource";
    aliases = "alias";
    quit = "exit";
    wh = "command -v";
    datenow = "date +\"%H:%M %A %d %B, %Y\"";

    # Sane defaults
    r = "fc -s";
    df = "df -h";
    du = "du -h";
    mv = "mv -i";
    cp = "cp -r";
    ln = "ln -s";
    free = "free -h";
    fc-cache = "fc-cache --verbose";
    grep = "grep -i";
    su = "su -";
    cal = "cal -s";
    mkd = "mkdir -p";
    rmf = "rm -fr";             # French rights!
    diff = "git diff --no-color";
  };

  shellOptions = [ "expand_aliases" ];

  initExtra = ''
  # Functions
  has(){
    type -p "$1" >/dev/null
  }

  find-font(){
    [[ "$1" ]] && fc-list | grep -i "$*"
  }

  _c(){
    local p
    for p in "$@" $@* *$@ *$@*; {
        if [[ -f "$p" ]]; then
           case $(file -ib "$p") in
           *pdf*) zathura "$p" ;;
           *image*) meh "$p" ;;
           *audio*) ;&
           *video*) mpv "$p" ;;
           *zip*) upkp "$p" ;;
           *) cat "$p" ;;
           esac
           return 0
        elif [[ -d "$p" ]]; then
           cd "$p"
           return 0
        fi
    }

    printf 'error: no such file or dir %s\n' "$p"
  }

  c(){
    [[ $# -eq 0 ]] && clear
    for i; {
        _c "$i"
    }
  }

  l(){
    if [[ -p /dev/stdin ]]; then
       less
    elif [[ -f "$1" ]]; then
       less "$1"
    elif [[ -d "$1" || -z "$1" ]]; then
       ls "''${1:-.}"
    fi
  }

  # Looks much more uniform, for the most part
  ls(){
    command ls -AFC "$@" | column -t
  }

  resource(){
    source $HOME/.bashrc
  }

  conf(){
    [[ -d "$HOME/opt/repos/home" ]] || return 1
    g(){
     git --git-dir="$HOME/opt/repos/home" --work-tree="$HOME" "$@"
    }

    case $1 in
    sync)
      conf add "$(conf ls-files -m)"
      conf com sync
      conf push
      ;;
    com*) shift; g commit -m "$@" ;;
    push) g push origin master ;;
    list) g ls-files | less ;;
    *) g "$@" ;;
    esac

    unset -f g
  }

  rmd(){
    for i; {
        [[ -d "$i" ]] || {
           printf 'error: %s not a directory\n' "''${d##*/}"
           continue
        }
        rm -r "$i"
    }
  }

  urm(){
    local d="$_"
    [[ -d "$d" ]] || return 1
    for f; {
        [[ "$f" != "$d" ]] &&
           rm "$d/''${f##*/}"
    }
  }

  iif(){
    if eval $1 >/dev/null; then
       printf '%s' "$2"
    else
       printf '%s' "$3"
    fi
  }

  iff(){
    if eval $1 >/dev/null; then
       eval "$2"
    else
       eval "$3"
    fi
  }

  map(){
    while read -r l; do
          $@ "$l"
    done </dev/stdin
  }

  filter(){
    while read -r l; do
          $@ "$l" && printf '%s' "$1"
    done </dev/stdin
  }

  ormap(){
    while read -r l; do
          $@ "$l" && return 0
    done </dev/stdin
    return 1
  }

  andmap(){
    while read -r l; do
          $@ "$l" || return 1
    done </dev/stdin
    return 0
  }

  unix2dos() for i; { sed -i -e 's/\r*$/\r/' "$i"; };
  dos2unix() for i; { sed -i -e 's/\r//'     "$i"; };

  # Weaponsied shitposting
  aesthetic(){
    sed -e 's/./& /g' <<<"$*"
  }
  discord(){
    sed '
  y/ABCDEFGHIJKLMNOPQRSTUVWXYZ /abcdefghijklmnopqrstuvwxyz\t/
  s/[^\tb]/:regional_indicator_&: /g
  s/\t/:clap: /g
  s/b/:b: /g' <<<"$*"
  }

  # Wrappers
  has git && {
      git(){
            case $1 in
            ignore-get)
              wget -O .gitignore \
                   https://raw.githubusercontent.com/github/gitignore/master/$2.gitignore
              ;;
            squash)
              local cnf
              read -r cnf -p 'Do you want to continue? '
              [[ "$cnf" != [yY]* ]] && return 0
              command git reset --soft HEAD=$2
              shift 2
              command git commit -m "$@"
              ;;
            com|commit)
              shift
              if [[ -n "$1" ]]; then
                 command git commit -m "$@"
              else
                 command git commit
              fi
              ;;
            clone)
              local fnl="$@"
              [[ "$2" != *viz* ]] && fnl="$@ --depth 1"
              command git "$fnl"
              ;;
            *) command git "$@" ;;
            esac
      }
  }

  has emacs && {
      remacs(){
        pgrep -x emacs >/dev/null && pkill emacs
        emacs --daemon
      }

      v(){
        ! pgrep -x emacs >/dev/null || !pgrep -x X >/dev/null && {
          emacs -nw -q "$@"
          return $?
        }
        emacsclient -c "$@"
      }

      # Inside M-x shell
      [[ -n "$INSIDE_EMACS" ]] && [[ "$TERM" = dumb ]] && {
         # TODO: Change pager to `view-file-mode' instead?
         MANPAGER='cat' PAGER='cat'

         elisp-shell(){
          elisp - <<EOF
(with-current-buffer
  (window-buffer (selected-window))
  $@)
EOF
         }

         racket(){
          elisp-shell '(setq-local comint-process-echoes nil)' >/dev/null
          command racket "$@"
          elisp-shell '(setq-local comint-process-echoes t)' >/dev/null
         }

         v(){
          elisp "(find-file \"$@\")"
         }

         clear(){
          :
          # elisp '(commint-clear-buffer)' >/dev/null
         }

         transmission(){
          [[ -d $HOME/opt/transmission-download ]] ||
             mkdir -p $HOME/opt/transmission-download
          pgrep transmission ||
                transmission-daemon -w $HOME/opt/transmission-download
          elisp -t '(transmission)'
         }

         trans(){
          transmission
         }

         trans-add(){
          elisp - <<EOF
(transmission-add "$1" "''${2:-$PWD}")
EOF
         }

         man(){
          case $* in
          *configuration.nix) st -e man -P less "$@" &>/dev/null ;;
          *)
            if [[ ! -t 0 ]]; then
               local t=$(mktemp)
               cat ->$t
               elisp "(pop-to-buffer-same-window (man \"-l $t\"))
                      (delete-file \"$t\")" >/dev/null
            else
               elisp "(pop-to-buffer-same-window (man \"$@\"))"
            fi
            ;;
          esac
         }

         less(){
            if [[ ! -t 0 ]]; then
               local t=$(mktemp)
               sed -E 's/[\x01-\x1F\x7F]\[[0-9;]+m//g' >$t
               elisp "(view-file \"$t\") (delete-file \"$t\")" >/dev/null
            else
               elisp "(view-file \"$@\")" >/dev/null
            fi
         }

         for i in top alsamixer vidir transmission-cli ircdiscord; {
             eval "
$i(){
  st -e "$i \"$@\"" &>/dev/null &
}
"
         }
      }
  }

  has mpv && muss(){
      mpv "''${1:-.}" --shuffle
  }

  has nix && nx(){
      case $1 in
      sh) shift; nix-shell "$@" ;;
      sr)
        shift
        [[ -z "$@" ]] && return 0
        find /nix/store -maxdepth 1 -type d $(
             for i; {
                 printf '-name *%s*' "$i"
             })
        ;;
      shl)
        [[ -f shell.nix ]] && {
           echo error: shell.nix already exists
           return 1
        }
        cat >shell.nix <<EOF
with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "-environment";

  buildinputs = [];
  nativebuildinputs = [];
}
EOF
        ;;
      pkg)
        [[ -f "$2" ]] && {
           echo error: "$2" already exists
           return 1
        }
        [[ "$2" ]] || {
           echo error: no file argument given
           return 1
        }
        cat >$2 <<EOF
{ stdenv, fetch }:

stdenv.mkDerivation rec {
  pname = "";
  version = "";
  src = fetch {
  };

  buildInputs = [];
  nativebuildinputs = [];

  patches = [];

  makeFlags = [];
  installFlags = [];

  meta = with stdenv.lib {
    description = "";
    homepage = "";
    license = licenses.;
    platforms = platforms.linux;
  };
}
EOF
        ;;
      *)
        cat <<EOF
usage: nx [shl|pkg file|sh ...| sr ...]
    shl: create shell.nix template
    pkg: write package template
    sh: start nix-shell
    sr: search in /nix/store
EOF
        ;;
      esac
  }

  # Prompt
  _PS1_command(){
    [[ "$TERM" = dumb ]] && [[ -n "$INSIDE_EMACS" ]] &&
       printf -v PS1_PREFIX '|Pr0mpt|%s|' "$PWD"
    [[ -n "$IN_NIX_SHELL" ]] && printf -v PS1_PREFIX '%s%s' "$PS1_PREFIX" '!'
    case $(whoami) in
    root) printf -v PS1 '%s# ' "$PS1_PREFIX" ;;
    viz) printf -v PS1 '%sμ ' "$PS1_PREFIX" ;;
    *) printf -v PS1 '%s%% ' "$PS1_PREFIX" ;;
    esac
  }

  PROMPT_COMMAND="_PS1_command";
  PS2="… "
  '';
}
