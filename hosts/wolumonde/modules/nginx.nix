{inputs, ...}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  users.users.nginx.extraGroups = ["acme"];

  security.acme = {
    acceptTerms = true;
    defaults.email = (import "${inputs.self}/personal.nix").emails.primary;
    certs."gaze.systems" = {
      webroot = "/var/lib/acme/acme-challenge";
      extraDomainNames = [
        "git.gaze.systems"
        "ms.gaze.systems"
        "mq.gaze.systems"
        "couchdb.gaze.systems"
        "doc.gaze.systems"
        "pmart.gaze.systems"
        "limbus.gaze.systems"
        "bsky.gaze.systems"
      ];
    };
  };
}
