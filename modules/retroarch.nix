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
            rev = "8d610a69a97a3c6197f205747d4563bad49511cd";
            sha256 = "1hrv2a4brydi3vrqm05a9cc0636jp7scy5ch6szw9m3pr645i35r";
          };
          patches = [];
        };

        dolphin = super.libretro.dolphin.override {
          src = fetchRetro {
            repo = "dolphin";
            rev = "13ad7dd33b2d9ac442de890f0caafbd1a8d46c5d";
            sha256 = "0ssyiw5yknv79chlb3am2l7i8nsyi5xgwnkfg3pkxigzbm1vp392";
          };
        };
      };
    };
in
{
  imports = [];

  config = mkIf config.retronix.enable {
    environment.systemPackages = [
      pkgs.glxinfo
      pkgs.retroarch
      pkgs.vulkan-tools
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
        # enablePlay = true;
        enablePPSSPP = true;
        enableQuickNES = true;
        enableSnes9x = true;
        enableVbaM = true;
        enableYabause = true;
      };
    };
  };
}
