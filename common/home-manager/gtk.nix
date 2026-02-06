{ config, pkgs, ... }: {

gtk = {
	enable = true;
	colorScheme = "dark";
	iconTheme = {
		name = "Whitesur-dark";
		package = pkgs.whitesur-icon-theme;
	};
};

catppuccin.gtk.icon.enable = false;

}
