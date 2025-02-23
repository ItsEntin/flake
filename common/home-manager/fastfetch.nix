{ config, pkgs, lib, ... }: {

programs.fastfetch = let c = 
	(lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor}.colors;
	accent = c.${config.catppuccin.accent};
in {
	enable = true;
	settings = {
		display = {
			separator = " -> ";
			key = {
				width = 13;
				type = "both";
			};
		};
		logo = {
			source = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
			type = "kitty-direct";
		};
		modules = [
			"break"
			{
				type = "title";
				format = "{user-name-colored} @ {host-name-colored}";
			}
			"break"
			{
				type = "os";
				key = "DIST ";
				format = "{name}";
				keyColor = "inverse_red";
			}
			{
				type = "host";
				key = "HOST ";
				format = "{1}";
				keyColor = "inverse_yellow";
			}
			{
				type = "cpu";
				key = "CPU ";
				format = "{1}";
				keyColor = "inverse_green";
			}
			{
				type = "wm";
				key = "WM ";
				format = "{pretty-name}";
				keyColor = "inverse_cyan";
			}
			{
				type = "terminal";
				key = "TERM ";
				format = "{pretty-name}";
				keyColor = "inverse_blue";
			}
			{
				type = "shell";
				key = "SHELL ";
				format = "{pretty-name}";
				keyColor = "inverse_magenta";
			}
			# {
			# 	type = "colors";
			# 	# symbol = "circle";
			# 	block = {
			# 		range = [0 7];
			# 	};
			# }
		];
	};
};

home.shellAliases = {
	fetch = "fastfetch";
};

}
