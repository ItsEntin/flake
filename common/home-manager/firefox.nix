{ config, pkgs, lib, ... }: let

	cat = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor} # mocha
		.colors;

in {

	programs.firefox = {
		enable = true;
		policies = {
			DisableTelemetry = true;
			DisablePocket = true;
			DisplayBookmarksToolbar = "newtab";
		};
		profiles = {
			"Evren" = {
				name = "Evren";
				extensions.force = true;
				search = {
					default = "ddg";
					force = true;
					engines = {
						"Nix Packages" = {
							urls = [{
								template = "https://search.nixos.org/packages";
								params = [
									{ 
										name = "query"; 
										value = "{searchTerms}"; 
									}
								];
							}];
							definedAliases = [ "p." ];
							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						};
						"NixOS Wiki" = {
							urls = [{
								template = "https://wiki.nixos.org/w/index.php?title=Special:Search&search={searchTerms}";
							}];
							definedAliases = [ "w." ];
							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						};
						"NixOS Options" = {
							urls = [{
								template = "https://search.nixos.org/options";
								params = [
									{
										name = "query";
										value = "{searchTerms}";
									}
								];
							}];
							definedAliases = [ "o." ];
							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						};
						"Subreddit" = {
							urls = [{
								template = "https://old.reddit.com/r/{searchTerms}";
							}];
							definedAliases = [ "r/" ];
							icon = "https://www.reddit.com/favicon.ico";
						};
					};
				};
				settings = {
					browser.sessionstore.resume_session_once = false;
					browser.sessionstore.resume_from_crash = false;
					browser.fullscreen.autohide = false;
				};
				userChrome = /*css*/ ''
					/* transparent searchbar */
					#urlbar:not([focused]) > #urlbar-background {
						background: none !important;
						border: none !important;
					}
					/* tabs */
					.tabbrowser-tab {
						padding: 0 !important;
					}
					.tab-background {
						outline: none !important;
						border-radius: 9rem !important;
						padding: .2rem !important;
					}
					.tab-content {
						padding: !important;
						color: ${cat.text.hex} !important;
					}
					.tab-stack > * {
						padding: 8px 22px !important;;
					}
					.tab-close-button {
						border-radius: 9rem !important;
					}
				'';
				userContent = /*css*/ ''
					/* rounded new tab searchbar */
					.search-handoff-button {
						background-color: ${cat.base.hex} !important;
						border-radius: 99em !important;
						padding: 1.3rem 4rem !important;
					}
				'';
			};
		};
		policies.ExtensionSettings =
			lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair value {
				install_url = "https://addons.mozilla.org/firefox/downloads/latest/" + name + "/latest.xpi";
				installation_mode = "force_installed";
			}) {
				ublock-origin = "uBlock0@raymondhill.net";
				reddit-enhancement-suite = "jid1-xUfzOsOFlzSOXg@jetpack";
				old-reddit-redirect = "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}";
				enhancer-for-youtube = "enhancerforyoutube@maximerf.addons.mozilla.org";
				tampermonkey = "firefox@tampermonkey.net";
				stylus = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
				xkit-rewritten = "{6e710c58-36cc-49d6-b772-bfc3030fa56e}";
				control-panel-for-twitter = "{5cce4ab5-3d47-41b9-af5e-8203eea05245}";
				firefox-color = "FirefoxColor@mozilla.com";
				vimium = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
			};
	};

}
