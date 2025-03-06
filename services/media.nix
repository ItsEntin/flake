{ config, lib, pkgs, ... }: {


	services = let
		common = {
			enable = true;
			# user = "torrent";
			group = "torrent";
		};
	in {

		jellyfin = common;
		radarr = common;
		sonarr = common;
		jellyseerr.enable = true;
		prowlarr.enable = true;
		flaresolverr.enable = true;
	};

	users.groups.torrent = {};

	# users.users.torrent = {
	# 	group = "torrent";
	# 	isNormalUser = true;
	# };

}
