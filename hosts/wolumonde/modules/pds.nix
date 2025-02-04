{ config, ... }: {
  services.nginx.virtualHosts.${config.services.pds.settings.PDS_HOSTNAME} = {
    useACMEHost = "gaze.systems";
    forceSSL = true;
    # we only need to proxy /xrpc for pds to work
    # silly but i want root domain >:3
    locations."/xrpc" = {
      proxyPass = "http://localhost:${toString config.services.pds.settings.PDS_PORT}";
      # pass ws headers so we can actually proxy the ws
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
      # higher prio just to make sure
      priority = 100;
    };
  };
  # setup pds stuff
  services.pds = {
    enable = true;
    settings = {
      PDS_HOSTNAME = "gaze.systems";
      PDS_PORT = 1334;

      PDS_SERVICE_NAME = ''"gazing at the sky"'';
      PDS_LOGO_URL = "https://gaze.systems/icons/gaze.png";

      PDS_RATE_LIMITS_ENABLED = "true";
      PDS_INVITE_REQUIRED = "true";

      PDS_DID_PLC_URL="https://plc.directory";
      PDS_BSKY_APP_VIEW_URL="https://api.bsky.app";
      PDS_BSKY_APP_VIEW_DID="did:web:api.bsky.app";
      PDS_REPORT_SERVICE_URL="https://mod.bsky.app";
      PDS_REPORT_SERVICE_DID="did:plc:ar7c4by46qjdydhdevvrndac";
      PDS_CRAWLERS="https://bsky.network";
    };
    environmentFiles = [config.age.secrets.pdsConfig.path];
  };

  # virtualisation = {
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #     defaultNetwork.settings.dns_enabled = true;
  #   };
  #   oci-containers.containers = {
  #     pds = {
  #       image = "ghcr.io/bluesky-social/pds:0.4";
  #       autoStart = true;
  #       environmentFiles = [ ./pds.env config.age.secrets.pdsConfig.path ];
  #       ports = [ "1334:1334" ];
  #       volumes = [ 
  #         "/var/lib/pds:/pds"
  #       ];
  #       extraOptions = [
  #         #"--network=host"
  #         "--label=io.containers.autoupdate=registry"
  #       ];
  #     };
  #   };
  # };
  # # This is the podman auto-update systemd timer.
  # # If I start to rely on podman auto-update more, I should move this out of the PDS definition.
  # systemd.timers."podman-auto-update" = {
  #   enable = true;
  #   timerConfig = {
  #     OnCalendar = "*-*-* 4:00:00";
  #     Persistent = true;
  #   };
  #   wantedBy = [ "timers.target" ];
  # };
}
