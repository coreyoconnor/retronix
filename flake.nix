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
  };

  outputs = inputs @ {
    self,
    cmd-on-event,
    flake-utils,
    nixpkgs,
  }:
    {
      nixosModules = {
        default = import ./modules inputs;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = nixpkgs.legacyPackages.${system}.alejandra;
        packages = {
        };
      }
    );
}
