# autostart X server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

export VISUAL="nvim"
XDG_CONFIG_HOME="$HOME/.config"
