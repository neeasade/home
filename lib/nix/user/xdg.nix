# I try to follow a Plan 9 like home directory
# ~/lib       - config files
# ~/opt       - data files
# ~/tmp       - temporary directory that has downloads and stuff
# ~/med       - media     -- videos, images, music
# ~/doc       - documents -- school stuff, books
# ~/src       - source code for stuff that I wrote
# ~/bin       - scripts
# ~/bin/<app> - scripts that depend on/used by <app>
{
  enable        = true;
  cacheHome     = "/home/viz/.cache";
  configHome    = "/home/viz/lib";
  dataHome      = "/home/viz/opt";
  userDirs      = {
    enable      = true;
    download    = "/home/viz/tmp";
    music       = "/home/viz/med/mus";
    pictures    = "/home/viz/med/img";
    videos      = "/home/viz/med/vid";
    desktop     = "/no";
    documents   = "/no";
    publicShare = "/no";
    templates   = "/no";
  };

  configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;
}
