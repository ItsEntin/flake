{ config, lib, pkgs, ... }: {
	programs.niri = {
		enable = true;
		settings = {
			spawn-at-startup = [
				{ argv = ["${pkgs.swww}/bin/swww" "init"];}
				{ argv = ["${pkgs.vicinae}/bin/vicinae" "server"];}
			];
			outputs = {
				eDP-1 = {
					scale = 1;
				};
			};
			binds = {
				# Open apps
				"Mod+Space".action.spawn = ["${pkgs.vicinae}/bin/vicinae" "toggle"];
				"Mod+Return".action.spawn = "ghostty";
				"Mod+T".action.spawn = "kitty";
				"Mod+Shift\_R".action.spawn = "helium";
				"Mod+B".action.spawn = "helium";

				# Window management
				"Mod+Q" = {
					repeat = false;
					action.close-window = {};
				};
				"Mod+F".action.maximize-column = {};
				"Mod+Shift+F".action.fullscreen-window = {};
				"Mod+V".action.toggle-window-floating = {};

				# Misc
				"Print".action.screenshot = {};

				# Movement
				Control_R.action.toggle-overview = {};
				"Mod+h".action.focus-column-left = {};
				"Mod+l".action.focus-column-right = {};
				"Mod+j".action.focus-window-down = {};
				"Mod+k".action.focus-window-up = {};
				"Mod+Shift+h".action.move-column-left = {};
				"Mod+Shift+l".action.move-column-right = {};
				"Mod+Shift+j".action.move-window-down = {};
				"Mod+Shift+k".action.move-window-up = {};
			};
		};
	};
}
