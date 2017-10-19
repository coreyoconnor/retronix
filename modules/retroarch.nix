{ config, pkgs, ... }:

{
  config =
  {
    environment.systemPackages = [
      pkgs.retroarch
    ];
  };
}
