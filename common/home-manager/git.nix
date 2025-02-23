{ config, pkgs, ... }: {
	
	programs.git = {
		enable = true;
		userName = "evren";
		userEmail = "evren@evren.gay";
	};

}
