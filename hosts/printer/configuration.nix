{ config, lib, pkgs, ... }: {

	imports = [ ./hardware-configuration.nix ];

	networking.hostName = "printer";
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;
	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 8*1024;
	}];

	environment.shellAliases.nrs = "sudo nixos-rebuild switch --flake ~/flake#printer --impure";

}
