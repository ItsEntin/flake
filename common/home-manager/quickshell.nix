{ config, lib, pkgs, ... }: {

	programs.quickshell = {
		enable = true;
		systemd.enable = true;
		# activeConfig = "default";
		# configs.default = ./quickshell;
	};

	home.packages = with pkgs; [
		gnomeExtensions.topicons-plus
	];

}
