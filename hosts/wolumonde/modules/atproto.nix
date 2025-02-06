{pkgs, lib, ...}: let
  mkFileCopy = name: file: "cp ${file} $out/${name}";
  mkWellKnownDir = files: pkgs.runCommand "well-known" {} ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkFileCopy files)}
  '';
  mkWellKnownCfg = files: {
    useACMEHost = "gaze.systems";
    forceSSL = true;
    locations."/.well-known/".extraConfig = ''
      add_header content-type text/plain;
      add_header access-control-allow-origin *;
      alias ${mkWellKnownDir files}/;
    '';
  };
  mkDidWebCfg = domain: {
    "${domain}" = mkWellKnownCfg {
      "did.json" = ../../../secrets/${domain}.did;
      "atproto-did" = pkgs.writeText "server" "did:web:${domain}";
    };
  };
in {
  services.nginx.virtualHosts = {
    "gaze.systems" = mkWellKnownCfg {
      "atproto-did" = pkgs.writeText "server" "did:plc:dfl62fgb7wtjj3fcbb72naae";
    };
  } // (mkDidWebCfg "dawn.gaze.systems")
  // (mkDidWebCfg "guestbook.gaze.systems");
}
