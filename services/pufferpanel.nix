{ config, lib, pkgs, ... }: {

	environment.systemPackages = [ pkgs.pufferpanel ];

	services.pufferpanel = {
		enable = true;
	};

}
