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
		torrent-wg-key = {
			file = ./torrent-wg-key.age;
		};
		torrent-env = {
			file = ./torrent-env.age;
		};
		gluetun-conf = {
			file = ./gluetun-conf.age;
		};
		radarr-api-key = {
			file = ./radarr-api-key.age;
		};
		radarr-api-key-env = {
			file = ./radarr-api-key-env.age;
		};
	};

}
