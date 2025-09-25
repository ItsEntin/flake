{ config, lib, pkgs, ... }: {

	networking.hostName = "printer";

	environment.shellAliases.nrs = "sudo nixos-rebuild switch --flake ~/flake#printer --impure";

}
