{ config, lib, pkgs, ... }: {

	options.dockerStacks = lib.mkOption {
		description = "Docker Compose stacks";
		type = lib.types.attrsOf (
			lib.types.submodule (
				{ name, ... }: {
					options = {
						enable = lib.mkOption {
							type = lib.types.bool;
							default = false;
							description = ''
								Enable the systemd service configuration. Does not start the service at startup. To run at startup, set `startup` to `true`.
							'';
						};
						startup = lib.mkOption {
							type = lib.types.bool;
							default = false;
							description = ''
								Starts the container at startup. Can also be acheived by adding "multi-user.target" to `service.wantedBy`
							'';
						};
					};
				}
			)
		);
	};

}
