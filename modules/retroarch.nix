{ config, pkgs, ... }:

let
  retroarchForkOverride = super:
  {
    retroarchBare = super.retroarchBare.overrideAttrs ( oldAttrs:
    {
      # src = ./../dependencies/RetroArch;
    });

    libretro = super.libretro //
    {
      #parallel-n64 = super.libretro.parallel-n64.overrideAttrs ( oldAttrs:
      #{
      #  src = pkgs.fetchgit
      #  {
      #    url = "https://github.com/libretro/parallel-n64.git";
      #    rev = "ceca922a0efc0cc99b670068ded63e9add02fb98";
      #    sha256 = "1hxanzg95a5jn6sjqhgkj8d0mrv6kn07phz5h81rdpxvy6msivz3";
      #    fetchSubmodules = true;
      #  };
      #});
    };
  };
in
{
  imports = [];

  config =
  {
    environment.systemPackages = [
      pkgs.retroarch
    ];

    nixpkgs.config =
    {
      packageOverrides = retroarchForkOverride;
      retroarch =
      {
        enableBeetlePCEFast = true;
        enableBeetlePSX = true;
        enableDolphin = true;
        enableMBGA = true;
        enableMupen64Plus = true;
        enableParallelN64 = true;
        enableNestopia = true;
        enableQuickNES = true;
        enableSnes9x = true;
        enableSnes9xNext = true;
        enableVbaM = true;
      };
    };
  };
}
