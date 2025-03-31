{ config, lib, pkgs, ... }: {

	imports = lib.lists.map (x: ../../common/home-manager + x ) [
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
		/swaync.nix
		# /spotify.nix
	] ++ lib.lists.map (x: ./home-manager + x ) [
	# Host Modules
	];

	home.packages = with pkgs; [
		swww
		obsidian
		jellyfin-media-player
	];

	home.shellAliases = {
		hms = "home-manager switch --flake ~/flake#nixos";
	}
;	

}
