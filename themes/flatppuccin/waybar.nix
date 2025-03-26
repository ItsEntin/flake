{ config, lib, pkgs, ... }: {

	theme.programs.waybar = 
		builtins.replaceStrings ["@accent"] ["@${toString config.catppuccin.accent}"] 
			/*css*/ ''
				window#waybar {
					background: @base;
					color: @text;
					font-family: 'JetBrains Mono';
					font-size: 16px;
				}

				label.module {
					margin-left: 15px;
					margin-right: 15px;
				}

				#custom-icon {
					font-size: 30px;
					color: @accent;
				}

				#workspaces button {
					border-radius: 0px;
					color: @surface1;
				}

				#workspaces button:hover {
					background: @surface0;
					border: none;
				}
			
				#workspaces button.hosting-monitor {
					color: @text;
				}	

				#workspaces button.active {
					background: @accent;
					color: @base;
					font-size: 18px;
					font-weight: bold;
				}

		'';


}
