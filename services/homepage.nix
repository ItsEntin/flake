{ config, lib, pkgs, ... }: {

	services.glance = {
		enable = true;
		openFirewall = true;
		settings = {
			server.port = 3000;
			server.host = "100.98.134.2";
			branding = {
				logo-url = "di:nixos";
			};
			theme = {
				  background-color = "240 21 15";
				  contrast-multiplier = 1.2;
				  primary-color = "316 72 86";
				  positive-color = "115 54 76";
				  negative-color = "347 70 65";
  			};
			pages = [
				{
					name = "Home";
					columns = [
						{
							size = "small";
							widgets = [
								{
									type = "clock";
									hour-format = "12h";
								}
								{
									type = "calendar";
									first-day-of-week = "sunday";
								}
							];
						}
						{
							size = "full";
							widgets = [
								{
									type = "server-stats";
								}
								{
									type = "split-column";
									widgets = [
										{
											type = "monitor";
											sites = [
												{
													title = "Jellyfin";
													url = "http://nixlab:8096";
													icon = "di:jellyfin";
												}
												{
													title = "Jellyseerr";
													url = "http://nixlab:5055";
													icon = "di:jellyseerr";
												}
												{
													title = "Radarr";
													url = "http://nixlab:7878";
													icon = "di:radarr";
												}
												{
													title = "Sonarr";
													url = "http://nixlab:8989";
													icon = "di:sonarr";
												}
											];
										}
										{
											type = "bookmarks";
											groups = [
												{
													title = "NixOS";
													color = "217 92 76";
													links = [
														{
															title = "NixOS Wiki";
															url = "https://wiki.nixos.org/";
															icon = "di:nixos";
														}
													];
												}
												{
													title = "Docs";
													links = [
														{
															title = "Glance";
															url = "https://github.com/glanceapp/glance/blob/main/docs/configuration.md";
															icon = "di:glance";
														}
														{
															title = "Jellyfin";
															url = "https://jellyfin.org/docs/";
															icon = "di:jellyfin";
														}
														{
															title = "Jellyseerr";
															url = "https://docs.jellyseerr.dev/";
															icon = "di:jellyseerr";
														}
														{
															title = "Radarr";
															url = "https://wiki.servarr.com/radarr";
															icon = "di:radarr";
														}
														{
															title = "Sonarr";
															url = "https://wiki.servarr.com/sonarr";
															icon = "di:sonarr";
														}
													];
												}
												{
													title = "Panels";
													color = "23 92 75";
													links = [
														{
															title = "Tailscale";
															url = "https://login.tailscale.com/admin/machines";
															icon = "di:tailscale-light";
														}
														{
															title = "Cloudflare";
															url = "https://dash.cloudflare.com/";
															icon = "di:cloudflare";
														}
													];
												}
											];
										}
									];
								}
							];
						}
						{
							size = "small";
							widgets = [
								{
									type = "weather";
									location = "Ottawa, Canada";
								}
								{
									type = "markets";
									markets = [
										{
											symbol = "CADUSD=X";
											name = "CAD to USD";
										}
									];
								}
							];
						}
					];
				}
			];
		};
	};

}
