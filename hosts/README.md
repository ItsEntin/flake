> [!NOTE]
> This functionality is not yet fully implimented. Not all hosts follow the documented folder structure. Hosts are being updated to comply with documented behavior.

# Host-specific configuration

## Folder structure
```
.
├── host1
│   ├── default.nix
│   ├── nixos
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── modules
│   │       ├── program1.nix
│   │       ├── program2.nix
│   │       └── ...
│   └── home-manager
│       ├── home.nix
│       └── modules
│           ├── program1.nix
│           ├── program2.nix
│           └── ...
└── host2
    └── ...
```

## Explanation

Each host has its own folder within the flake for configuration specific to that machine, as well as its `hardware-configuration.nix`. Each host folder contains a `default.nix` file, a `nixos` folder, and a `home-manager` folder. The `nixos` folder containts system-level configuration, including the `configuration.nix` and `hardware-configuration.nix` files, and the `home-manager` folder contains home-manager configuration, including the `home.nix` file. 

## Host vs. Common files

While redundant configuration options are not harmful, conflicting options will fail to build. To avoid this, it is recommended that host configuration files not contain any options specified in the common configuration. Below are tables documenting which options and features are defined in the common configuration, and which must be defined in the host configurations.

### System-level `configuration.nix`

#### Host configuration

- Hostname
- State version
- `boot.loader`
- Shell alias for `sudo nixos-rebuild switch --flake /path/to/host/flake/path#config`

#### Common configuration

- Time zone
- Keyboard layout and `caps:escape`
- Zsh as default shell
- Allow unfree and broken nixpkgs
- Enable `nix-command` and `flakes` experiemental features
- `evren` user, with basic groups (`wheel`, `networkmanager`, `video`, etc.)
- Basic shell aliases (`nv`, `cl`, `q`, `nsp`, etc.)
- Enable basic programs
    - direnv
    - neovim
    - git (with user configuration)
- Enable basic services
    - openssh
    - udisks2
    - tailscale


### Home-manager `home.nix`

> [!TODO] 
> Write home-manager host vs common list
