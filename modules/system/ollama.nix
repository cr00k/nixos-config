{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    # acceleration = "cuda"; > obsolete
    package = pkgs.ollama-cuda;
    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;
    models = "/mnt/data/ollama";
  };

  services.open-webui = {
    enable = true;
    port = 9090;
    openFirewall = false;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  environment.shellAliases = {
    ai-start = "sudo systemctl start ollama open-webui";
    ai-stop = "sudo systemctl stop open-webui ollama";
    ai-restart = "sudo systemctl restart ollama open-webui";
    ai-status = "systemctl status ollama open-webui";
  };
}
