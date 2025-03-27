{ config, lib, pkgs, ... }: {

	services.glance = {
		enable = true;
		openFirewall = true;
		settings = {
			server.port = 3000;
			branding = {
				# logo-url = "https://evren.gay/assets/favicon.ico";
				logo-url = "https://nixos.org/favicon.ico";
				favicon-url = "https://evren.gay/assets/favicon.ico";
				custom-footer = "made with estrogen :3";
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
									type = "weather";
									location = "Ottawa, Canada";
								}
							];
						}
					];
				}
				{
					name = "Services";
					columns = [
						{
							size = "small";
							widgets = [
								{
									type = "search";
									search-engine = "duckduckgo";
								}
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
									servers = [
										{
											name = "nixlab";
											type = "local";
											mountpoints = {
												"/" = {
													
												};
											};
										}
									];
								}
								{
									type = "split-column";
									widgets = [
										{
											type = "custom-api";
											title = "Jellyfin Stats";
											cache = "1h";
											url = "http://localhost:8096/api/Items/Counts";
											headers = {
												Authorization = "MediaBrowser Token='\${JELLYFIN_API_KEY}'";
												Accept = "application/json";
											};
											template = /*html*/ ''
												<div class="flex justify-between text-center">
													<div>
														<div class="color-highlight size-h3">{{ .JSON.Int "MovieCount" | formatNumber }}</div>
														<div class="size-h6">MOVIES</div>
													</div>
													<div>
														<div class="color-highlight size-h3">{{ .JSON.Int "SeriesCount" | formatNumber }}</div>
														<div class="size-h6">SERIES</div>
													</div>
													<div>
														<div class="color-highlight size-h3">{{ div (.JSON.Int "EpisodeCount" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
														<div class="size-h6">EPISODES</div>
													</div>
												</div>
											'';
										}
										{
											type = "custom-api";
											title = "Immich Stats";
											cache = "1h";
											url = "http://localhost:2283/api/server/statistics";
											headers = {
												x-api-key = "\${IMMICH_API_KEY}";
												Accept = "application/json";
											};
											template = /*html*/ ''
												<div class="flex justify-between text-center">
													<div>
														<div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
														<div class="size-h6">PHOTOS</div>
													</div>
													<div>
														<div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
														<div class="size-h6">VIDEOS</div>
													</div>
													<div>
														<div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
														<div class="size-h6">USAGE</div>
													</div>
												</div>
											'';
										}
									];
								}
								{
									type = "split-column";
									widgets = [
										{
											type = "monitor";
											sites = [
												{
													title = "Jellyfin";
													url = "https://jellyfin.evren.gay";
													icon = "di:jellyfin";
												}
												{
													title = "Immich";
													url = "https://photos.evren.gay/";
													icon = "di:immich";
												}
												{
													title = "Jellyseerr";
													url = "https://jellyseerr.evren.gay";
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
												{
													title = "Prowlarr";
													url = "http://nixlab:9696";
													icon = "di:prowlarr";
												}
												{
													title = "qBitTorrent";
													url = "http://nixlab:6011";
													icon = "di:qbittorrent";
												}
												{
													title = "Gotify";
													url = "http://nixlab:8108";
													icon = "di:gotify";
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
															title = "Wiki";
															url = "https://wiki.nixos.org/";
															# icon = "di:nixos";
														}
														{
															title = "Options";
															url = "https://search.nixos.org/options?channel=unstable";
															# icon = "di:nixos";
														}
														{
															title = "Packages";
															url = "https://search.nixos.org/packages?channel=unstable";
															# icon = "di:nixos";
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
														{
															title = "Gotify";
															url = "https://gotify.net/docs/index";
															icon = "di:gotify";
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
											name = "CAD to USD";
											symbol = "CADUSD=X";
											chart-link = "https://ca.finance.yahoo.com/quote/CADUSD=X/";
										}
									];
								}
								{
									# from https://gist.github.com/uykukacinca/a03598f591441dd8646e2502e99cb7c5
									type = "custom-api";
									title = "Recently Added Movies";
									cache = "5m";
									url = "http://localhost:7878/api/v3/history?eventType=3&includeMovie=true";
									headers = {
										Accept = "application.json";
										X-Api-Key = "\${RADARR_API_KEY}";
									};
									template = /*html*/ ''
										<ul class="list list-gap-14 collapsible-container" data-collapse-after="5">
										  {{ range .JSON.Array "records" }}
										  <li>
											  <div class="flex gap-10 row-reverse-on-mobile thumbnail-parent">
												  <div class="shrink-0" data-popover-type="html">
													<div data-popover-html="">
														<img src="{{ .String "movie.images.0.remoteUrl" }}" loading="lazy" alt="">
													</div>
													<img class="twitch-category-thumbnail thumbnail" src="{{ .String "movie.images.0.remoteUrl" }}" alt="{{ .String "movie.title" }}" loading="lazy">
												  </div>
												  <div class="grow min-width-0">
													  <a href="http://nixlab:7878/movie/{{ .String "movie.titleSlug" }}" class="color-highlight size-title-dynamic block text-truncate" target="_blank" rel="noreferrer">{{ .String "movie.title" }}</a>
													  <ul class="list-horizontal-text flex-nowrap text-compact">
														  <li class="shrink-0">{{ .String "movie.year" }}</li>
														  <li class="shrink-0">{{ .String "movie.ratings.imdb.value" }}</li>
													  </ul>
													  <ul class="list-horizontal-text flex-nowrap text-truncate">
														{{ range .Array "movie.genres" }}
														  <li>{{ .String "" }}</li>
														{{ end }}
													  </ul>
												  </div>
											  </div>
										  </li>
										  {{ end }}
										</ul>
									'';
								}
								# {
								# 	type = "custom-api";
								# 	title = "Immich Stats";
								# 	cache = "1h";
								# 	url = "http://localhost:2283/api/server/statistics";
								# 	headers = {
								# 		x-api-key = "\${IMMICH_API_KEY}";
								# 		Accept = "application/json";
								# 	};
								# 	template = /*html*/ ''
								# 		<div class="flex justify-between text-center">
								# 			<div>
								# 				<div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
								# 				<div class="size-h6">PHOTOS</div>
								# 			</div>
								# 			<div>
								# 				<div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
								# 				<div class="size-h6">VIDEOS</div>
								# 			</div>
								# 			<div>
								# 				<div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
								# 				<div class="size-h6">USAGE</div>
								# 			</div>
								# 		</div>
								# 	'';
								# }
							];
						}
					];
				}
			];
		};
	};

	systemd.services.glance.serviceConfig.EnvironmentFile = [ 
		config.age.secrets.radarr-api-key-env.path 
		config.age.secrets.immich-api-key-env.path
		config.age.secrets.jellyfin-api-key-env.path
	];

}
