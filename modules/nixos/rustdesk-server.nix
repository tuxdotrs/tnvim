{...}: {
  services = {
    rustdesk-server = {
      enable = true;
      openFirewall = true;
      signal.relayHosts = ["156.67.105.203"];
    };
  };
}
