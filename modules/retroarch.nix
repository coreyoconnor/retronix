{ config, pkgs, lib, ... }:
with lib;
let
  retroarchFull = pkgs.retroarchFull.override {
    inherit (pkgs.llvmPackages_15) stdenv;
  };
in
{
  imports = [];

  config = mkIf config.retronix.enable {
    environment.systemPackages = [
      pkgs.glxinfo
      retroarchFull
      pkgs.vulkan-tools
    ];
  };
}
