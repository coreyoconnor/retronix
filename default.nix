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
        export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:${pkgs.libpng12}/lib
        ${pkgs.retroarch}/bin/retroarch &
        waitPID=$!
      '';
    }];
  };
}
