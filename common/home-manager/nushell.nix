{ config, lib, pkgs, ... }: {

programs.nushell = {
	enable = true;
	settings = {
		show_banner = false;
	};
	environmentVariables = {
		PROMPT_INDICATOR = " > ";
		PROMPT_COMMAND_RIGHT = "";
	};
};

}
