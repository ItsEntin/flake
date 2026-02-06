{ config, pkgs, ... }: {

qt = rec {
	enable = true;
	style = {
		name = "kvantum";
	};
	qt6ctSettings = {
		Appearance = {
			style = "kvantum";
			icon_theme = "Whitesur-dark";
		};
	};
	qt5ctSettings = qt6ctSettings;
	platformTheme.name = "kvantum";
};

home.packages = [ pkgs.libsForQt5.qtstyleplugin-kvantum ];

}
