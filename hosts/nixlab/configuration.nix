{ config, lib, pkgs, ... }: {

	system.stateVersion = "24.11";

	imports = [
		./hardware-configuration.nix
		./paths.nix
	];

	networking.hostName = "nixlab";

	boot.loader.grub.device = "nodev";
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

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

	environment = {
		shellAliases = {
			nrs = lib.mkForce "sudo nixos-rebuild switch --flake ~/flake#nixlab --impure";
		};
		variables = {
		};
	};

	programs = {
		git.enable = true;
	};

	services = {
		openssh.enable = true;
		tailscale.enable = true;
	};

}
