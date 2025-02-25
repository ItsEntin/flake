{ config, lib, pkgs, ... }: {

	imports = lib.lists.map (x: lib.path.append ../../common/home-manager x ) [
	# Common Modules
	] ++ lib.lists.map (x: lib.path.append ./home-manager/ x ) [
	# Host Modules
		/zsh.nix
	];


}
