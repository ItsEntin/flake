{ config, lib, pkgs, ... }: {

	programs.zsh = lib.mkForce {
		initExtra = /*sh*/ ''
			PS1='%~ >> '
			WORDCHARS=""
			bindkey '^H' backward-kill-word
		'';
	};

}
