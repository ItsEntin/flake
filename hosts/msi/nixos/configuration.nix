{ config, lib, pkgs, ... }: {

	imports = [ ./hardware-configuration.nix ];

	networking.hostName = "nixbox";
	system.stateVersion = "24.11";

	boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
	};

	networking = {
		interfaces.enp3s0.ipv4.addresses = [{
			address = "10.1.1.2";
			prefixLength = 24;
		}];
	};
	
	environment.shellAliases = {
		nrs = "sudo nixos-rebuild switch --flake /home/evren/flake#msi";
	};

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware = {
		graphics = {
			enable = true;
			extraPackages = [ pkgs.nvidia-vaapi-driver ];
		};
		nvidia = {
			open = true;
			prime = {
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:1:0:0";
			};
		};
	};

}
