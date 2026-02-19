{ config, lib, pkgs, inputs, ... }: {

system.stateVersion = "25.11"; 

imports = [ 
	./hardware-configuration.nix
	
	# ./system/kdetheme.nix
];

fileSystems = {
	"/mnt/sata" = {
		device = "/dev/disk/by-uuid/AA5684245683EF7F";
		fsType = "ntfs";
		options = [
			"nofail"
			"rw"
			"exec"
			"users"
			"uid=1000"
			"gid=1000"
		];
	};
	"/mnt/windows" = {
		device = "/dev/disk/by-uuid/A0FC70B4FC7085F6";
		fsType = "ntfs";
		options = [
			"nofail"
			"rw"
			"exec"
			"users"
			"gid=1000"
		];
	};
};

boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	consoleLogLevel = 3;
	initrd.verbose = false;
	kernelParams = [
		"quiet"
		"splash"
		"boot.shell_on_fail"
		"udev.log_level=3"
		"systemd.show_status=auto"
	];
	loader = {
		timeout = 0;
		efi.canTouchEfiVariables = true;
		grub = {
			enable = true;
			device = "nodev";
			useOSProber = true;
			efiSupport = true;
			configurationLimit = 5;
			theme = pkgs.stdenv.mkDerivation {
				pname = "distro-grub-themes";
				version = "3.1";
					src = pkgs.fetchFromGitHub {
						owner = "AdisonCavani";
						repo = "distro-grub-themes";
						rev = "v3.1";
						hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
					};
				installPhase = "cp -r customize/nixos $out";
			};
		};
	};
	plymouth = {
		enable = true;
		theme = "spinner";
	};
};

networking.hostName = "nixos";
networking.networkmanager.enable = true;

time.timeZone = "America/Toronto";
i18n.defaultLocale = "en_CA.UTF-8";

services = {
	xserver = {
		enable = true;
		xkb = {
			layout = "us";
			variant = "";
		};
	};
	displayManager.sddm.enable = true;
	desktopManager.plasma6.enable = true;
	printing.enable = true;
	ollama = {
		enable = true;
		package = pkgs.ollama-cuda;
	};
	open-webui.enable = true;
};


# Enable sound with pipewire.
services.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	# If you want to use JACK applications, uncomment this
	#jack.enable = true;

};

users.users.evren = {
	isNormalUser = true;
	description = "Evren Blandford";
	extraGroups = [ "networkmanager" "wheel" "camera" "docker" ];
};

virtualisation.docker.enable = true;

nixpkgs.config.allowUnfree = true;

environment.sessionVariables = {
	# QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
};

environment.localBinInPath = true;

environment.systemPackages = with pkgs; [
	inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	darkly
	kdePackages.kamera
	libreoffice-qt6-fresh
	hunspell
	hunspellDicts.en_CA
	hyphenDicts.en_GB
	tailscale-systray
	protonup-qt
	kdePackages.filelight
	winboat
	calibre
	nodejs_22
	ungoogled-chromium
	cudatoolkit
	haruna
	(catppuccin-papirus-folders.override { accent = "pink"; })
];


hardware.graphics.enable = true;
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia-container-toolkit.enable = true;
hardware.nvidia.open = true;

# hardware.fancontrol.enable = true;

fonts.packages = with pkgs; [
	jetbrains-mono
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-color-emoji
	liberation_ttf
	ubuntu-classic
	inter
	source-sans
	source-sans-pro
	# ibm-plex
];

programs = {
	firefox.enable = true;
	steam.enable = true;
	gamemode.enable = true;
	gphoto2.enable = true;
	kdeconnect.enable = true;
	appimage = {
		enable = true;
		binfmt = true;
	};
};

}
