{ config, lib, pkgs, ... }: {

	virtualisation = {
		docker = {
			enable = true;
		};
		oci-containers = {
			backend = "docker";
		};
	};

	imports = [
		./media.nix
		./homepage.nix
		./torrent.nix
		./immich.nix
	];

}
