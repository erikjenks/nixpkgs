{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    vault
    pulumi-bin
    pulumictl
    terragrunt
    inputs.adamgoose.packages.${pkgs.system}.truss-cli
  ];

  programs.zsh = {
    oh-my-zsh.plugins = [
      "terraform"
      "vault"
    ];
    zplug.plugins = [{
      name = "cda0/zsh-tfenv";
    }];
  };

}
