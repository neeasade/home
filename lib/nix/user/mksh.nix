{ pkgs, ... }:

{
  enable = true;

  conditionalAliases = {
    python3.py = "python3";
    racket.rkt = "racket";
    zathura.mpf = "zathura";
    sxhkd.resxhkd = "pkill -USR1 -x sxhkd";
    git.diff = "git diff --no-color";

    make = {
      mk = "make";
      mkic = "make clean install";
      mkci = "make clean install";
      mki = "make install";
      mka = "make all";
      mku = "make uninstall";
      mkc = "make clean";
    };
  };

  aliases = {
    cmd = "command";
    rsc = "resource";

    aliases = "alias";
    quit = "exit";
    wh = "command -v";
    datenow = "date +'%H:%M %A %d %B, %Y'";

    rmf = "rm -fr";             # French rights!
    sl = "ls";
    SU = "doas mksh";

    cl = "clear";
    cle = "clear";
    clea = "clear";

    # Sane defaults
    ls = "ls -AF";
    du = "du -h";
    df = "df -h";
    mv = "mv -i";
    cp = "cp -r";
    ln = "ln -s";
    free = "free -h";
    fc-cache = "fc-cache --verbose";
    grep = "grep -i";
    su = "su -";
    cal = "cal -s";             # Sunday is the first day of the week! :P
    mkd = "mkdir -p";
  };

  directoryAliases = {
    B = "\$HOME/bin";
    S = "\$HOME/src";
    R = "\$HOME/opt/repos";
    T = "\$HOME/tmp";
    W = "\$HOME/med/img/walls";
    A = "\$HOME/med/img/art";
    F = "\$HOME/med/img/film";
    E = "\$HOME/lib";
    D = "\$HOME/doc";
    C = "\$XDG_CACHE_HOME";
    M = "\$HOME/med/mus";
    N = "\$HOME/lib/nix";
    K = "\$HOME/lib/ksh";
    s = "\$HOME/doc/school";
    u = "\$HOME/doc/uni";
    a = "\$HOME/med/vid/anm";
  };

  functions = {
    has = ''
        type -p "$1" >/dev/null
    '';

    find-font = ''
      [[ -n "$1" ]] && fc-list | grep -i "$*"
    '';

    _c = ''
      local p
      for p in "$@" $@* *$@ *$@*; {
        if [[ -f "$p" ]]; then
          case $(file -ib "$p") {
          *pdf*) zathura "$p" ;;
          *image*) meh "$p"   ;;
          *audio*)            ;&
          *video*) mpv "$p"   ;;
          *zip*) upkp "$p"    ;;
          *) cat "$p"         ;;
          }
          return 0
       elif [[ -d "$p" ]]; then
          cd "$p"
          return 0
       fi
      }
      print error: no such file or dir "$p"
    '';

    c = ''
      [[ $# -eq 0 ]] && clear
      for i; {
        _c "$i"
      }
    '';

    l = ''
      if [[ -p /dev/stdin ]]; then
        less
      elif [[ -f "$1" ]]; then
        less "$1"
      elif [[ -d "$1" || -z "$1" ]]; then
        ls ''${1:-.}
      fi
    '';

    ls = ''
      command ls -AFC "$@" | column -t
    '';

    resource = ''
      . $HOME/lib/kshrc
    '';

    conf = ''
      [[ -d "$HOME/opt/repos/home" ]] || return 1
      g() git --git-dir="$HOME/opt/repos/home" --work-tree="$HOME" "$@";

      case $1 {
      sync)
        conf add $(conf ls-files -m)
        conf com sync
        conf push
        ;;
      com*) shift; g commit -m "$@"     ;;
      push)        g push origin master ;;
      list)        g ls-files | less    ;;
      *)           g "$@"               ;;
      }

      unset -f g
    '';

    rmd = ''
      for i; {
        if [[ -d "$i" ]]; then
          rm -r "$i"
        else
          print error: ''${i##*/} is not a directory
        fi
      }
    '';

    urm = ''
      local d="$_"
      [[ -d "$d" ]] || return 1
      for f; {
        [[ "$f" != "$d" ]] &&
          rm "$d/''${f##*/}"
      }
    '';

    iif = ''
      if eval $1 >/dev/null; then
        print -- "$2"
      else
        print -- "$3"
      fi
    '';

    iff = ''
      if eval $1 >/dev/null; then
        eval $2
      else
        eval $3
      fi
    '';

    map = ''
      while read -r l; do
        $@ "$l"
      done </dev/stdin
    '';

    filter = ''
      while read -r l; do
        $@ "$l" >/dev/null 2>&1 && print -- "$l"
      done </dev/stdin
    '';

    ormap = ''
      while read -r l; do
        $@ "$l" >/dev/null 2>&1 && return 0
      done </dev/stdin
      return 1
    '';

    andmap = ''
      while read -r l; do
        $@ "$l" >/dev/null 2>&1 || return 1
      done </dev/stdin
    '';

    rsfile = ''
      tr 'A-Z .' 'a-z_' <<<"''${1%.*}"
    '';

    unix2dos = ''
      for i; {
        sed -i -e 's/\r*$/\r/' "$i"
      }
    '';

    dos2unix = ''
      for i; {
        sed -i -e 's/\r//' "$i"
      }
    '';

    aesthetic = ''
      sed -e 's/./& /g' <<<"$*"
    '';

    discord = ''
      sed '
      y/ABCDEFGHIJKLMNOPQRSTUVWXYZ /abcdefghijklmnopqrstuvwxyz\t/
      s/[^\tb]/:regional_indicator_&: /g
      s/\t/:clap: /g
      s/b/:b: /g' <<<"$*"
    '';

    # Prompt stuff
    _set_wn = ''
      case $TERM {
      linux|dumb)
        ;;
      *)
        printf '\1\033]]0;%s: %s\a\1' \
          $(iif '[[ -z "$IN_NIX_SHELL" ]]' ksh !ksh) \
          $(iif '[[ $PWD = $HOME* ]]' "~''${PWD#$HOME}" "$PWD")
        ;;
      }
    '';

    _PS1_command = ''
      _set_wn 2>/dev/null
    '';

    _draw_PS1 = ''
      [[ "$TERM" = dumb ]] && [[ "$INSIDE_EMACS" = [0-9]*,comint ]] &&
        print -n "|Pr0mpt|$PWD|"

      [[ -n "$IN_NIX_SHELL" ]] && print -n '!'
      case $(whoami) {
      root) print -n '# '                ;;
      viz)  print -n 'μ '; _PS1_command &;;
      *)    print -n '% '                ;;
      }
    '';
  };

  conditionalFunctions = {
    git.git = ''
      case $1 {
      ignore-get)
        wget -O .gitignore \
          https://raw.githubusercontent.com/github/gitignore/master/$2.gitignore
        ;;
      squash)
        local cnf
        read -r cnf?'Do you want to continue? '
        [[ "''${cnf:0:1}" != @(y|Y) ]] && return 0
        command git reset --soft HEAD~$2
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
        local fnl
        fnl=("$@")
        [[ "$2" != *viz* ]] && fnl+=('--depth=1')
        command git "''${fnl[@]}"
        ;;
      *)
        command git "$@"
        ;;
      }
    '';

    emacs = {
      remacs = ''
        pgrep -x emacs >/dev/null && pkill emacs
        emacs --daemon
      '';

      v = ''
        ! grep -x emacs >/dev/null || ! pgrep -x X >/dev/null && {
          emacs -nw -q "$@"
          return $?
        }
        emacsclient -c "$@"
      '';
    };

    mpv.muss = ''
      mpv "''${1:-.}" --shuffle
    '';

    nix = {
      _nxsh = let
        nxsh = pkgs.writeShellScript "nxsh" ''
          case $1 in
          --rcfile)
            tmp="$(<$2)"
            echo ''${tmp%exit} >$2
            echo $NIX_EXECUTING_SHELL >>$2
            bash $2
            ;;
          *)
            bash "$@"
            ;;
          esac
        '';
      in
      ''
        local inpkgs=0 NIX_SHELL_PACKAGES args
        args=("$@")
        while (($#>0)); do
          case $1 {
          -p|--packages)
            inpkgs=1
            NIX_SHELL_PACKAGES+=("$2")
            shift
            ;;
          --arg|--argstr)
            inpkgs=0
            shift 2
            ;;
          -*)
            inpkgs=0
            ;;
          *)
            [[ $inpkgs -eq 1 ]] &&
            NIX_SHELL_PACKAGES+=("$1")
            ;;
          }
          shift
        done
        NIX_SHELL_PACKAGES="''${NIX_SHELL_PACKAGES[@]}" \
          NIX_BUILD_SHELL="${nxsh}" \
          NIX_EXECUTING_SHELL="$SHELL" nix-shell "''${args[@]}"
      '';

      nx = ''
        case $1 {
        sr)
          shift
          [[ -z "$@" ]] && return 0
          find /nix/store -maxdepth 1 -type d $(
            for i; {
              print -- "-name *$i*"
            }
          )
          ;;
        shl)
          [[ -f shell.nix ]] && {
            print error: shell.nix already exists
            return 1
          }
          cat >shell.nix <<EOF
with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "-environment";

  buildInputs = [];
  nativeBuildInputs = [];
}
EOF
          ;;
        sh)
          shift 1
          _nxsh "$@"
          ;;
        pkg)
          [[ -f "$2" ]] && {
            print error: $2 already exists
            return 1
          }
          [[ -z "$2" ]] && {
            print error: no file argument given
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
  nativeBuildInputs = [];

  patches = [];

  makeFlags = [];
  installFlags = [];

  meta = with stdenv.lib; {
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
usage: nx [shl|pkg file|sh ...|sr ...]
	shl: create shell.nix template
	pkg: write package template
	sh: start nix-shell
	sr: search in /nix/store
EOF
          ;;
        }
      '';
    };
  };

  shellOptions = [
    "nohup"
    "bgnice"
    "trackall"
    "utf8-mode"
  ];

  vars = {
    HISTFILE = "\$XDG_CACHE_HOME/mksh_history";
    HISTSIZE = "65535";         # Max size for mksh

    PS2 = "… ";
  };

  extraConfig = ''
    PS1=$'\1\r$(_draw_PS1)'
  '';

  # M-x shell is amazing
  insideM-xShell = {
    functions = {
      elisp-shell = ''
        elisp - <<EOF
  (with-current-buffer (window-buffer (selected-window))
    $@)
  EOF
      '';

      racket = ''
        elisp-shell '(setq-local comint-process-echoes nil)' >/dev/null
        command racket "$@"
        elisp-shell '(setq-local comint-process-echoes t)' >/dev/null
      '';

      v = ''
        elisp-shell "(find-file \"$@\")"
      '';

      clear = ''
        :
        # elisp-shell '(comint-clear-buffer)' >/dev/null
      '';

      transmission = ''
        [[ -d $HOME/opt/transmission-download ]] ||
          mkdir -p $HOME/opt/transmission-download
        pgrep transmission ||
          transmission-daemon -w $HOME/opt/transmission-download
        elisp -t '(transmision)'
      '';

      trans = "transmission";

      trans-add = ''
        elisp - <<EOF
        (transmission-add "$1" "''${2:-$PWD}")
        EOF
      '';

      man = ''
        case $* {
        *configuration.nix)
          st -e man -P less "$@" >/dev/null 2>&1
          ;;
        *)
          if [[ ! -t 0 ]]; then
            local t=$(mktemp)
            cat ->$t
            elisp-shell "(pop-to-buffer-same-window (man \"-l $t\"))
              (delete-file \"$t\")" >/dev/null
          else
            elisp-shell "(pop-to-buffer-same-window (man \"$*\"))" >/dev/null
          fi
        }
      '';

      less = ''
        if [[ ! -t 0 ]]; then
          local t=$(mktemp)
          sed -E 's/[\x01-\x1F\x7F]\[[0-9;]+m//g' >$t
          elisp-shell "(view-file \"$t\") (delete-file \"$t\")" >/dev/null
        else
          elisp-shell "(view-file \"$t\")" >/dev/null
        fi
      '';
    };

    extraConfig = ''
      MANAPGER=cat PAGER=cat
      export MANPAGER PAGER

      for i in top alsamixer vidir transmission-cli ircdiscord; {
        eval "
        $i(){
          st -e "$i \"\$@\"" >/dev/null 2>&1 &
        }
        "
      }
    '';
  };
}
