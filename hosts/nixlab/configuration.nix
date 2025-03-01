{ config, lib, pkgs, ... }: {

	imports = [
		./hardware-configuration.nix
	];

	networking.hostName = "nixlab";

	boot.loader.grub.device = "nodev";
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	fileSystems."/" = {
		device = "/dev/disk/by-label/NIXROOT";
		fsType = "ext4";
	};
	fileSystems."/boot" = {
		device = "/dev/disk/by-label/NIXBOOT";
		fsType = "vfat";
	};

	networking.interfaces.enp0s31f6.ipv4.addresses = [{
		address = "10.1.1.1";
		prefixLength = 24;
	}];

	programs = {
		git.enable = true;
	};

	services = {
		openssh.enable = true;
		tailscale.enable = true;
	};

}
