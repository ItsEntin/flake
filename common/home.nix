{ config, lib, pkgs, ... }: {

	home.stateVersion = "24.11"; # DO NOT CHANGE
	home.username = lib.mkDefault "evren";
	home.homeDirectory = lib.mkDefault "/home/evren";

	nixpkgs.config.allowUnfree = true;

	imports = lib.lists.map (x: ./home-manager + x ) [
		/zsh.nix
		/nvim.nix
		/lf.nix
		/bottom.nix
		/bat.nix
		/fastfetch.nix
		/git.nix
	];

	home.packages = with pkgs; [
		trash-cli
		unzip
		wl-clipboard
	];

	home.shellAliases = {
	};

	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 24;
		gtk.enable = true;
	};

	programs = {
		home-manager.enable = true;
	};

}
