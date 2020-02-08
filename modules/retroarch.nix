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
          rev = "58e4fae9099a29d0ea71e7544c942978d35b181f";
          sha256 = "1144180qxjlvnlg0vflpka9vl0gs5pmdr349bm42pc5xjpmls1jr";
          fetchSubmodules = true;
        };
      });

      beetle-psx-hw = beetle-psx.overrideAttrs ( oldAttrs: rec {
        core = "mednafen-psx-hw";
        name = "beetle-psx-hw";
        HAVE_HW = true;
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
      packageOverrides = retroarchForkOverride;
      retroarch = {
        enableBeetlePCEFast = true;
        enableBeetlePSX = true;
        enableBsnesMercury = true;
        enableMBGA = true;
        # enableMupen64Plus = true;
        enableParallelN64 = true;
        # enableNestopia = true;
        enableQuickNES = true;
        enableSnes9x = true;
        # enableSnes9xNext = true;
        enableVbaM = true;
      };
    };
  };
}
