{ config, lib, pkgs, ... }: {

	services.matrix-conduit = {
		enable = true;
		settings.global = {
			server_name = "evren.gay";
			port = "6060";
			allow_registration = true;
			registration_token = "token";
			well_known = {
				client = "https://matrix.evren.gay";
			};
		};
	};

}
