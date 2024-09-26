{pkgs, config, ...}: {
  services.gitea-actions-runner.instances."thermex" = {
    enable = true;
    url = config.services.gitea.settings.server.ROOT_URL;
    name = "thermex";
    tokenFile = config.age.secrets.giteaActRunnerToken.path;
    labels = ["native:host"];
    hostPackages = with pkgs; [
      bash
      coreutils
      curl
      gawk
      gitMinimal
      git-lfs
      gnused
      nodejs
      wget
    ];
  };
}
