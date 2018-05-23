{ config, pkgs, ... }:

let
  retroarchForkOverride = super: rec {
    retroarchBare = super.retroarchBare.overrideAttrs ( oldAttrs: rec {
      version = "1.8";
      name = "retroarch-bare-${version}";

      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "RetroArch";
        sha256 = "0pxnha26iy463h9f09zjh0y0snwpzid1gqlk6pvzsnxmla3sl792";
        rev = "1b7fb1530a4ef8f82713895cb182db4c86ee3a50";
      };
    });

    retroArchCores = super.retroArchCores ++ [ pkgs.libretro.beetle-psx-hw ];

    libretro = super.libretro // rec {
      beetle-psx = super.libretro.beetle-psx.overrideAttrs ( oldAttrs: {
        src = pkgs.fetchgit {
          url = "https://github.com/libretro/beetle-psx-libretro.git";
          rev = "3eac43eeef117c93139536873beb124a903ecb44";
          sha256 = "0sxmqmy9lv36xnb4q44s8n88w47kax7dlav30r4ryclx8lzrblii";
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
