{pkgs, ...}: let
  _wellKnownFile =
    pkgs.writeText "server" "did:plc:dfl62fgb7wtjj3fcbb72naae";
  wellKnownFile = pkgs.runCommand "well-known" {} ''
    mkdir -p $out
    cp ${_wellKnownFile} $out/atproto-did
  '';
in {
  services.nginx.virtualHosts."gaze.systems" = {
    locations."/.well-known/".extraConfig = ''
      add_header content-type text/plain;
      add_header access-control-allow-origin *;
      alias ${wellKnownFile}/;
    '';
  };
  # redirect any requests to my profile
  services.nginx.virtualHosts."bsky.gaze.systems" = {
    useACMEHost = "gaze.systems";
    forceSSL = true;
    extraConfig = ''
      location / {
        return 301 https://bsky.app/profile/gaze.systems$request_uri;
      }
    '';
  };
}
