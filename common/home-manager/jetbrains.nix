{ config, pkgs, ... }: {

home.packages = with pkgs.jetbrains; [
	idea
	datagrip
	rust-rover
	webstorm
];

}
