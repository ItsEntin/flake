{ config, lib, pkgs, ... }: {

	home.stateVersion = "24.11"; # DO NOT CHANGE
	home.username = lib.mkDefault "evren";
	home.homeDirectory = lib.mkDefault "/home/evren";

	imports = lib.lists.map (x: lib.path.append ./home-manager x ) [
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

	programs = {
		home-manager.enable = true;
	};

}
