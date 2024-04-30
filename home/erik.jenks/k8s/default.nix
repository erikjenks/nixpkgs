{ pkgs, unstable, inputs, ... }: {
  home.packages = with pkgs; [
    k9s
    tilt
    fluxcd
    kube3d
    kubectl
    teleport
    kubelogin-oidc
    kubernetes-helm
    inputs.adamgoose.packages.${pkgs.system}.kubetap
    inputs.adamgoose.packages.${pkgs.system}.kubeswitch
  ] ++ (with unstable; [
    ##
  ]);

  home.file.".config/k9s/skin.yml".source = ./files/k9s-theme.yml;
  home.file.".kube/switch-config.yaml".source = ./files/switch-config.yaml;

  programs.zsh.initExtraBeforeCompInit = pkgs.lib.readFile (inputs.adamgoose.packages.${pkgs.system}.kubeswitch + /lib/switch.sh);
}
