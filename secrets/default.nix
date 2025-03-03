{ config, lib, pkgs, inputs, ... }: {

	environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

	age.secrets = {
		cf-credentials = {
			file = ./cf-credentials.age;
			owner = "cloudflared";
			group = "cloudflared";
		};
		torrent-wg-key = {
			file = ./torrent-wg-key.age;
		};
	};

}
