{ config, lib, pkgs, ... }: {

	imports = [
		./hardware-configuration.nix
	];

	networking.hostName = "nixlab";

	boot.loader.grub.device = "nodev";

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/NIXROOT";
			fsType = "ext4";
		};
		"/boot" = {
			device = "/dev/disk/by-label/NIXBOOT";
			fsType = "vfat";
		};
		"/mnt/hdd" = {
			device = "/dev/disk/by-label/HDD";
			fsType = "ext4";
		};
	};

	networking.interfaces.enp0s31f6.ipv4.addresses = [{
		address = "10.1.1.1";
		prefixLength = 24;
	}];

	environment.shellAliases = {
		nrs = lib.mkForce "sudo nixos-rebuild switch --flake ~/flake#nixlab";
	};

	programs = {
		git.enable = true;
	};

	services = {
		openssh.enable = true;
		tailscale.enable = true;
	};

}
