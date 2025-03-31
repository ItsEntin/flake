{ config, lib, pkgs, ... }: {

	imports = [
		./paths.nix
		./modules
	];

	time.timeZone = "America/Toronto";
	services.xserver.xkb.layout = "us";

	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowBroken = true;
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	users.users.evren = {
		isNormalUser = true;
		extraGroups = [
			"wheel"
			"networkmanager"
			"video"
			"docker"
			"minecraft"
		];
		initialPassword = "password";
	};

	environment.shellAliases = {
		nv = "nvim";
		cl = "clear";
		q = "exit";
		ll = "ls -lah";
		snv = "sudo -e nvim";
		fuck = "sudo $(fc -ln -1)";
		nsp = "nix-shell -p";
		sctl = "systemctl";
		jctl = "journalctl -u";
	};

	networking = {
		networkmanager.enable = true;
		firewall.enable = true;
	};

	environment.systemPackages = with pkgs; [
		neovim
		sshfs
	];

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
		};
		git = {
			enable = true;
			config = {
				user = {
					name = "evren";
					email = "evren@evren.gay";
				};
			};
		};
	};

	services = {
		tailscale.enable = true;
		udisks2.enable = true;
	};

}
