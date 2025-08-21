{ config, lib, pkgs, ... }: {

programs.nushell = {
	enable = true;
	settings = {
		prompt_command_right = "";
		prompt_indicator = " >";
	};
};

}
