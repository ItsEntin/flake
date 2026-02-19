{ config, lib, pkgs, ... }: let
	
	icon-theme = pkgs.stdenv.mkDerivation {
		builder = "bash";

		buildPhase = ''
			cp "${pkgs.catppuccin-papirus-folders}/share" "$out"
		'';
	};

in {

	environment.systemPackages = [
		icon-theme
	];

}
