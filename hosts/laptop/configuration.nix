# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

networking.hostName = "nixos";
system.stateVersion = "24.11"; # Do not change!

# Use the systemd-boot EFI boot loader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

boot.loader.grub.device = "nodev";

networking.networkmanager.enable = true;
hardware.bluetooth.enable = true;

fileSystems = {
	"/" = {
		device = "/dev/disk/by-label/NIXROOT";
		fsType = "ext4";
	};
	"/boot" = {
		device = "/dev/disk/by-label/NIXBOOT";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};
	# "/mnt/nixlab" = {
	# 	device = "evren@100.98.134.2";
	# 	fsType = "sshfs";
	# 	options = [
	# 		"allow_other" # Allow non-root access
	# 		"_netdev" # Requires network to mount
	# 		"x-systemd.automount" # Mount on demand
	# 		"debug"
	#
	# 		"reconnect"
	# 		"ServerAliveInterval=1"
	# 		"IdentityFile=/root/.ssh/id_ed25519" # SSH Key for authentication
	# 	];
	# };
};

networking.interfaces.enp0s31f6.ipv4.addresses = [{
	address = "192.168.137.3";
	prefixLength = 24;
}];

time.timeZone = "America/Toronto";
  
# Configure keymap in X11
services.xserver.xkb.layout = "us";
services.xserver.xkb.options = "caps:escape";

users.users.evren = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
	initialPassword = "password";
	packages = with pkgs; [
		javaPackages.openjfx21
		(jdk21.override { enableJavaFX = true; })
	];
};

programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;

environment.shellAliases = {
	nrs = "sudo nixos-rebuild switch --flake /home/evren/flake#nixos";
};

nixpkgs.config.allowUnfree = true;
nix.settings.experimental-features = [
	"nix-command"
	"flakes"
];

environment.systemPackages = with pkgs; [
	vim
	neovim
	kitty
	networkmanager
	neofetch
	acpi
	imv
	mpv
	vlc
	pavucontrol
	blueman
	mangohud
	javaPackages.openjfx21
	libGL
	sshfs
	(jdk21.override { enableJavaFX = true; })
	direnv
];

fonts.packages = with pkgs; [
	jetbrains-mono
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-emoji
	liberation_ttf
	ubuntu_font_family
	inter
];

programs.hyprland.enable = true;
programs.light.enable = true; # Backlight control
services.udisks2.enable = true; # USB handler
services.blueman.enable = true; # Bluetooth configuration gui
services.openssh.enable = true; # SSH Daemon

catppuccin = {
	enable = true;
	flavor = "mocha";
	accent = "pink";
};

programs.steam = {
	enable = true;
	gamescopeSession.enable = true;
};
programs.gamemode.enable = true;

programs.git = {
	enable = true;
};

services.tailscale = {
	enable = true;
};

programs.java = {
	enable = true;
	package = (pkgs.jdk21.override { enableJavaFX = true; });
};

}
