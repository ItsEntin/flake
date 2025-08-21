{ config, lib, pkgs, ... }: {

programs.zellij = {
	enable = true;
	settings = {
		show_startup_tips = false;
		pane_frames = false;
	};
};

}
