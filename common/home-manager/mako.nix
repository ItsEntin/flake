{ config, pkgs, ... }: {

services.mako = {
	enable = true;
	
} // config.theme.programs.mako;

catppuccin.mako.enable = true;

}
