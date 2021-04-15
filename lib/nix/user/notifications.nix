{ pkgs, ... }:

{
  enable = false;

  iconTheme = {
    package = pkgs.gnome3.adwaita-icon-theme;
    name = "Adwaita";
    size = "16x16";
  };

  settings = {
    global = {
      geometry = "300x20-50+50";
      frame_width = 4;
      frame_color = "#6ecbdc";
      font = "serif 14";
      shrink = "yes";
      format = "%s\\n%b";
    };

    urgency_normal = {
      foreground = "#0d0d0d";
      background = "#ffffff";
      timeout = 5;
    };

    urgency_low = {
      foreground = "#0d0d0d";
      background = "#ffffff";
      timeout = 5;
    };

    urgency_critical = {
      foreground = "#ff9994";
      background = "#ffffff";
      timeout = 10;
    };
  };
}
