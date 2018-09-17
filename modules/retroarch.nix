{ config, pkgs, ... }:

let
  retroarchForkOverride = super: rec {
    retroarchBare = super.retroarchBare.overrideAttrs ( oldAttrs: rec {
      version = "1.7.4";
      name = "retroarch-bare-${version}";

      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "RetroArch";
        sha256 = "0031gws78whcfc2bnlhmiwg7iw5x7kvnh5kfjswjsvwnhkc4jmaq";
        rev = "6463f7005b76b5119616c9eb725d4f4338db7383";
      };
    });

    retroArchCores = super.retroArchCores ++ [ pkgs.libretro.beetle-psx-hw ];

    libretro = super.libretro // rec {
      beetle-psx = super.libretro.beetle-psx.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/beetle-psx-libretro.git";
          rev = "380a34a48dfd09945efaa717754d8455169704a1";
          sha256 = "13iz49agkngpndrrr6a4qf3v90gpf2d3jy6prkbv4zivhwibnn95";
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
