{ config, pkgs, lib, ... }:
with lib;
let
  retroarchForkOverride = super: rec {
    # retroarchBare = super.retroarchBare.overrideAttrs ( oldAttrs: rec {
    #   version = "1.7.7";
    #   name = "retroarch-bare-${version}";

     #  src = pkgs.fetchFromGitHub {
      #   owner = "libretro";
     #    repo = "RetroArch";
     #    sha256 = "1a4mpyjh0cfjf5xyfk6c3d487ypcbk3b4wx749xzsg9blaf4aj6j";
     #    rev = "5c7a5fdba0120566519bc85e42640fb2804256bb";
     #  };

      # buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXrandr ];
    # });

    retroArchCores = super.retroArchCores ++ [ pkgs.libretro.beetle-psx-hw ];

    libretro = super.libretro // rec {
      beetle-psx = super.libretro.beetle-psx.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/beetle-psx-libretro.git";
          rev = "71f2b39e5f5d0991e004fa0bd922caff7d3c1937";
          sha256 = "19j7p8hiw2ik7zazs1lqfw3f9zlfr3069fsw54gbdbmsax4yfj0v";
          fetchSubmodules = true;
        };
        buildPhase = "make HAVE_LIGHTREC=1";
      });

      beetle-psx-hw = beetle-psx.overrideAttrs ( oldAttrs: rec {
        core = "mednafen-psx-hw";
        name = "beetle-psx-hw";
        buildPhase = "make HAVE_LIGHTREC=1 HAVE_HW=1";
        buildInputs = [ pkgs.libGL pkgs.libGLU ] ++ oldAttrs.buildInputs;
        passthru = oldAttrs.passthru // { inherit core; };
      });

      bsnes-mercury = super.libretro.bsnes-mercury.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/bsnes-mercury.git";
          rev = "4a382621da58ae6da850f1bb003ace8b5f67968c";
          sha256 = "0z8psz24nx8497vpk2wya9vs451rzzw915lkw3qiq9bzlzg9r2wv";
          fetchSubmodules = true;
        };
      });

      quicknes = super.libretro.quicknes.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/QuickNES_Core.git";
          rev = "31654810b9ebf8b07f9c4dc27197af7714364ea7";
          sha256 = "15fr5a9hv7wgndb0fpmr6ws969him41jidzir2ix9xkb0mmvcm86";
          fetchSubmodules = true;
        };
      });

      parallel-n64 = super.libretro.parallel-n64.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/parallel-n64.git";
          rev = "519e642015cd6fa79047eb7ace18486f08176da8";
          sha256 = "0gkhhl4nxrqnfa19b5k9z17nra3nnhqmwdk94yxkynk6h4bayy87";
          fetchSubmodules = true;
        };
      });
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
      # packageOverrides = retroarchForkOverride;
      retroarch = {
        enableDesmume = true;
        # enableDolphin = true;
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
