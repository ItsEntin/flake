{ config, lib, pkgs, ... }: {

	services.immich = {
		enable = true;
		openFirewall = true;
		mediaLocation = "/mnt/hdd/immich";
		environment = {
			# UPLOAD_LOCATION = /mnt/hdd/media/photos-videos
		};
		port = 2283;
		host = "0.0.0.0";
	};

}
