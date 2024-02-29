{
  description = "retronix modules";

  outputs = _: {
    nixosModules = {
      retronix = import ./default.nix;
    };
  };
}
