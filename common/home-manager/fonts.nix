{ config, pkgs, ... }: let

iosevka-custom-sans = pkgs.iosevka.override {
	privateBuildPlan = {
		family = "Iosevka Custom Sans";
		spacing = "quasi-proportional";
		serifs = "sans";
		noCvSs = false;
		exportGlyphNames = true;
	};
};

iosevka-custom-serif = pkgs.iosevka.override {
	privateBuildPlan = {
		family = "Iosevka Custom Serif";
		spacing = "quasi-proportional";
		serifs = "slab";
		noCvSs = false;
		exportGlyphNames = true;
	};
};

in{

fonts.fontconfig.enable = true;

home.packages = with pkgs; [
	jetbrains-mono
	nerd-fonts.jetbrains-mono
	iosevka
	# iosevka-custom-sans
	# iosevka-custom-serif
	nerd-fonts.iosevka
	nerd-fonts.iosevka-term
	nerd-fonts.iosevka-term-slab
	ibm-plex
];

}
