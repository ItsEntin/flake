{ config, lib, pkgs, ... }: {

programs.nushell = {
	enable = true;
	settings = {
		show_banner = false;
		rm.always_trash = true;
		use_kitty_protocol = true;
		# error_style = "plain";
		footer_mode = "auto";
		table = {
			mode = "rounded"; # table theme
			header_on_separator = true;
		};
		history = {
			file_format = "sqlite";
		};
		# keybindings = [
		# 	{
		# 		name = "delete_word";
		# 		modifier = "control";
		# 		keycode = "backspace";
		# 		mode = "emacs";
		# 		# event = { send = "backspaceword"; };
		# 		event = "backspaceword";
		# 	}
		# ];
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
