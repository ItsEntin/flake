{ config, lib, pkgs, ... }: let 

	c = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${config.catppuccin.flavor}.colors;
	accent = c.${config.catppuccin.accent};

in {
	
	services.swaync = {
		enable = true;
		style = /*css*/ ''
			* {
				font-family: "JetBrains Mono Nerd Font";
				border-style: none;
				border-radius: 0;
				color: ${c.text.hex};
				box-shadow: none;
			}
			.control-center {
				margin: 0px; 

				background: ${c.base.hex};

				border-style: none none none solid;
				border-width: 5px;
				border-color: ${accent.hex};
				border-radius: 0;
			}
			.notification {
				border-radius: 0;
				background: ${c.surface0.hex};
			}
			.notification-action:hover {
				background-color: ${c.surface1.hex};
			}
			.close-button {
				background: ${c.surface0.hex};
			}
			.close-button.hover {
				background: ${c.red.hex};
			}
		'';
	};

	catppuccin.swaync.enable = false;
	
}
