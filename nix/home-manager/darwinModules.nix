{
  inputs,
  cell,
}: {
  mkDarwinModule = imports: {
    username,
    unstable,
    ...
  }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "before-hm";
      extraSpecialArgs = {
        inherit inputs username unstable;
      };

      users.${username} = {
        inherit imports;
      };
    };
  };
}
