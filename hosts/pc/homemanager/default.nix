{config, lib, pkgs, ... }: {

    imports = lib.lists.map (x: ../../common/home-manager + x) [
        /fonts.nix
        /firefox.nix
        /ghostty.nix
    ];

    home.packages = with pkgs; [
        vesktop
        qbittorrent
        protonvpn-gui
        orca-slicer
    ];

    home.shellAliases = {
        hms = "home-manager switch --flake ~/flake#pc";
    };

}
