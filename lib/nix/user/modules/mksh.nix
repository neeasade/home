# TODO: Really needs a cleanup but it works so w/e

{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.programs.mksh;
in
  {
    options.programs.mksh = {
      enable = mkEnableOption "MirBSD's Korn Shell";

      aliases = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      conditionalAliases = mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        default = {};
      };

      directoryAliases = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      functions = mkOption {
        type = types.attrsOf (types.nullOr types.lines);
        default = {};
      };

      conditionalFunctions = mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.lines));
        default = {};
      };

      envvars = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      vars = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      shellOptions = mkOption {
        type = types.listOf types.str;
        default = [ "utf8-mode" ];
      };

      insideM-xShell.functions = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      insideM-xShell.aliases = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
      };

      insideM-xShell.extraConfig = mkOption {
        type = types.lines;
        default = "";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.mksh ];

      xdg.configFile."ksh/directory-aliases".text = concatStringsSep "\n"
        (mapAttrsToList (alias: directory: ''
          alias -d ${alias}="${directory}"
          alias g${alias}="cd ${directory}"
        '') cfg.directoryAliases);

      xdg.configFile."ksh/aliases".text = let
        formatAliases = aliases: mapAttrsToList (a: c: "alias ${a}=\"${c}\"") aliases;
      in
        concatStringsSep "\n"
          ((formatAliases cfg.aliases)
           ++ (mapAttrsToList (bin: aliases: concatStringsSep "\n" [
             "whence -v ${bin} >/dev/null && {"
             (concatStringsSep "\n" (formatAliases cfg.aliases))
             "}"
           ]) cfg.conditionalAliases)
           ++ [
             "whence -v emacs >/dev/null && [[ $TERM = dumb ]] && [[ $INSIDE_EMACS = [0-9.]*,comint ]] && {"
             (concatStringsSep "\n" (formatAliases cfg.insideM-xShell.aliases))
             "}"
           ]);

      xdg.configFile."ksh/functions".text = let
        formatFunctions = functions: mapAttrsToList (n: b: ''
          ${n}(){
            ${b}
          }'') functions;
      in
        concatStringsSep "\n"
          ((formatFunctions cfg.functions)
           ++ (mapAttrsToList (bin: functions: concatStringsSep "\n" [
             "whence -v ${bin} >/dev/null && {"
             (concatStringsSep "\n" (formatFunctions functions))
             "}"
           ]) cfg.conditionalFunctions)
           ++ [
             "whence -v emacs >/dev/null && [[ $TERM = dumb ]] && [[ $INSIDE_EMACS = [0-9.]*,comint ]] && {"
             (concatStringsSep "\n" (formatFunctions cfg.insideM-xShell.functions))
             "}"
           ]);

      xdg.configFile."ksh/envvars".text = concatStringsSep "\n"
        (mapAttrsToList (var: value: "export ${var}=\"${value}\"") cfg.envvars);

      xdg.configFile."ksh/vars".text = concatStringsSep "\n"
        (mapAttrsToList (var: value: "${var}=\"${value}\"") cfg.vars);

      home.file."lib/kshrc".text = let
        shellOpts = concatStringsSep " " cfg.shellOptions;
      in
        ''
        [[ "$-" != *i* ]] && return 0

        set -o ${shellOpts}

        for i in $XDG_CONFIG_HOME/ksh/{functions,envvars,vars,aliases,directory-aliases}; do
            . "$i"
        done
      ''
        + optionalString (cfg.extraConfig != "") "\n"
        + cfg.extraConfig
        + optionalString (cfg.insideM-xShell.extraConfig != "") "\n"
        + (concatStringsSep "\n" [
          "whence -v emacs >/dev/null && [[ $TERM = dumb ]] && [[ $INSIDE_EMACS = [0-9.]*,comint ]] && {"
          cfg.insideM-xShell.extraConfig
          "}"
        ]);
    };
  }
