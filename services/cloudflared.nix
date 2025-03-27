{ config, lib, pkgs, ... }: {

	environment.systemPackages = [ pkgs.cloudflared ];

	services.cloudflared = {
		enable = true;
		tunnels = {
			"a6b08bb3-5e27-49a6-8aeb-2fafd3372ece" = {
				credentialsFile = config.age.secrets.cf-credentials.path;
				default = "http_status:404";
				ingress = {
					# After adding a rule, run "cloudflared tunnel route dns <tunnel name> <public hostname>"
					"jellyfin.evren.gay" = "http://localhost:8096";
					"lab.evren.gay" = "http://localhost:3000";
					"photos.evren.gay" = "http://localhost:2283";
					"jellyseerr.evren.gay" = "http://localhost:5055";
					"gotify.evren.gay" = "http://localhost:8108";
					"dtbylg.mc.evren.gay" = "tcp://localhost:25565";
					"recipes.evren.gay" = "http://localhost:9050";
				};
			};
		};
	};

}
