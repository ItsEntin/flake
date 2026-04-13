{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

	  # ../../common/system/neovim.nix
    ];

networking.hostName = "nixos";
system.stateVersion = "24.11"; # Do not change!

boot = {
	consoleLogLevel = 3;
	initrd.verbose = false;
	initrd.systemd.enable = false;
	loader = {
		systemd-boot = {
			enable = true;
			configurationLimit = 5;
		};
		efi.canTouchEfiVariables = true;
		grub.device = "nodev";
		timeout = 0;
	};
	kernelParams = [
		"quiet"
		"splash"
		"initremap=on"
		"boot.shell_on_fail"
		"udev.log_priority=3"
		"rd.systemd.show_status=auto"
	];
	plymouth = {
		enable = true;
		theme = "spinner";
		logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
		font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
	};
};
catppuccin.plymouth.enable = false;

services.displayManager.sddm = {
	enable = true;
	wayland.enable = true;
	# theme = "${pkgs.where-is-my-sddm-theme.override { variants = [ "qt5" ]; }}/share/sddm/themes/where_is_my_sddm_theme_qt5";
	theme = "where_is_my_sddm_theme";
	extraPackages = [pkgs.where-is-my-sddm-theme];
};
catppuccin.sddm.enable = false;

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
	# "/mnt/server" = {
	# 	device = "//nixlab/Storage";
	# 	fsType = "cifs";
	# 	options = let 
	# 		automountOpts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
	# 	in
	# 		["${automountOpts},credentials=${config.age.secrets.samba-creds.path}"];
	# };
};

networking.interfaces.enp0s31f6.ipv4.addresses = [{
	address = "10.1.1.3";
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
	nrs = "sudo nixos-rebuild switch --flake /home/evren/flake#thinkpad";
};

environment.localBinInPath = true;

nixpkgs.config.allowUnfree = true;
nix.settings.experimental-features = [
	"nix-command"
	"flakes"
];

powerManagement = {
	enable = true;
};
#
# services.tlp = {
# 	enable = true;
# };

environment.systemPackages = with pkgs; [
	vim
	kitty
	networkmanager
	acpi
	imv
	mpv
	vlc
	pavucontrol
	blueman
	mangohud
	sshfs
	direnv
	rustup
	cargo
	cifs-utils # for samba mounting
	cmake
	ninja
	nodejs
	# where-is-my-sddm-theme
	inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	(callPackage ./../../pkgs/helium {})
	gparted
	brightnessctl
	comma
	cowsay
];

security.polkit.enable = true;

fonts.packages = with pkgs; [
	jetbrains-mono
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-color-emoji
	liberation_ttf
	ubuntu-classic
	inter
	ibm-plex
	iosevka
];

programs.hyprland.enable = true;
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

programs.dms-shell.enable = true;
programs.java = {
	enable = true;
	package = (pkgs.jdk21.override { enableJavaFX = true; });
};

services.mysql = {
	enable = true;
	package = pkgs.mariadb;
};

services.fprintd.enable = true;

programs.niri.enable = true;

programs.appimage = {
	enable = true;
	binfmt = true;
};

}
