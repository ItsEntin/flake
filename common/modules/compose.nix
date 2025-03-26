{ config, lib, pkgs, ... }: 

with lib;

let
	cfg = config.composeStacks;

	stackOptions = { name, ... }: {
		options = {

			enable = mkOption {
				description = "Allows the stack to be started with systemd. Does not run the stack at startup (see `startup`).";
				type = types.bool;
				default = false;
				example = true;
			};

			description = mkOption {
				description = "A description for the compose stack";
				type = types.string;
				default = "A docker compose stack";
			};

			startup = mkOption {
				description = "Runs the stack at system boot";
				type = types.bool;
				default = false;
				example = true;
			};

		};
	};

in {

}
