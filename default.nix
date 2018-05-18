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
        ${pkgs.retroarch}/bin/retroarch &
        waitPID=$!
      '';
    }];
  };
}
