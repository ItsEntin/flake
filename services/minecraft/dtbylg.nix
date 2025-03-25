{ config, lib, pkgs, ... }: {

	services.minecraft-servers.servers.dtbylg = {
		enable = true;
		package = pkgs.fabricServers.fabric-1_21;
	};

}
