{config, ...}: {
  services.gitea-actions-runner.instances."thermex" = {
    url = config.services.gitea.settings.server.ROOT_URL;
    name = "thermex";
    tokenFile = config.age.secrets.giteaActRunnerToken.path;
    labels = ["native:host"];
  };
}
