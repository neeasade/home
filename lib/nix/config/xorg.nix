# Setup Xorg and friends
# I boot straight into Xorg using LightDM.

{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = true;
      updateDbusEnvironment = true;

      libinput = {
        enable = true;
        touchpad = {
          scrollMethod = "twofinger";
          tapping = true;
          disableWhileTyping = true;
        };
      };

      # Setup home-manager xsession
      desktopManager.session = [
        {
          name = "home-manager-xorg";
          bgSession = true;
          start = ''
            ${pkgs.stdenv.shell} $HOME/lib/xsession &
            waitPID=$!
          '';
        }
      ];

      displayManager = {
        defaultSession = "home-manager-xorg";
#        sessionPackages = [ pkgs.wayfire-session ];

        autoLogin = {
          enable = true;
          user = "viz";
        };

        lightdm = {
          enable = true;
          autoLogin.timeout = 0;
          greeter.enable = false;
        };
      };

      videoDrivers = [ "intel" ];

      # Swap Capslock and Escape
      xkbOptions = "caps:swapescape,ctrl:swap_lwin_lctl";

      # intel TearFree section thing
      extraConfig = ''
        Section "Device"
          Identifier "Intel"
          Driver "intel"
          Option "TearFree" "true"
          Option "VSync" "true"
        EndSection
      '';
    };

    dbus = {
      packages = with pkgs; [ gnome3.dconf gcr ];
    };
  };

  systemd.packages = with pkgs; [ gnome3.dconf ];
}
