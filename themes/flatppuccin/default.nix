{ config, lib, pkgs, inputs, ...}: {

	imports = [ 
		./waybar.nix
	];

	catppuccin = {
		enable = true;
		flavor = "mocha";
		accent = "pink";
	};

}
