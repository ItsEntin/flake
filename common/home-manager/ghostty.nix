{ config, pkgs, lib, ... }: {

programs.ghostty = {
	enable = true;
	settings = {
		confirm-close-surface = false;
		keybind = [
			"global:cmd+backquote=toggle_quick_terminal"
		];
	};
};

}
