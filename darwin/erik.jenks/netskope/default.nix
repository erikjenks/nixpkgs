{ unstable, ... }:
let
  cabundle = unstable.cacert.override {
    extraCertificateFiles = [ ./netskope_ca.pem ];
  };
	bundlePath = "${cabundle}/etc/ssl/certs/ca-bundle.crt";
in
{
  nix = {
    extraOptions = ''
      ssl-cert-file = ${cabundle}/etc/ssl/certs/ca-bundle.crt
    '';
  };
}
