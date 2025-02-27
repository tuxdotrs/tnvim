<h3 align="center">
  tux's neovim config
</h3>
<p align="center">
  <a href="https://wakatime.com/badge/user/012e8da9-99fe-4600-891b-bd9d8dce73d9/project/312e6509-0e4f-47b7-b5de-54985b546702" target="_blank"><img alt="home" src="https://wakatime.com/badge/user/012e8da9-99fe-4600-891b-bd9d8dce73d9/project/312e6509-0e4f-47b7-b5de-54985b546702.svg"></a>
  <a href="https://builtwithnix.org" target="_blank"><img alt="home" src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a"></a>
  <a href="https://github.com/zemmsoares/awesome-rices" target="_blank"><img alt="home" src="https://raw.githubusercontent.com/zemmsoares/awesome-rices/main/assets/awesome-rice-badge.svg"></a>
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/fc28c35f-b87a-4931-ae7f-c231a11fd1a3" alt="desktop">
</p>

## Installation

```nix
# Add to your flake inputs
tnvim = {
  url = "github:tuxdotrs/tnvim";
  inputs.nixpkgs.follows = "nixpkgs";
};

# Add this in your HomeManager config
{ inputs, ... }: {
  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = "${inputs.tnvim.packages.x86_64-linux.default}";
    };
  };
}
```

## Showcase

### Neovim

![2024-08-08_18-16](https://github.com/user-attachments/assets/f881c672-8d77-43ec-b637-df5004c7d11f)

### Floating Terminal

![2024-08-08_18-16_1](https://github.com/user-attachments/assets/3339ecf8-3264-4179-a093-337c844592a6)

### Lazygit

![2024-08-08_18-16_2](https://github.com/user-attachments/assets/6df15881-fc2b-41b1-af3b-124fe0599b94)

### Telescope

![2024-08-08_18-16_3](https://github.com/user-attachments/assets/03be05bc-8ede-4d6e-a341-2761d89b7288)
