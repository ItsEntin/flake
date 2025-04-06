{ config, lib, pkgs, ... }: {

	environment.systemPackages = [ pkgs.where-is-my-sddm-theme ];
	services.displayManager.sddm = {
		theme = "where-is-my-sddm-theme";
	};

}
