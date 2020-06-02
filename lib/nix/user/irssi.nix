# I don't use irssi anymore. I use circe
# TODO: Maybe setup ircdiscord stuff?
{
  enable = false;

  networks."Freenode" = {
    nick = "_viz_";
    autoCommands = [
      "/passwd Freenode /msg NickServ identify <password>"
    ];
    server = {
      address     = "chat.freenode.net";
      port        = 6697;
      autoConnect = true;
    };
    channels = {
      nixos.autoJoin      = true;
      nixhub.autoJoin     = true;
      unixporn.autoJoin   = true;
      vis-editor.autoJoin = true;
    };
  };

  networks."MadHouse" = {
    nick = "_viz_";
    autoCommands = [
      "/passwd MadHouse /msg NickServ IDENTIFY <password>"
    ];
    server = {
      address     = "irc.astrak.co";
      port        = 6697;
      autoConnect = true;
      ssl.verify  = false;
    };
    channels = {
      mh-general.autoJoin   = true;
      mh-linux.autoJoin     = true;
      mh-unixporn.autoJoin  = true;
      mh-memes.autoJoin     = true;
      mh-scripting.autoJoin = true;
    };
  };
}
