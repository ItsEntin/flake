{ config, pkgs, lib, ... }: {

home.packages = [ pkgs.kitty ];

programs.kitty = let
		c = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
			.${config.catppuccin.flavor}.colors;
	in {
	enable = true;
	shellIntegration.mode = "no-cursor";
	settings = {
		font_family = "JetBrains Mono Nerd Font";
		font_size = 12;
		confirm_os_window_close = 0;
		cursor_shape = "underline";
		cursor_blink_interval = 0;
		cursor_underline_thickness = 1.8;
		cursor = c.text.hex;
		background_opacity = 0.85;
		# modify_font = ''
		# 	underline_thickness 150%
		# 	modify_font underline_position 1
		# '';

		modify_font = lib.strings.concatMapStrings (x: "\n" + x) (lib.mapAttrsToList (key: value: "modify_font " + key + " " + (toString value)) {
			underline_thickness = "150%";
			underline_position = 1;
		});
	};
};

}
