# Setup Xorg and friends
# I boot straight into Xorg using LightDM.

{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = true;
      startDbusSession = true;
      updateDbusEnvironment = true;

      libinput = {
        enable = true;
        scrollMethod = "twofinger";
        tapping = true;
        disableWhileTyping = true;
      };

      # Setup home-manager xsession
      desktopManager.session = [{
        name = "home-manager";
        bgSession = true;
        start = ''
          ${pkgs.stdenv.shell} $HOME/lib/xsession &
          waitPID=$!
        '';
      }];

      displayManager = {
        defaultSession = "home-manager";

        lightdm = {
          enable = true;
          autoLogin = { enable = true; user = "viz"; };
          # You don't even see this when autorun is enabled /shrug
          background = "#dde0e2";
          greeter.enable = false;
        };
      };

      videoDrivers = [ "intel" ];
      layout = "us";

      # Swap Capslock and Escape
      xkbOptions = "caps:swapescape";

      # Intel TearFree section thing
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
      socketActivated = true;
      packages = with pkgs; [ gnome3.dconf gcr ];
    };
  };
}
