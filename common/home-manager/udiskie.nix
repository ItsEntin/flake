{ config, lib, pkgs, ... }: {

services.udiskie = {
	enable = true;
	settings = {
		file_manager = "kitty lf";
	};
};

}
