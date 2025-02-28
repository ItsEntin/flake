{ config, lib, pkgs, ... }: {

	services = {
		jellyfin.enable = true;
		jellyseerr.enable = true;
		radarr.enable = true;
		sonarr.enable = true;
	};

}
