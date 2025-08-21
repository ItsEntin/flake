{ config, lib, pkgs, ... }: {

programs.zoxide = {
	enable = true;
	enableZshIntegration = true;
};

home.shellAliases = {
	cd = "z";
};

}
