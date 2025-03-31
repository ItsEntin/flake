{ config, pkgs, lib, ... }: {

	services.minecraft-servers.servers.wife = {
		enable = true;
		package = pkgs.fabricServers.fabric-1_21;
		serverProperties = {
			server-port = 25566;
			motd = "I LOVE YOUUUUUU !!!!!";
			difficulty = "normal";
			enforce-secure-profile = false;
			enforce-whitelist = true;
			spawn-protection = 0;
		};
	};

}
