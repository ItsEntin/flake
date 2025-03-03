{ config, lib, pkgs, ... }: {

	services.cloudflared = {
		enable = true;
		tunnels = {
			"a6b08bb3-5e27-49a6-8aeb-2fafd3372ece" = {
				credentialsFile = config.age.secrets.cf-credentials.path;
				default = "http_status:404";
				ingress = {
					"jellyfin.evren.gay" = "http://localhost:8096";
				};
			};
		};
	};

}
