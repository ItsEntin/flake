# my system configuration flake :3

modules are divided into **common** modules, which are shared between hosts, and **host** modules, which contain overrides for specific hosts. system configuration can be applied with `sudo nixos-rebuild switch --flake /path/to/flake.nix`, and home-manager config can be applied with `home-manager switch --flake /path/to/flake.nix`. 
