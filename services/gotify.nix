{ config, pkgs, lib, ... }: {

	services.gotify = {
		enable = true;
		environment = {
			GOTIFY_SERVER_PORT = 8108;
		};
	};

}
