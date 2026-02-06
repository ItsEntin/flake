{ config, pkgs, ... }: {
	
	programs.git = {
		enable = true;
		settings = {
			# userName = "evren";
			# userEmail = "evren@evren.gay";
		};
	};

	home.shellAliases = {
		ga = "git add";
		gaa = "git add -A";
		gca = "git commit -a";
		gcam = "git commit -a -m";
		gpuo = "git push -u origin";
	};

}
