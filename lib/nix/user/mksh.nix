{ pkgs, ... }:

{
  enable = true;

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

    lst = "ls -c";              # Sorted by time.

    # Sane defaults
    ls = "ls -1AF";
    du = "du -h";
    df = "df -h";
    mv = "mv -i";
    cp = "cp -r";
    ln = "ln -s";
    free = "free -h";
    fc-cache = "fc-cache --verbose";
    grep = "grep -iHn";
    su = "su -";
    cal = "cal -s";             # Sunday is the first day of the week! :P
    mkd = "mkdir -p";
  };

  directoryAliases = {
    B = "\$HOME/bin";
    S = "\$HOME/src";
    R = "\$HOME/lib/repos";
    T = "\$HOME/tmp";
    I = "\$HOME/med/img";
    E = "\$HOME/lib/emacs";
    D = "\$HOME/doc";
    C = "\$XDG_CACHE_HOME";
    M = "\$HOME/med/mus";
    N = "\$HOME/lib/nix";
    b = "\$HOME/doc/books";
    u = "\$HOME/doc/uni";
    a = "\$HOME/med/vid/anm";
    s = "\$HOME/med/img/screenshots";
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
        p="$(realpath "$p")"
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

    lc = ''
       command ls -AF "$@"
    '';

    resource = ''
      . $HOME/lib/kshrc
    '';

    conf = ''
      [[ -d "$HOME/lib/repos/home" ]] || return 1
      g() command git --git-dir="$HOME/lib/repos/home" --work-tree="$HOME" "$@";

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
      [[ -n "$INSIDE_EMACS" ]] && print -n "|PROMPT|$PWD|"
      [[ -n "$IN_NIX_SHELL" ]] && print -n ';'
      case $(whoami) {
      root) print -n '# '                ;;
      viz)  print -n '; '; _PS1_command &;;
      *)    print -n '% '                ;;
      }
    '';
  };

  extraConfig = ''
    PS1=$'\1\r$(_draw_PS1)'
  '';

  conditionalFunctions = {
    mpv.muss = ''
      mpv "''${1:-.}" --shuffle
    '';

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

    nix = {
      # This is adapted from github.com/chisui/zsh-nix-shell
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
{ stdenv, lib, fetch }:

stdenv.mkDerivation rec {
  pname = "";
  version = "";
  src = fetch {
  };

  buildInputs = [];
  nativeBuildInputs = [];

  meta = with lib; {
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

    emacs = {
      remacs = ''
        pgrep emacs >/dev/null && pkill emacs
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
  };

  # M-x shell is amazing
  insideM-xShell = {
    functions = {
      elisp-shell = ''
        elisp - <<EOF
(with-current-buffer (process-buffer (seq-find (lambda (x) (eq $TOP_MKSH_PID (process-id x))) (process-list)))
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
        [[ -d $HOME/tmp/transmission-download ]] ||
          mkdir -p $HOME/tmp/transmission-download
        pgrep transmission >/dev/null ||
          transmission-daemon -w $HOME/tmp/transmission-download
        elisp -t '(transmission)'
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
          local lisp
          if [[ ! -t 0 ]]; then
            local t=$(mktemp)
            cat ->$t
            lisp="(man \"-l $t\") (delete-file \"$t\")"
          else
            lisp="(man \"$*\")"
          fi

          # `process-environment' is a list of env vars that is passed to the
          # subprocess.  Adding nix-shell's PATH to this is essential so that
          # manpath command will also include the manpage of temporarily
          # installed packages.
          # NOTE: That for manpath to be run by the man command, MANPATH should
          # be an empty string!  See #21946 in nixpkgs.
          [[ -n "$IN_NIX_SHELL" ]] &&
             lisp="(let ((process-environment \`(\"PATH=$PATH\" ,@process-environment))) $lisp)"

          # `Man-notify-method' controls how the man page should be displayed.
          # Setting it to 'pushy will replace the current buffer with the man page.
          elisp-shell "(let ((Man-notify-method 'pushy)) $lisp)" >/dev/null
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

      cd = ''
        command cd "$@"
        # elisp-shell "(cd \"$PWD/\")" >/dev/null
      '';
    };

    extraConfig = ''
      [[ -z "$IN_NIX_SHELL" ]] &&
         export TOP_MKSH_PID=$$

      # Sync Emacs' `default-directory'
      # elisp-shell "(setq-local default-directory \"$PWD/\")" >/dev/null

      MANAPGER=cat PAGER=cat
      export MANPAGER PAGER

      for i in top alsamixer vidir transmission-cli ircdiscord; {
        eval "
        $i(){
          st -e "$i \"\$@\"" >/dev/null 2>&1 &
        }
        "
      }

      # Update Emacs' `exec-path' variable inside nix-shell.  This will allow
      # for completion of paths and potentially other things.
      [[ -n "$IN_NIX_SHELL" ]] &&
        elisp-shell "(setq-local exec-path (parse-colon-path \"$PATH\"))" >/dev/null
    '';
  };
}
