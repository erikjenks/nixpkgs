{ unstable, ... }:
let
  cabundle = unstable.cacert.override {
    extraCertificateFiles = [ ./netskope_ca.pem ];
  };
in
{
  nix = {
    extraOptions = ''
      ssl-cert-file = ${cabundle}/etc/ssl/certs/ca-bundle.crt
    '';
  };
}
