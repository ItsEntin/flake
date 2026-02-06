{config, lib, pkgs, ... }: {

    imports = lib.lists.map (x: ../../../common/home-manager + x) [
        /fonts.nix
        /firefox.nix
        /ghostty.nix
		/catppuccin.nix
		/nushell.nix
		/starship.nix
    ];

    home.packages = with pkgs; [
        vesktop
        qbittorrent
        protonvpn-gui
        orca-slicer
		signal-desktop
		vlc
		(catppuccin-kde.override {
			flavour = [config.catppuccin.flavor];
			accents = [config.catppuccin.accent];
		})
    ];

    home.shellAliases = {
        hms = "home-manager switch --flake ~/flake#pc";
    };

}
