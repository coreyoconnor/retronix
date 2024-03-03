{
  description = "retronix modules";

  outputs = _: {
    nixosModules = {
      default = import ./default.nix;
    };
  };
}
