{ config, lib, pkgs, inputs, ... }: {

	environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

	age.secrets = {
		cf-credentials = {
			file = ./cf-credentials.age;
			owner = "cloudflared";
			group = "cloudflared";
		};
		torrent-wg-conf = {
			file = ./torrent-wg-conf.age;
		};
		radarr-api-key = {
			file = ./radarr-api-key.age;
		};
	};

}
