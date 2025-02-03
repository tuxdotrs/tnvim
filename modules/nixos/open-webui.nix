{...}: {
  services.open-webui = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    environment = {
      ENABLE_OLLAMA_API = "True";
      OLLAMA_BASE_URL = "http://pc:11434";
    };
  };
}
