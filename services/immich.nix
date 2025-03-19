{ config, lib, pkgs, ... }: {

	services.immich = {
		enable = true;
		openFirewall = true;
		mediaLocation = "/mnt/hdd/immich";
		environment = {
		};
		port = 2283;
		host = "0.0.0.0";
	};

}
