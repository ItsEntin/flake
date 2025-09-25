{ config, pkgs, ... }: {

catppuccin = {
	enable = true;
	flavor = "mocha";
	accent = "pink";
	
	kvantum.apply = false;
};

}
