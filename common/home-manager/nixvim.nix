{ config, lib, pkgs, ... }: {

programs.nixvim = {
	enable = true;
	opts = {
		number = true;
		relativenumber = true;
		scrolloff = 8;
		cursorline = true;
		tabstop = 4;
		shiftwidth = 4;
	};
	colorschemes.catppuccin.enable = true;
	plugins = {
		lsp = {
			enable = true;
			servers = {
				nixd.enable = true;
				lua_ls.enable = true;
			};
		};
		treesitter = {
			enable = true;
		};
		nvim-cmp = {
			enable = true;
		};
		lint = {
			enable = true;
		};
		lualine = {
			enable = true;
		};
		autoclose = {
			enable = true;
		};
		scrollview = {
			enable = true;
		};
		comment = {
			enable = true;
		};
	};
};

}
