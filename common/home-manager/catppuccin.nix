{ config, pkgs, ... }: {

imports = [ <catppuccin/modules/home-manager> ];

catppuccin = {
	enable = true;
	flavor = "mocha";
	accent = "pink";
};

}
