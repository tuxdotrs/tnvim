{...}: {
  services = {
    rustdesk-server = {
      enable = true;
      openFirewall = true;
      signal.relayHosts = ["100.64.0.4"];
    };
  };
}
