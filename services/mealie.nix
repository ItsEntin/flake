{ config, lib, pkgs, ... }: {

	services.mealie = {
		enable = true;
		settings = {
			THEME_DARK_PRIMARY = "#f5c2e7";
			THEME_LIGHT_PRIMARY = "#f5c2e7";
		};
	};

}
