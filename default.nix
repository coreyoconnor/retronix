{ config, pkgs, lib, ... }:

with lib;
let cfg = config.retronix;
in {
  imports =
  [
    ./modules/retroarch.nix
  ];

  options =
  {
    retronix = {
      enable = mkOption
      {
        default = false;
        example = true;
        type = with types; bool;
      };

      user = mkOption
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
    };
  };

  config = mkIf config.retronix.enable {
    services.xserver.desktopManager.session = [{
      name = "retronix";
      start = ''
        mkdir -p $HOME/.config/retroarch/cores
        cp --remove-destination ${pkgs.retroarch}/lib/*.so $HOME/.config/retroarch/cores/
        # pre-compiled cores will be copied read-only. This will block the auto updater,
        # This is intentional: The precompiled ones should be those that *must*
        # be compiled via nix.
        ${pkgs.retroarch}/bin/retroarch --verbose --nick ${cfg.nick} &
        waitPID=$!
      '';
    }];
  };
}
