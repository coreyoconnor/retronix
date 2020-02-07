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
          rev = "432feab5417e4690ad555fa2b14b34becc4acef9";
          sha256 = "0f5qvbzb3i4xbl62zzcwx5060wxqcbzfxinfj1l2rn7zcj007icq";
          # rev = "beeee12bf1d353c2fd01f0ff3a8b6d42bb68f758";
          # sha256 = "1lpqx1krgz68nnz20zh7p7jpqk2bxddhz57rjf2sgfi6yg9jd0mb";
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
          rev = "4e221df676ffc7b46d083cf2ae100131eabe5076";
          sha256 = "0rnqm4gapkng35q7gpqrf6mzki67fhd2hvcfsqkksqhwrr7gnb4y";
          fetchSubmodules = true;
        };
      });

      quicknes = super.libretro.quicknes.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/QuickNES_Core.git";
          rev = "960ae34b6bfda124daf2fa4958829572c3ff7514";
          sha256 = "0s7lcbwv6n3804ccyv32k0c10kcspf4pq1ypz7r4iidwijq63i8m";
          fetchSubmodules = true;
        };
      });

      parallel-n64 = super.libretro.parallel-n64.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/parallel-n64.git";
          rev = "68d89c77c37cb6d3da05245f75ea6f949096da96";
          sha256 = "183hrn6fd07h26w1bd4h2rbjnibkj534hliqmna5lahk9aard6xg";
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
        # enableBeetlePSX = true;
        enableBsnesMercury = true;
        enableMBGA = true;
        # enableMupen64Plus = true;
        # enableParallelN64 = true;
        # enableNestopia = true;
        enableQuickNES = true;
        enableSnes9x = true;
        # enableSnes9xNext = true;
        enableVbaM = true;
      };
    };
  };
}
