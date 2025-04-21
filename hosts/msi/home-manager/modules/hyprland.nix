{ config, lib, pkgs, ... }: {

	wayland.windowManager.hyprland = {
		settings = {
			monitor = lib.mkForce [
				"DP-1, preferred, 0x0, 1"
				"eDP-1, preferred, 1920x0, 1"
				"HDMI-A-1, preferred, auto, 1, transform, 1"
			];
		};
	};

}
