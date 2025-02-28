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
		./jellyfin.nix
	];

}
