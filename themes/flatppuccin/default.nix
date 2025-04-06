{ config, lib, pkgs, inputs, ...}: {

	imports = [ 
		./waybar.nix
		./sddm.nix
	];

	catppuccin = {
		enable = true;
		flavor = "mocha";
		accent = "pink";
		
		sddm.enable = false;
	};

}
