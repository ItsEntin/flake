{ config, lib, pkgs, ... }: {

	virtualization = {
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
