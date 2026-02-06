{ config, lib, pkgs, ... }: {

programs.nushell = {
	enable = true;
	settings = {
		show_banner = false;
		table = {
			mode = "none"; # table theme
		};
	};
	environmentVariables = {
		# PROMPT_INDICATOR = " > ";
		# PROMPT_COMMAND_RIGHT = "";
	};
	shellAliases = {
		nv = "nvim";
		cl = "clear";
		q = "exit";
		f = "yazi";
		nsp = "nix-shell -p";
		nrs = "nixos-rebuild switch --flake ~/flake#thinkpad";
	};
};

}
