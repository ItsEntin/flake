{ config, lib, pkgs, ... }: {

	imports = lib.lists.map (x: ../../../common/home-manager + x) [
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
		/swaync.nix
	] ++ lib.lists.map (x: ./modules + x ) [
		/hyprland.nix
	];

	home.shellAliases = {
		hms = "home-manager switch --flake /home/evren/flake#msi";
	};

}
