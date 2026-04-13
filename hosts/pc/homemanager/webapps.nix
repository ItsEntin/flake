{ config, lib, pkgs, ... }: {

xdg.desktopEntries = {
	netflix = {
		name = "Netflix";
		exec = "${pkgs.}/bin/firefox -p kiosk https://netflix.com";
	};
};

}
