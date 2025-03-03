{ config, lib, pkgs, ... }: {

	services.immich = {
		enable = true;
		openFirewall = true;
		port = 2283;
		host = "0.0.0.0";
	};

}
