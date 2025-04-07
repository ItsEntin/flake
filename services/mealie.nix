{ config, lib, pkgs, ... }: {

	services.mealie = {
		enable = false;
		settings = {
			THEME_DARK_PRIMARY = "#f5c2e7";
			THEME_LIGHT_PRIMARY = "#f5c2e7";
		};
	};
	services.tandoor-recipes = {
		enable = true;
	};

}
