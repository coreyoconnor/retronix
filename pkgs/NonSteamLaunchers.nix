{ lib, fetchgit, poetry2nixPkgs }:
let
  pypkgs-build-requirements = {
    python-steamgriddb = [ "setuptools" ];
  };
  overrides = poetry2nixPkgs.defaultPoetryOverrides.extend (final: prev:
    builtins.mapAttrs (package: build-requirements:
      let required-packages = builtins.map (pkg:
          if builtins.isString pkg then builtins.getAttr pkg prev else pkg
        ) build-requirements;
      in (builtins.getAttr package prev).overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ required-packages;
      })
    ) pypkgs-build-requirements
  );
in poetry2nixPkgs.mkPoetryPackages {
  projectDir = fetchgit {
    url = "https://github.com/moraroy/NonSteamLaunchers-On-Steam-Deck.git";
    rev = "a06cbf4e35ef8a2a4a2dbabd3248c275adf20c7c";
    hash = "sha256-p+RtFfxUUZkqDLeqmALAs+WqfKlDVS4r9epHBZo3s10=";
  };

  overrides = overrides;
}
