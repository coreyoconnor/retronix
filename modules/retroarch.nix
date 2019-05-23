{ config, pkgs, ... }:

let
  retroarchForkOverride = super: rec {
    retroarchBare = super.retroarchBare.overrideAttrs ( oldAttrs: rec {
      version = "1.7.7";
      name = "retroarch-bare-${version}";

      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "RetroArch";
        sha256 = "19zkj6ywnmmmsnr5hh17sfjyq0g53w711g6px81z3kvm4n9j48jd";
        rev = "ad7da9736aa31d7cfe3169c28b0c35a21f5da670";
      };

      buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXrandr ];
    });

    retroArchCores = super.retroArchCores ++ [ pkgs.libretro.beetle-psx-hw ];

    libretro = super.libretro // rec {
      beetle-psx = super.libretro.beetle-psx.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/beetle-psx-libretro.git";
          rev = "53591985319edc34d83a0858ad9a935b934dcf5c";
          sha256 = "1rs26l5vsfh4acck627kfrhxzrb2gcx9pwd6mfrfr2np4f5z63rr";
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
      # packageOverrides = retroarchForkOverride;
      retroarch =
      {
        enableBeetlePCEFast = true;
        enableBeetlePSX = true;
        enableBsnesMercury = true;
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
