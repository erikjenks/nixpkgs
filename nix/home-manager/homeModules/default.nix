{
  inputs,
  cell,
}: let
  inherit (inputs.cells.erik.lib) importModules;
in
  importModules ./.
