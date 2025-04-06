{ config, lib, pkgs, inputs, ... }: {

	imports = [ inputs.nixvim.nixosModules.nixvim ];

	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		opts = {	
			number = true;
			relativenumber = true;
			ignorecase = true;
			smartcase = true;
			scrolloff = 8;
			sidescrolloff = 8;
			tabstop = 4;
			shiftwidth = 4;
			wrap = false;
			cursorline = true;
		};
		keymaps = let
			map = mode: key: action: { inherit mode; inherit key; inherit action; };
			nmap = key: action: map "n" key action;
			imap = key: action: map "i" key action;
		in [
			nmap "J" "10j<CR>"
			nmap "K" "10k<CR>"

			imap "<C-BS>" "<C-W>"
		];
		plugins = {
			comment.enable = true;
			bufferline = {
				enable = true;
				settings = {
					options = {
						always_show_bufferline = false;
						indicator.style = "none";
						modified_icon = "";
						close_icon = "";
						color_icons = false;
						diagnostics = "nvim_lsp";
						separator_style = ["" ""];
						offsets = [
							{
								filetype = "neo-tree";
								text = "File Browser";
								text_align = "left";
								separator = true;
							}
						];
					};
				};
			};
		};
	};

}
