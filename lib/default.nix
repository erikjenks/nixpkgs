{ inputs, ... }:
let
  inherit (inputs) self home-manager devenv nixpkgs;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
  inherit (builtins) attrValues;
in
rec {

  mkHome =
    { name
    , username
    , homeDirectory
    , system
    , features ? [ ]
    }: homeManagerConfiguration {
      pkgs = outputs.packages.${system};
      modules = [
        ../home/${username}
        {
          home = {
            inherit username homeDirectory;
            stateVersion = "23.05";
          };
        }
      ];
      extraSpecialArgs = {
        inherit inputs outputs name username homeDirectory features;
        unstable = outputs.packages-unstable.${system};
      };
    };

}
