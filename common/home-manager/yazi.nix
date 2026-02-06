{ config, lib, pkgs, ... }: let 

	cat = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor} # mocha
		.colors;

	accent = cat.${config.catppuccin.accent};

in {

programs.yazi = {
	enable = true;
	settings = {
		mgr = {
			ratio = [1 2 2];
		};
	};
	theme = {
		mgr = {
			border_symbol = " ";
			hovered = {
				reversed = true;
				bold = true;
			};
		};
		input = let bg = cat.crust.hex; in {
			border = {
				fg = bg;
				inherit bg;
			};
			title = {
				fg = accent.hex;
				inherit bg;
			};
			value = {
				fg = cat.text.hex;
				inherit bg;
			};
			selected = {
				fg = cat.text.hex;
				inherit bg;
			};
		};
	};
};

catppuccin.yazi.enable = false;

}
