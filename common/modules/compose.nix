{ config, lib, pkgs, ... }: 

with lib;

let
	cfg = config.compose;

	stackOpts = { name, ... }: {
		options = {

			enable = mkEnableOption "the stack";

			secretFile = mkOption {
				description = "Secrets that will not be copied to the Nix Store. Should be formatted as a Systemd EnvironmentFile.";
				type = with types; nullOr path;
				default = null;
				example = "/run/secrets/stack-secrets.env";
			};

			stack = mkOption {
				description = "The stack configuration, as either a string containing a YAML value, or as a Nix attrset.";
				type = types.attrs;
				example = {
					services = {
						nginx = {
							image = "nginx";
							ports = [
								"8000:80"
							];
							volumes = [
								"./templates:/etc/nginx/templates"
							];
							environment = {
								NGINX_HOST = "example.com";
								NGINX_PORT = 80;
							};
						};
					};
				};

			};

			requireNetwork = mkOption {
				description = "Whether to wait for network connectivity before starting the stack";
				type = types.bool;
				default = false;
				example = true;
			};

		};
	};

in {

	options = {
		compose.enable = mkEnableOption "Docker Compose";
		compose.stacks = mkOption {
			description = "Docker compose stack configurations";
			type = with types; attrsOf (submodule stackOpts);
			default = {};
			example = {
				nginx = {
					enable = true;
					requireNetwork = true;
					stack = {
						services = {
							nginx = {
								image = "nginx";
								ports = [
									"8000:80"
								];
								volumes = [
									"./templates:/etc/nginx/templates"
								];
								environment = {
									NGINX_HOST = "example.com";
									NGINX_PORT = 80;
								};
							};
						};
					};
				};
			};
		};
	};

	config = let

		generateService = let 
		in name: opts: 
			nameValuePair "${name}-compose" {
				enable = true;
				description = "Docker Compose stack - ${name}";
				after = [ (mkIf opts.requireNetwork "network.target") ];
				wantedBy = [ "multi-user.target" ];
				serviceConfig = let
					composeBin = "${pkgs.docker-compose}/bin/docker-compose";
					composeFile = 
						if 
							(builtins.isString opts.stack) 
						then
							(builtins.toFile "${name}-compose.yml" (builtins.replaceStrings ["	"] [" "]) opts.stack)
						else
							(builtins.toFile "${name}-compose.json") (builtins.toJSON opts.stack)
					;
				in {
					Type = "simple";
					ExecStart = "${composeBin} -f ${composeFile} up";
					ExecStop = "${composeBin} -f ${composeFile} down";
				};
			};

	in mkIf cfg.enable {

		virtualisation.docker.enable = true;

		systemd.services = (mapAttrs' generateService cfg.stacks);
		
	};

}

