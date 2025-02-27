{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (cells) themes;
  inherit (cells.home-manager) homeModules;
  inherit (cells.nix-darwin) darwinModules;
in {
  "erik@home" = cell.lib.mkDarwinSystem {
    username = "erikjenks";
    homeModules = with homeModules; [
      aws
      cli
      iac
      k8s
      helix
      ide-full
      wezterm
      raycast
      (themes.homeModules.catppuccin {flavor = "macchiato";})
    ];
    darwinModules = with darwinModules; [
      fonts
      preferences
      # aerospace
    ];
  };
  "erik@bridge" = cell.lib.mkDarwinSystem {
    username = "erik.jenks";
    homeModules = with homeModules; [
      aws
      cli
      iac
      k8s
      helix
      ide-full
      wezterm
      raycast
      cell.homeModules.bridge
      (themes.homeModules.catppuccin {flavor = "macchiato";})
    ];
    darwinModules = with darwinModules; [
      fonts
      preferences
      netskope
    ];
  };

  "erik@elastic" = cell.lib.mkDarwinSystem {
    username = "erik.jenks";
    homeModules = with homeModules; [
      aws
      cli
      iac
      k8s
      helix
      ide-full
      wezterm
      raycast
      cell.homeModules.elastic
      (themes.homeModules.catppuccin {flavor = "macchiato";})
    ];
    darwinModules = with darwinModules; [
      fonts
      preferences
      # netskope
    ];
  };
}
