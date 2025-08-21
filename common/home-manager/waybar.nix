{ config, pkgs, lib, ... }: {

programs.waybar = {
	enable = true;
	settings = { mainBar = let 
		iconScale = "\"" + "125%" + "\"";

		c = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
			.${config.catppuccin.flavor}.colors;
		accent = c.${config.catppuccin.accent};

		toIconColor = color: ic: ''<span color="${color}" font-size=${iconScale}>${ic}</span>'';
		toIcon = i: toIconColor accent.hex i;
		icon = toIcon "{icon}";
	in {
		layer = "top";

		height = 40;
		spacing = 0;

		modules-left = [ 
			"custom/icon" 
			"clock" 
			"clock#date" 
			"custom/hrt" 
			"cpu" 
			"disk" 
			"memory" 
			"gpu"
		];
		modules-center = [ 
			"hyprland/workspaces" 
		];
		modules-right = [
			"group/traydrawer" 
			"network" 
			"pulseaudio" 
			"backlight" 
			"battery" 
			(lib.mkIf config.services.swaync.enable "custom/swaync")
		];

		reload-style-on-change = true;

		# Modules

		"custom/icon" = {
			on-click = "kitty";
			format = "󱄅";
		};

		clock = {
			format = "${toIcon ""}  {:%I:%M}";
			tooltip-format = "{:%Z - UTC%z}";
			timezone = "America/Toronto";
		};

		"clock#date" = {
			format = "${toIcon "󰃭"} {:%a, %b %d}";
			tooltip-format = "{calendar}";
		};

		"custom/hrt" = {
			format = "${toIcon ""}  {}";
			tooltip-format = "{} days since Jan 8, 2025";
			interval = 3600;
			exec = pkgs.writeShellScript "hrt" ''
				echo $((($(date +%s)-$(date +%s --date "2025-01-08"))/(3600*24)))
			'';
		};
		
		cpu = {
			format = "${toIcon ""} {usage}%";
			tooltip-format = "{avg_frequency} / {max_frequency}";
			interval = 10;
		};

		disk = {
			format = "${toIcon "󰋊"} {percentage_used}%";
			tooltip-format = "{used} / {total}";
			interval = 60;
		};

		memory = {
			format = "${toIcon ""}  {percentage}%";
			tooltip-format = "{used} / {total}";
			interval = 10;
		};

		"hyprland/workspaces" = {
			all-outputs = true;
		};

		"group/traydrawer" = {
			orientation = "inherit";
			drawer = {
				transition-left-to-right = false;
			};
			modules = [ "custom/traydrawer" "tray" ];
		};

		"custom/traydrawer" = {
			format = "${toIcon "󰇘"}";
			tooltip = false;
		};

		tray = {
			icon-size = 24;
			spacing = 8;
			show-passive-icons = true;
		};

		network = {
			interface = "w*";
			format = "${icon} {essid}";
				format-icons = [ "󰣾" "󰣴" "󰣶" "󰣸" "󰣺" ];
			format-disconnected = "${toIcon "󰣼"} No Connection";
			tooltip-format = "{ipaddr}";
			interval = 5;
		};

		pulseaudio = {
			format = "${icon} {volume}%";
			format-icons = {
				default = [ "" "" "" ];
				headphone = "󰋋";
				hdmi = "";
			};
			on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
		};

		backlight = {
			format = "${icon} {percent}%";
			format-icons = [ "󰃞" "󰃟" "󰃠" ];
			tooltip = false;
		};

		battery = {
			format = "${icon} {capacity}%";
			format-charging = "${toIconColor c.green.hex "󰂄"} {capacity}%";
			format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
			tooltip-format = "{time}";
			interval = 4;
			states = {
				"low" = 15;
			};
			format-low = "${toIconColor c.red.hex "󰂃"} {capacity}%";
		};

		"custom/swaync" = let
			client = "${config.services.swaync.package}/bin/swaync-client";
		in lib.mkIf config.services.swaync.enable {
			format = "${icon} {}";
			format-icons = {
				none = "󰂚";
				notification = "󱅫";
				dnd-none = "󰂜";
				dnd-notification = "󰅸";
			};
			exec = "${client} -swb";
			return-type = "json";
			on-click = "${client} -t -sw";
			on-click-right = "${client} -d";
		};

	};};
	
	# style = builtins.replaceStrings ["@accent"] ["@${toString config.catppuccin.accent}"] 
	# 	"${builtins.readFile ./src/waybar/style.css}";

	style = config.theme.programs.waybar;
	# 	builtins.replaceStrings ["@accent"] ["@${toString config.catppuccin.accent}"] 
	# 	/*css*/ ''
	# 	window#waybar {
	# 		background: @base;
	# 		color: @text;
	# 		font-family: 'JetBrains Mono';
	# 		font-size: 16px;
	# 	}
	#
	# 	label.module {
	# 		margin-left: 15px;
	# 		margin-right: 15px;
	# 	}
	#
	# 	#custom-icon {
	# 		font-size: 30px;
	# 		color: @accent;
	# 	}
	#
	# 	#workspaces button {
	# 		border-radius: 0px;
	# 		color: @surface1;
	# 	}
	#
	# 	#workspaces button:hover {
	# 		background: @surface0;
	# 		border: none;
	# 	}
	# 
	# 	#workspaces button.hosting-monitor {
	# 		color: @text;
	# 	}	
	#
	# 	#workspaces button.active {
	# 		background: @accent;
	# 		color: @base;
	# 		font-size: 18px;
	# 		font-weight: bold;
	# 	}
	#
	# '';

};

}
