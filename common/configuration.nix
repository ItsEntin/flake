{ config, lib, pkgs, ... }: {

time.timeZone = "America/Toronto";
services.xserver.xkb.layout = "us";

programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;

nixpkgs.config.allowUnfree = true;
nix.settings.experimental-features = [
	"nix-command"
	"flakes"
];



}
