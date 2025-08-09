{ config, libs, pkgs, ... }: {
	
	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;

	wsl = {
		defaultUser = "evren";
	};
	
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];
	nixpkgs.config = {
		allowUnfree = true;
		allowBroken = true;
	};

	environment.shellAliases = {
		nv = "nvim";
		q = "exit";
		nsp = "nix-shell -p";
	};

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

}
