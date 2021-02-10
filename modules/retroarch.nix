{ config, pkgs, lib, ... }:
with lib;
let
  retroarchForkOverride = super:
    let fetchRetro = { repo, rev, sha256 }:
      super.fetchgit {
        inherit rev sha256;
        url = "https://github.com/libretro/${repo}.git";
        fetchSubmodules = true;
      };
    in rec {
      libretro = super.libretro // rec {
        ppsspp = super.libretro.ppsspp.override {
          src = super.fetchgit {
            url = "https://github.com/hrydgard/ppsspp";
            rev = "7095115d476fdc9a970259c46953ed188343fc73";
            sha256 = "158xmx2kw9ips25hmy87x5an4k1w3ywvn64r1m3g9yxi49facb7z";
          };
        };

        dolphin = super.libretro.dolphin.override {
          src = fetchRetro {
            repo = "dolphin";
            rev = "2aa63c671241a8ea8502b654bb9c808fbbf6ce0b";
            sha256 = "1dy2yj1k7jcay7z9ann0sqfh7d25mqnzmd22yqvg2z5xq5wmh8g5";
          };
        };
      };
    };
in
{
  imports = [];

  config = mkIf config.retronix.enable {
    environment.systemPackages = [
      pkgs.retroarch
    ];

    nixpkgs.config = {
      packageOverrides = retroarchForkOverride;

      retroarch = {
        enableDesmume = true;
        enableDolphin = true;
        enableBeetleLynx = true;
        enableBeetlePCEFast = true;
        enableBeetlePCFX = true;
        enableBeetlePSX = true;
        enableBeetlePSXHW = true;
        enableBeetleSuperGrafx = true;
        enableBeetleSaturn = true;
        enableBeetleSaturnHW = true;
        enableBeetleSNES = true;
        enableGenesisPlusGX = true;
        enableMBGA = true;
        enableMupen64Plus = true;
        enableParallelN64 = true;
        enablePCSXRearmed = true;
        enablePCSX2 = true;
        enablePPSSPP = true;
        enableQuickNES = true;
        enableSnes9x = true;
        enableVbaM = true;
        enableYabause = true;
      };
    };
  };
}
