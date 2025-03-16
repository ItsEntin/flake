{ config, lib, pkgs, inputs, ... }: {

	programs.spicetify = let
		spkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
	in {
		enable = true;
		theme = spkgs.themes.catppuccin;
	};

}
