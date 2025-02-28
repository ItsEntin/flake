{ config, lib, pkgs, ... }: {

	virtualization.oci-containers.containers = {
		jellyfin = {
			container_name = "jellyfin";
			image = "jellyfin/jellyfin";
			autoStart = true;
			volumes = [
				"~/containers/jellyfin/config:/config"
				"~/containers/jellyfin/cache:/cache"
				"~/containers/jellyfin/log:/log"
			];
			ports = [
				"8096:8096"
			];
			environment = {
				JELLYFIN_LOG_DIR = "/log";
			};
		};
	};

	networking.firewall.allowedTCPPorts = [ 8096 ];

}
