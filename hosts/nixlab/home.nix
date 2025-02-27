{ config, lib, pkgs, ... }: {

	imports = lib.lists.map (x: ../../common/home-manager + x ) [
	# Common Modules
	] ++ lib.lists.map (x: ./home-manager + x ) [
	# Host Modules
		/zsh.nix
	];


}
