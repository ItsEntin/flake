{ config, lib, pkgs, ... }: {

	imports = lib.lists.map (x: lib.path.append ../../common/home-manager x ) [
	# Common Modules
		/hyprland.nix
		/catppuccin.nix
		/kitty.nix
		/fonts.nix
		/firefox.nix
		/waybar.nix
		/discord.nix
		/rofi.nix
		/syncthing.nix
		/jetbrains.nix
		/mako.nix
		/gtk.nix
		/qt.nix
	] ++ lib.lists.map (x: lib.path.append ./home-manager/ x ) [
	# Host Modules
	];

}
