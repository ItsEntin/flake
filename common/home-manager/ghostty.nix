{ config, pkgs, lib, ... }: {

programs.ghostty = {
	enable = true;
	settings = {
		title = ''" "'';
		window-height = 32;
		window-width = 120;
		font-family = "Iosevka";
		font-style = "Medium";
		font-feature = "ss14";
		font-size = 11;
		mouse-scroll-multiplier = 0.5;
		confirm-close-surface = false;
		keybind = [
			"global:cmd+backquote=toggle_quick_terminal"
		];
	};
};

}
