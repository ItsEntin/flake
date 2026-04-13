{ config, lib, pkgs, inputs, ... }: {

system.stateVersion = "25.11"; 

imports = [ ./hardware-configuration.nix ];

nix = {
	settings = {
		substituters = [
			"https://cache.nixos.org"
		];
	};
};

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

swapDevices = [{
	device = "/var/lib/swapfile";
	size = 32*1024;
}];

boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	consoleLogLevel = 3;
	initrd.verbose = false;
	kernelParams = [
		# "quiet"
		# "splash"
		# "boot.shell_on_fail"
		# "udev.log_level=3"
		# "systemd.show_status=auto"
	];
	loader = {
		timeout = 0;
		efi.canTouchEfiVariables = true;
		grub.enable = false;
		# grub = {
		# 	enable = true;
		# 	device = "nodev";
		# 	useOSProber = true;
		# 	efiSupport = true;
		# 	configurationLimit = 5;
		# 	theme = pkgs.stdenv.mkDerivation {
		# 		pname = "distro-grub-themes";
		# 		version = "3.1";
		# 			src = pkgs.fetchFromGitHub {
		# 				owner = "AdisonCavani";
		# 				repo = "distro-grub-themes";
		# 				rev = "v3.1";
		# 				hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
		# 			};
		# 		installPhase = "cp -r customize/nixos $out";
		# 	};
		# };
		systemd-boot.enable = true;
	};
	plymouth = {
		enable = false;
		theme = "spinner";
	};
};

networking.hostName = "nixos";
networking.networkmanager.enable = true;

time.timeZone = "America/Toronto";
i18n.defaultLocale = "en_CA.UTF-8";


users.users.evren = {
	isNormalUser = true;
	description = "Evren Blandford";
	extraGroups = [ "networkmanager" "wheel" "camera" "docker" ];
};

virtualisation = {
	docker.enable = true;
	waydroid = {
		enable = true;
		package = pkgs.waydroid-nftables;
	};
};

nixpkgs.config.allowUnfree = true;

environment.sessionVariables = {
	# QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
};

environment.localBinInPath = true;

environment.systemPackages = with pkgs; [
	# inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	darkly
	kdePackages.kamera
	libreoffice-qt6-fresh
	hunspell
	hunspellDicts.en_CA
	hyphenDicts.en_GB
	tailscale-systray
	protonup-qt
	kdePackages.filelight
	# winboat
	# calibre
	nodejs_22
	ungoogled-chromium
	cudatoolkit
	haruna
	prusa-slicer
	prismlauncher
	nix-index
	comma
	jetbrains.webstorm
	kdePackages.partitionmanager
	kdePackages.konversation
	bitwig-studio5
	unrar
	graphite
	bitwarden-desktop
	bitwarden-cli
	davinci-resolve
	onlyoffice-documentserver
	onlyoffice-desktopeditors
	# orca-slicer
	vscode
	(plasma-panel-colorizer.overrideAttrs (prev: {
		postInstall = "chmod 755 $out/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/tools/list_presets.sh";
	}))
	(pkgs.symlinkJoin {
		name = "freecad-wayland-fix";
		paths = [
		  pkgs.freecad-wayland
		];
		buildInputs = [ pkgs.makeWrapper ];
		postBuild = ''
		  wrapProgram $out/bin/FreeCAD \
			--prefix MESA_LOADER_DRIVER_OVERRIDE : zink \
			--prefix __EGL_VENDOR_LIBRARY_FILENAMES : ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
			--prefix __NV_PRIME_RENDER_OFFLOAD : 1 \
			--prefix __NV_PRIME_RENDER_OFFLOAD_PROVIDER : NVIDIA-G0 \
			--prefix __GLX_VENDOR_LIBRARY_NAME : nvidia \
			--prefix __VK_LAYER_NV_optimus : NVIDIA_only \
		'';
	})
	(
		pkgs.symlinkJoin {
			name = "orca-slicer-fix";
			paths = [pkgs.orca-slicer];
			buildInputs = [pkgs.makeWrapper];
			postBuild = ''
				wrapProgram $out/bin/orca-slicer \
				--set __GLX_VENDOR_LIBRARY_NAME mesa \
				--set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json \
				--set MESA_LOADER_DRIVER_OVERRIDE zink \
				--set GBM_BACKEND dri
			'';
		}
	)
	# (pkgs.orca-slicer.overrideAttrs (prev: {
	# 	preFixup = (prev.preFixup or "") + ''
	# 		gappsWrapperArgs+=(
	# 		--set __GLX_VENDOR_LIBRARY_NAME mesa
	# 		--set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
	# 		--set MESA_LOADER_DRIVER_OVERRIDE zink
	# 		--set GALLIUM_DRIVER zink
	# 		--set WEBKIT_DISABLE_DMABUF_RENDERER 1
	# 		)
	# 	'';
	# }))


	(callPackage ../../pkgs/helium {})
	(catppuccin-papirus-folders.override { accent = "pink"; })
];


hardware = {
	graphics = {
		enable = true;
		enable32Bit = true;
	};
	nvidia = {
		open = true;
		modesetting.enable = true;
	};
	nvidia-container-toolkit.enable = true;
	fancontrol = {};
};

security.rtkit.enable = true;

fonts = {
	enableDefaultPackages = true;
	packages = with pkgs; [
		jetbrains-mono
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-color-emoji
		liberation_ttf
		ubuntu-classic
		inter
		source-sans
		source-sans-pro
		garamond-libre
		eb-garamond
		# ibm-plex
	];
};

programs = {
	firefox.enable = true;
	steam = {
		enable = true;
		protontricks.enable = true;
	};
	gamemode.enable = true;
	gphoto2.enable = true;
	kdeconnect.enable = true;
	appimage = {
		enable = true;
		binfmt = true;
	};
	nix-ld = {
		enable = true;
	};
};

services = {
	pulseaudio.enable = false;
	wivrn.enable = true;
	pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};
	xserver = {
		enable = true;
		videoDrivers = [ "nvidia" ];
		xkb = {
			layout = "us";
			variant = "";
		};
	};
	# displayManager.sddm.enable = true;
	displayManager.plasma-login-manager.enable = true;
	desktopManager.plasma6.enable = true;
	printing.enable = true;
	hardware.openrgb.enable = true;
};

}
