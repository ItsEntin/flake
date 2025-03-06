{ config, lib, pkgs, ... }: {

	options.paths = lib.mkOption {
		example = { jellyfinMedia = /media; downloads = /mnt/hdd/downloads; };
		type = with lib.types; attrsOf path;
	};

}
