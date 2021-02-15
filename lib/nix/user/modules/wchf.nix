{ lib, pkgs, config, ... }:

with lib; let
  cfg = config.xsession.windowManager.wchf;
  wchf = pkgs.callPackage ../../pkgs/wchf.nix {};

  # Check whether border lists' length are equal
  checkBorder = (length cfg.config.borderWidths) == (length cfg.config.borderFocusedColors) &&
                (length cfg.config.borderFocusedColors) == (length cfg.config.borderUnfocusedColors);

  boolToString = b: if b then "true" else "false";
in
  {
    options = {
      xsession.windowManager.wchf = {
        enable = mkEnableOption "wchf";

        config.borderWidths = mkOption {
          type = types.nullOr (types.listOf types.int);
          default = null;
          description = "Width of each border";
        };

        config.borderFocusedColors = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = "Colours of focused window's border";
        };

        config.borderUnfocusedColors = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = "Colours of border for windows that aren't focused";
        };

        config.enableSloppyFocus = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to focus windows after hovering them with the cursor";
        };

        config.enableResizeHints = mkOption {
          type = types.bool;
          default = false;
          description = "Should wchf respect window resize hints?";
        };

        config.enableBorders = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to draw border around windows";
        };

        config.enableLastWindowFocusing = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to focus last window when the currently focused window is unmapped";
        };

        config.cursorPosition = mkOption {
          type = types.enum [
            "topleft" "topright"
            "bottomleft" "bottomright"
            "center"
            "left" "right"
            "bottom" "top"
          ];
          default = "center";
          description = "Where to lace the cursor when moving/resizing a window";
        };

        # config.gapWidth = mkOption {
          # type = types.int;
          # default = 0;
          # description = "Gap between the window and the edge of the monitor"
                        # + "when snapping or vertically/horizontally maximizing the window";
        # };

        config.gridGapWidth = mkOption {
          type = types.int;
          default = 0;
          description = "Gap between windows when laid in grid";
        };

        config.numberOfGroups = mkOption {
          type = types.int;
          default = 10;
          description = "Number of starting groups";
        };

        config.applySettings = mkOption {
          type = types.bool;
          default = true;
          description = "Wheter to apply settings on windows when they are set";
        };

        config.pointerModifier = mkOption {
          type = types.enum [ "alt" "super" ];
          default = "super";
          description = "Default pointer modifer";
        };

        config.extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Extra commands to run after setting wchf config";
        };
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ wchf ];
      xsession.windowManager.command = let
        cfgFile = pkgs.writeShellScript "wchfrc" (concatStringsSep "\n"
          ((map (s: "waitron wm-config ${s}") [
                        (optionalString checkBorder ("number-borders " + toString (length cfg.config.borderWidths)))
            (optionalString checkBorder ("border-width " + toString cfg.config.borderWidths))
            (optionalString checkBorder ("color-focused " + toString cfg.config.borderFocusedColors))
            (optionalString checkBorder ("color-unfocused " + toString cfg.config.borderUnfocusedColors))
            (optionalString checkBorder ("enable-borders " + boolToString cfg.config.enableBorders))

            ("enable-sloppy-focus " + boolToString cfg.config.enableSloppyFocus)
            ("enable-resize-hints " + boolToString cfg.config.enableResizeHints)
            ("enable-last-window-focusing " + boolToString cfg.config.enableLastWindowFocusing)
            ("cursor-position " + cfg.config.cursorPosition)
            # ("gap-width " + toString cfg.config.gapWidth)
            ("grid-gap-width " + toString cfg.config.gridGapWidth)
            ("groups-nr " + toString cfg.config.numberOfGroups)
            ("apply-settings " + boolToString cfg.config.applySettings)
            ("pointer-modifier " + cfg.config.pointerModifier)
          ]) ++ [ cfg.config.extraConfig ]));
      in "${wchf}/bin/wchf -c ${cfgFile}";
    };
  }
