{
  description = "retroarch (plus steam) computer appliance";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    cmd-on-event = {
      url = "gitlab:coreyoconnor/cmd-on-event";
      inputs = {
        # nixpkgs.follows = "nixpkgs";
      };
    };
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = inputs @ {
    self,
    cmd-on-event,
    flake-utils,
    nixpkgs,
    poetry2nix
  }:
    {
      nixosModules = {
        default = import ./modules inputs;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
        packages = {
          NonSteamLaunchers = pkgs.callPackage ./pkgs/NonSteamLaunchers.nix {
            poetry2nixPkgs = poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
          };
        };
      }
    );
}
