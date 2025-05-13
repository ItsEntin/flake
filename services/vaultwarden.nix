{ config, lib, pkgs, ... }: {

	services.vaultwarden = {
		enable = false;
		config = {
			rocketAddress = "0.0.0.0";
			rocketPort = 8222;

			domain = "https://vault.evren.gay";
		};
	};

}
