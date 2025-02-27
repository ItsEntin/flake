{ config, pkgs, lib, ... }: {

programs.fastfetch = let c = 
	(lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor}.colors;
	accent = c.${config.catppuccin.accent};
in {
	enable = true;
	settings = {
		logo = {
			logo-type = "small";
		};
	};
};

}
