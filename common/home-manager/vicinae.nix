{ config, lib, pkgs, ... }: {
	
	programs.vicinae = {
		enable = true;
		settings = {
			theme = {
				# name = "catppuccin-mocha";
			};
			font = {
			};
			launcher_window = {
				opacity = 1;
			};
			favorites = [];
		};
	};
}
