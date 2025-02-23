{ config, pkgs, ... }: {

programs.bottom = {
	enable = true;
	settings = {
		flags = {
			default_widget_type = "proc";
			group_processes = true;
			disable_advanced_kill = true;
		};
		row = [
			{
				ratio = 1;
				child = [
					{ type = "cpu"; }
				];
			}
			{
				ratio = 2;
				child = [
					{ child = [
						{ type = "mem"; }
						{ type = "network"; }
					];
					}
					{ type = "proc"; }
				];
			}
		];
	};
};

}
