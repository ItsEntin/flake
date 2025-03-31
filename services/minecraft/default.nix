{ config, lib, pkgs, inputs, ... }: {

	imports = [ 
		inputs.nix-minecraft.nixosModules.minecraft-servers 

		./dtbylg.nix
		./wife.nix
	];
	nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

	services.minecraft-servers = {
		enable = true;
		eula = true;
		dataDir = "/mnt/hdd/minecraft";
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
		script = pkgs.writeShellScriptBin "mc-backup.sh" ''
			
		'';
	in {
		serviceConfig = {
			Type = "oneshot";
		};
		script = "${script}";
	};

}
