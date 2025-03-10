{ config, lib, pkgs, ... }: {

	services.matrix-conduit = {
		enable = true;
		settings.global = {
			server_name = "evren.gay";
			well_known = {
				client = "https://matrix.evren.gay";
			};
		};
	};

}
