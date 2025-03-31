{ config, lib, pkgs, ... }: {

	compose.enable = true;
	compose.stacks.kitchenowl = {
		enable = true;
		requireNetwork = true;
		stack = {
			services = {
				kitchenowl = {
					image = "tombursch/kitchenowl:latest";
					restart = "unless-stopped";
					ports = [ "9050:8080" ];
					volumes = [ "kitchenowl-data:/data" ];
				};
			};
			volumes.kitchenowl-data = {};
		};
	};

}
