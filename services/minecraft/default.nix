{ config, lib, pkgs, inputs, ... }: {

	imports = [ 
		inputs.nix-minecraft.nixosModules.minecraft-servers 

		./dtbylg.nix
	];
	nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

	services.minecraft-servers = {
		enable = true;
		eula = true;
		dataDir = config.paths.minecraftServers;
		openFirewall = true;
	};

	# Allow users to access the minecraft server console
	environment.systemPackages = [(
		with import <nixpkgs> {};
		writeShellScriptBin "mccon" ''
			sudo ${pkgs.tmux}/bin/tmux -S /run/minecraft/$1.sock attach
		''
	)];

	systemd.services.mc-backup = let 
		script = '''';
	in {
		serviceConfig = {
			Type = "oneshot";
		};
		script = "${script}";
	};

}
