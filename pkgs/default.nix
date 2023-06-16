# When you add custom packages, list them here
{ pkgs }: {
  enc = pkgs.callPackage ./enc { };
  truss-cli = pkgs.callPackage ./truss-cli { };
}
