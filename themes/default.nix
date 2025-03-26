{ config, lib, pkgs, ... }: {

	imports = [./flatppuccin];

	options.theme = {
		programs = lib.mkOption {
			type = lib.types.attrs;
		};
	};

}
