{ config, lib, pkgs, ... }: 

let 
	
	cat = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor} # mocha
		.colors;

	accent = cat.${config.catppuccin.accent};

	mod=  text: "[](${cat.surface0.hex})${text}[](${cat.surface0.hex})";

in {
	programs.starship = {
		enable = true;
		settings = {
			add_newline = false;
			format = lib.concatStrings [
				" "
				"$all"
				"$directory"
				"$character"
			];
			git_branch = {
				symbol = " ";
				format = "[$symbol$branch(:$remote_branch)]($style) ";
			};
			git_status = {
				format = "([$all_status$ahead_behind]($style) )";
			};
			directory = {
				style = "inverted bold ${accent.hex}";
				# format = "[](${accent.hex})[$path ]($style)[$read_only]($style)";
				format = "[ $path ]($style)[$read_only]($style)";
				read_only = " ";
				substitutions = {
					"Downloads" = "  ";
					"Documents" = " 󰈙 ";
					"Pictures" = "  ";
					"Code" = "  ";
					"flake" = "󱄅 ";
				};
			};
			character = {
				format = "[](${accent.hex}) ";
			};
			rust = {
				symbol = " ";
			};
			nix_shell = {
				format = "via [$symbol]($style) ";
				symbol = "󱄅 ";
			};
			package = {
				symbol = "󰏗 ";
				style = "bold ${cat.peach.hex}";
			};
			nodejs.symbol = " ";
			dart.symbol = " ";
		};
	};
}
