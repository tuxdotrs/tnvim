{outputs, ...}: {
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
    outputs.overlays.nur
    outputs.overlays.nix-vscode-extensions
  ];
}
