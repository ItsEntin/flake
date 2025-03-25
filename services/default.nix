{ config, lib, pkgs, ... }: {

	virtualisation = {
		# docker = {
		# 	enable = true;
		# };
		# oci-containers = {
		# 	backend = "docker";
		# };
	};

	imports = [
		./minecraft

		./cloudflared.nix

		./media.nix
		./homepage.nix
		./immich.nix
		./torrent.nix
		./pufferpanel.nix
		./gotify.nix
		./pufferpanel.nix
	];

}
