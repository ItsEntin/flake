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
		./cloudflared.nix

		./media.nix
		./homepage.nix
		./immich.nix
		# ./torrent.nix
		# ./deluge.nix
		# ./wireguard.nix
		./torrent-docker.nix
	];

}
