inputs: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs) self cmd-on-event;
  cfg = config.retronix;
in {
  imports = [
    (import ./sessions.nix {inherit self;})
    (import ./pad-control.nix {inherit self cmd-on-event;})
  ];

  options = {
    retronix = {
      enable =
        mkOption
        {
          default = false;
          example = true;
          type = with types; bool;
        };

      user =
        mkOption
        {
          default = "retronix";
          example = "retronix";
          type = with types; str;
        };

      nick = mkOption {
        default = "retronix";
        example = "gamer256";
        type = with types; str;
      };

      steamLauncher =
        mkOption
        {
          default = false;
          example = true;
          type = with types; bool;
        };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cmd-on-event.packages.${system}.default
      wine
      winetricks
      glxinfo
      retroarchFull
      vulkan-tools
    ];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    services.das_watchdog.enable = true;
    services.libinput.enable = true;
    services.udev.extraRules = ''
      KERNEL=="event*", ATTRS{id/product}=="9400", ATTRS{id/vendor}=="18d1", MODE="0660", GROUP="plugdev", SYMLINK+="input/by-id/stadia-controller-$kernel"
    '';
  };
}
