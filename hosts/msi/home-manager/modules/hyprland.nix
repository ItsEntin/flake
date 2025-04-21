{ config, lib, pkgs, ... }: {

	wayland.windowManager.hyprland = {
		settings = {
			monitor = lib.mkForce [
				"DP-1, 1920x1080@170, 0x0, 1"
				"eDP-1, 1920x1080@144, 1920x0, 1"
				"HDMI-A-1, 1920x108060, -1080x0, 1, transform, 1"
			];
		};
	};

}
