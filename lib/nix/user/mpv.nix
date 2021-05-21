# mpv config. Mainly subtitle settings
{
  enable = true;

  config = {
    # Don't display album art or w/e
    audio-display       = "no";

    osd-font            = "Go";
    osd-font-size       = 20;

    sub-font            = "Go";
    sub-font-size       = 20;
    sub-color           = "#ffffff";
    sub-border-color    = "#000000";
    sub-border-size     = 2;

    # Doesn't always work. Subtitle file can hardcode size using /fs
    sub-ass-force-style = "Fontname=Go,Fontsize=20";
    embeddedfonts       = "no";

    image-display-duration = "inf";
  };

  bindings = {
    "Ctrl+r" = "no-osd cycle-values video-rotate \"90\" \"180\" \"270\" \"0\"";
  };
}
