{ config, pkgs, lib, ... }: {

programs.ghostty = {
	enable = true;
	settings = {
		title = ''" "'';
		window-height = 32;
		window-width = 120;
		font-size = 11;
		confirm-close-surface = false;
		keybind = [
			"global:cmd+backquote=toggle_quick_terminal"
		];
	};
};

}
