{ config, pkgs, lib, ... }:

with lib;

{
  imports =
  [
    ./modules/retroarch.nix
  ];

  options =
  {
    retronix.enable = mkOption
    {
      default = false;
      example = true;
      type = with types; bool;
    };

    retronix.user = mkOption
    {
      default = "retronix";
      example = "retronix";
      type = with types; str;
    };
  };

  config =
  {
    services.xserver.desktopManager.session = [{
      name = "retronix";
      start = ''
        mkdir -p $HOME/.config/retroarch/cores
        cp --remove-destination ${pkgs.retroarch}/lib/*.so $HOME/.config/retroarch/cores/
        # pre-compiled cores will be copied read-only. This will block the auto updater,
        # though this is intentional: The precompiled ones should be those that *must*
        # be compiled via nix.
        ${pkgs.retroarch}/bin/retroarch &
        waitPID=$!
      '';
    }];
  };
}
