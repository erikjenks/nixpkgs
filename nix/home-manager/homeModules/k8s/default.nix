{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    tilt
    fluxcd
    kubectl
    helmfile
    telepresence2
    kubelogin-oidc

    (wrapHelm kubernetes-helm {
      plugins = [kubernetes-helmPlugins.helm-diff];
    })
  ];

  programs.k9s = {
    enable = true;
    package = unstable.k9s;
    settings = {
      k9s = {
        ui = {
          enableMouse = true;
        };
      };
    };
  };

}
