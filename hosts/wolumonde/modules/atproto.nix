{pkgs, ...}: let
in {
  services.nginx.virtualHosts."gaze.systems" = let
    _wellKnownFile =
      pkgs.writeText "server" "did:plc:dfl62fgb7wtjj3fcbb72naae";
    wellKnownDir = pkgs.runCommand "well-known" {} ''
      mkdir -p $out
      cp ${_wellKnownFile} $out/atproto-did
  '';
  in {
    locations."/.well-known/".extraConfig = ''
      add_header content-type text/plain;
      add_header access-control-allow-origin *;
      alias ${wellKnownDir}/;
    '';
  };
  services.nginx.virtualHosts."dawn.gaze.systems" = let
    _atprotoDidFile =
      pkgs.writeText "server" "did:web:dawn.gaze.systems";
    _didFile = ../../../secrets/dawn.did;
    wellKnownDir = pkgs.runCommand "well-known" {} ''
      mkdir -p $out
      cp ${_didFile} $out/did.json
      cp ${_atprotoDidFile} $out/atproto-did
  '';
  in {
    useACMEHost = "gaze.systems";
    forceSSL = true;
    locations."/.well-known/".extraConfig = ''
      add_header content-type text/plain;
      add_header access-control-allow-origin *;
      alias ${wellKnownDir}/;
    '';
  };
}
