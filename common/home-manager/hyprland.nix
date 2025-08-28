{ config, pkgs, lib, ... }: {

wayland.windowManager.hyprland = {
	enable = true;
	plugins = with pkgs.hyprlandPlugins; [
		# hyprbars
	];
	settings = {
		# exec-once = [ "waybar" "swww-daemon" "blueman-applet" ];
		exec-once = [
			"${pkgs.waybar}/bin/waybar"
			"${pkgs.swww}/bin/swww-daemon"
			"${pkgs.blueman}/bin/blueman-applet"
		];
		general = rec {
			gaps_in = 6;
			gaps_out = 12;

			border_size = 2;
			"col.active_border" = "$accent";
			"col.inactive_border" = "rgba(ffffff00)";
			
			snap = {
				enabled = true;
			};
		};

		misc = {
			disable_hyprland_logo = true;
		};

		decoration = {
			rounding = 12;
			shadow = {
				color = "$crust";
				color_inactive = "rgba(1e1e2e00)";
			};
			blur = {
				enabled = true;
				size = 6;
				passes = 2;
			};
			dim_inactive = true;
			dim_strength = 0.2;
		};

		animations = {
			animation = [
				"border, 1, 4, default"
				"fade, 1, 4, default"
			];
		};

		input = {
			touchpad = {
				natural_scroll = true;
				scroll_factor = 0.5;
			};
			kb_options = "caps:escape";
		};

			device = [
				{
					name = "logitech-g903-ls-1";
					sensitivity = -0.1;
				}
			];

		gestures = {
			workspace_swipe = true;
		};

		monitor = [
			"eDP-1, 1920x1080@60, 0x0, 1"
			"HDMI-A-2, 1920x1080@120.00, auto, 1"
			# "HDMI-A-2, 1920x1080@120.00, auto, 0.83333333333"
			", preferred, auto, 0.9"
		];

		bind = 
		let
			dispatch = "${pkgs.hyprland}/bin/hyprctl dispatch";
		in [
			"SUPER, return, exec, ${pkgs.kitty}/bin/kitty" # Open Kitty
			"SUPER, space, exec, rofi -show drun" # Open Rofi
			"SUPER, Shift_R, exec, ${pkgs.firefox}/bin/firefox" # Open Firefox
			"SUPER, q, killactive" # Kill current window
			"SUPER, esc, exit" # Exit Hyprland

			"SUPER, f, fullscreen, 0" # Fullscreen current window
			"SUPER, w, fullscreen, 1" # Maximize current window
			"SUPER, s, togglefloating" # Toggle current window floating/tiling
			"SUPER, g, togglegroup" # Toggle grouped window

			"SUPER, tab, workspace, m+1"

			",XF86MonBrightnessUp, exec, light -A 10" # Increase brightness by 10%
			",XF86MonBrightnessDown, exec, light -U 10" # Decrease brightness by 10%

			",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+" # Increase volume by 5%
			",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-" # Decrease volume by 5%
			",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle" # Toggle mute

			'',Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -d)" - | wl-copy && ${pkgs.libnotify}/bin/notify-send "Screenshot taken!" "Image copied to clipboard."''
			''Shift, Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -d)" && ${pkgs.libnotify}/bin/notify-send "Screenshot taken!" "Image saved to ~/Pictures"''

			''SUPER, c, exec, ${pkgs.writeShellScriptBin "color-picker" ''
				color = $(${pkgs.hyprpicker}/bin/hyprpicker -a)
				${pkgs.wl-clipboard}/bin/wl-copy $color
				${pkgs.libnotify}/bin/notify-send "Color copied to clipboard" $color
			''}''

			"Super Shift Alt Control, L, exec, xdg-open https://linkedin.com/"

			# "SUPER, `, exec, ${pkgs.writeShellScriptBin "toggleStackLayout" ''
			# 	echo starting
			# 	if (); then
			# 		${dispatch} 
			# 	else
			# ''}"
			
			] ++ (
			# Switch workspace / move window to workspace
			builtins.concatLists (builtins.genList (i:
			let ws = i + 1; in [
				"SUPER, code:1${toString i}, workspace, ${toString ws}"
				"SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
			] ) 9)
			) ++ (

			# Move window / focus
			builtins.concatLists (builtins.genList (i:
			let 
				dir = builtins.elemAt[ "l" "d" "u" "r" ] i;
				key = builtins.elemAt[ "h" "j" "k" "l" ] i;
			in [
				"SUPER, ${key}, movefocus, ${dir}"
				"SUPER SHIFT, ${key}, movewindow, ${dir}"
			] ) 4)
		);
		bindm = [
			"SUPER, mouse:272, movewindow"
			"SUPER, mouse:273, resizewindow"
		];
		windowrulev2 = [
			"noborder, onworkspace:w[t1]"
			"plugin:hyprbars:nobar, onworkspace:n[e:s]"
			# Float windows with class:
			] ++ lib.lists.map (class: "float, class:(.*${class}.*)") [
				"nm-connection-editor"
				"blueman"
				"pavucontrol"
			# Always full brightness:
			] ++ lib.lists.map (title: "nodim, title:(.*${title}).*") [
				"YouTube"
				"Disney"
				"Dropout"
				"Netflix"
			];

		debug = {
			# disable_scale_checks = true;
		};
		
		# plugin = {
		# 	hyprbars = {
		# 		hyprbars-button = [
		# 			"#1e1e2e,5,m,fullscreen,"
		# 		];
		# 	};
		# };
	};
};

}
