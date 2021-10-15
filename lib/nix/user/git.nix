# My git config
# TODO: Look into using ssh for fetching
{
  enable      = true;
  userEmail   = "visuwesh@tutanota.com";
  userName    = "Visuwesh";
  aliases     = {
    com       = "commit";
    tracked   = "ls-files";
    untracked = "ls-files -o --exclude-standard";
    changed   = "ls-files -m";
  };
  # Emacs swap/auto-save files
  ignores     = [ "*~" "#*#" ];
  extraConfig = {
    init.defaultBranch = "master"; # Yes
  };
}
