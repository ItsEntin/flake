{ config, lib, pkgs, ... }: {

programs.zsh = {
	enable = true;
	dotDir = config.home.homeDirectory + "/.config/zsh";
	history.path = config.home.homeDirectory + "/.config/zsh/.zsh_history";
	autocd = true;
	shellAliases = {
		# nv = "nvim";
		# nrs = "sudo nixos-rebuild switch";
		# hms = "home-manager switch";
		# nsp = "nix-shell -p";
		# cl = "clear";
		# fuck = "sudo $(fc -ln -1)";
		# q = "exit";
		# ll = "ls -lah";
	};
	sessionVariables = {
		MANPAGER = "nvim +Man!";
	};
	initContent = /*sh*/ ''
		PS1='%~ > '
		WORDCHARS=""
		bindkey '^H' backward-kill-word
		eval "$(direnv hook zsh)"
	'';
	completionInit = /*sh*/ ''
		zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
		zstyle ':completion:*' menu select
	'';
	zprof.enable = false;
	syntaxHighlighting = {
		enable = true;
		highlighters = [
			"main"
		];
		styles = let
			c = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
				.${config.catppuccin.flavor}.colors;
			accent = c.${config.catppuccin.accent};
		in rec {
			command = "fg=${accent.hex}";
			builtin = command;
			alias = "fg=${c.mauve.hex}";
		};
	};
};
catppuccin.zsh-syntax-highlighting.enable = false;
}
