{ config, pkgs, ... }: {

programs.rofi = {
	enable = true;
	terminal = "kitty";
	font = "JetBrains Mono";
};

catppuccin.rofi.enable = true;

}
