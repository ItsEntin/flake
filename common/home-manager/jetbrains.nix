{ config, pkgs, ... }: {

home.packages = with pkgs.jetbrains; [
	idea-ultimate
	datagrip
	rust-rover
	webstorm
];

}
