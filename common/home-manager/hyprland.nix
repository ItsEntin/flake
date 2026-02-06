{ config, pkgs, lib, ... }: {

wayland.windowManager.hyprland = {
	enable = true;
	plugins = with pkgs.hyprlandPlugins; [
		# hyprbars
		hypr-dynamic-cursors
		hyprexpo
	];
	settings = {
		exec-once = [
			# "${pkgs.waybar}/bin/waybar"
			"${pkgs.swww}/bin/swww-daemon"
			"${pkgs.blueman}/bin/blueman-applet"
			"${pkgs.vicinae}/bin/vicinae server"
			"${pkgs.signal-desktop}/bin/signal-desktop"
		];
		general = {
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
			# animate_mouse_windowdragging = true;
			focus_on_activate = true;
			middle_click_paste = false;
		};

		decoration = {
			border_part_of_window = false;
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
				"border, 0"
				"fade, 0"
				"windows, 1,3, easeExpo, slide"
				# "border,	1,	4,	default"
				# "fade,		1,	4,	default"

				"workspaces,1,	4,	easeExpo"
			];
			bezier = [
				"easeCubic,	0.65,	0,	0.35,	1"
				"easeExpo,	0.87,	0,	0.13,	1"
				"custom,	0.6,	0,	0.15,	1"
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
			workspace_swipe_direction_lock = false;
		};

		gesture = [
			"3, horizontal, workspace"
		];

		monitor = [
			"eDP-1,		1920x1080@60,		0x0,	1"
			"HDMI-A-2,	1920x1080@120.00,	auto,	1"
			",			preferred,			auto,	0.9"
		];

		bind = 
		let
			# dispatch = "${pkgs.hyprland}/bin/hyprctl dispatch";
			hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
		in [
			"SUPER,	return,		exec, ${pkgs.ghostty}/bin/ghostty +new-window" # Open Ghostty
			"SUPER,	space,		exec, ${pkgs.vicinae}/bin/vicinae toggle" # Open Vicinae
			"SUPER, Shift_R,	exec, zen" # Open Firefox
			"SUPER, q,			killactive" # Kill current window
			"SUPER, esc,		exit" # Exit Hyprland

			"SUPER, f,			fullscreen,		0" # Fullscreen current window
			"SUPER, w,			fullscreen,		1" # Maximize current window
			"SUPER, s,			togglefloating" # Toggle current window floating/tiling
			"SUPER, g,			togglegroup" # Toggle grouped window

			"SUPER, period,			exec, ${pkgs.vicinae}/bin/vicinae vicinae://extensions/vicinae/core/search-emojis" # emoji picker

			"SUPER, tab,		workspace,		m+1"

			",		XF86MonBrightnessUp,	exec,	light -A 10" # Increase brightness by 10%
			",		XF86MonBrightnessDown,	exec,	light -U 10" # Decrease brightness by 10%

			",		XF86AudioRaiseVolume,	exec,	wpctl set-volume @DEFAULT_SINK@ 5%+" # Increase volume by 5%
			",		XF86AudioLowerVolume,	exec,	wpctl set-volume @DEFAULT_SINK@ 5%-" # Decrease volume by 5%
			",		XF86AudioMute,			exec,	wpctl set-mute @DEFAULT_SINK@ toggle" # Toggle mute

			# '',Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -d)" - | wl-copy && ${pkgs.libnotify}/bin/notify-send "Screenshot taken!" "Image copied to clipboard."''
			# ''Shift, Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -d)" && ${pkgs.libnotify}/bin/notify-send "Screenshot taken!" "Image saved to ~/Pictures"''

			",		Print,		exec,	${hyprshot} -m region"

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
		windowrule = [

			{
				name = "solo-no-border";
				"match:workspace" = "w[t1]";
				border_color = "transparent";
			}

			# Float windows with class:
			] ++ lib.lists.map (class: {
				name = "float-" + class;
				"match:class" = class; 
				float = true;
			}) [
			"blueman"
			"nm-connection-editor"
			"overskride"
			"pavucontrol"

			# Always full brightness:
			] ++ lib.lists.map (title: {
				name = "nodim-" + title;
				"match:title" = ".*${title}.*";
				no_dim = true;
			}) [
			"YouTube"
			"Disney"
			"Dropout"
			"Netflix"
		];

		layerrule = [
			{
				name = "vicinae-blur";
				"match:namespace" = "vicinae";
				blur = "on";
				ignore_alpha = 0;
				dim_around = true;
			}
			# "blur, ignore_alpha 0, match:namespace vicinae"
		];

		debug = {
			# disable_scale_checks = true;
		};
		
		plugin = {
			hyprbars = {
				bar_height = 24;
				bar_color = "$mantle";
				"col.text" = "$text";
				bar_text_font = "JetBrains Mono Nerd Font";
				bar_precedence_over_border = true;
				hyprbars-button = [
					"$surface0,18,,hyprctl dispatch closewindow,$text"
					"$surface0,18,󰖯,hyprctl dispatch fullscreen 1,$text"
				];
			};
			dynamic-cursors = {
				enabled = true;
				mode = "tilt";
				shake = {
					enabled = false;
				};
			};
			hyprexpo = {
				gap_size = 12;
				skip_empty = true;
				hyprexpo-gesture = [
					"3, up, expo"
				];
			};
		};
	};
};

home.sessionVariables = {
	HYPRSHOT_DIR = "Pictures/Screenshots/";
};

}
