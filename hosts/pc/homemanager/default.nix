{config, lib, pkgs, inputs, ... }: {

    imports = lib.lists.map (x: ../../../common/home-manager + x) [
        /fonts.nix
        /firefox.nix
        /ghostty.nix
		/catppuccin.nix
		/nushell.nix
		/starship.nix
		/spotify.nix
    ];

	# qt.style.package = with pkgs; [darkly darkly-qt5];
	# qt.platformTheme.name = "qtct";

    home.packages = with pkgs; [
        vesktop
        qbittorrent
        protonvpn-gui
		signal-desktop
		vlc
		inputs.affinity-nix.packages.x86_64-linux.v3
		streamlink-twitch-gui-bin
		chatterino2
		kdePackages.kdenlive
		blender
		# kdePackages.qt6ct
		(catppuccin-kde.override {
			flavour = [config.catppuccin.flavor];
			accents = [config.catppuccin.accent];
		})
    ];

	home.sessionVariables = {
		# QT_QPA_PLATFORMTHEME = "qt6ct";
	};

    home.shellAliases = {
        hms = "home-manager switch --flake ~/flake#pc";
		nrs = "sudo nixos-rebuild switch --flake ~/flake#pc";
    };

	xdg.configFile = {
		"net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''{"Path":"${pkgs.google-chrome}/share/google/chrome/WidevineCdm"}'';
	};

}
