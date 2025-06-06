{ config, pkgs, lib, ... }: {

programs.neovim = 
let
	toLua = str: "lua << EOF\n${str}\nEOF\n";

	c = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor}.colors;
	accent = c.${config.catppuccin.accent};
in
{
	enable = true;
	defaultEditor = true;

	vimAlias = true;
	viAlias = true;

	# Neovim Options
	extraLuaConfig = lib.strings.concatMapStrings (x: "\n" + x)
		(lib.attrsets.mapAttrsToList (key: value: "vim.opt." + key + "=" + 
		(if (value == true) then "true" else if (value == false) then "false" else toString value)
		) {
			number = true; # Line numbers
			relativenumber = true; # Relative line numbers
			ignorecase = true; # Case insensitive search
			smartcase = true; # Case sensitive search when capitals used
			scrolloff = 8; # Space left at top/bottom while scrolling
			tabstop = 4; # Tab width
			shiftwidth = 4; # Tab width
			wrap = false; # Wrap lines
			cursorline = true;
		});

	# Keybinds
	extraConfig = /*vim*/ ''
		nmap J 10j 
		nmap K 10k

		nmap [b :BufferLineCyclePrev<CR>
		nmap ]b :BufferLineCycleNext<CR>
		nmap T :badd<space>
		nmap Q :bd<CR>

		nmap F :Neotree<CR>

		imap <C-BS> <C-W>
	'';

	extraPackages = with pkgs; [
		nixd
		lua-language-server
		rust-analyzer
	];

	plugins = 
		lib.attrsets.mapAttrsToList (key: value: 
			{
				plugin = pkgs.vimPlugins.${toString key}; 
				config = "${toLua value}";
			}
		) 
	{
		nvim-lspconfig = /*lua*/ ''
			local lsp = require("lspconfig")
			lsp.nixd.setup ({
				settings = {
					nixd = {
						options = {
							home_manager = {
								expr = "(import <home-manager/modules> { configuration = ~/.config/home-manager/home.nix; pkgs = import <nixpkgs> {}; }).options",
							},
							nixos = {
								expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
							}
						},
					},
				},
			})
			lsp.lua_ls.setup {}
			-- for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
			-- 	vim.fn.sign_define("DiagnosticSign" .. diag, {
			-- 		text = "",
			-- 		texthl = "DiagnosticSign" .. diag,
			-- 		linehl = "",
			-- 		numhl = "DiagnosticSign" .. diag,
			-- 	})
			-- end
		'';
		trouble-nvim = /*lua*/ ''
			require("trouble").setup{}
		'';
		which-key-nvim = "";
		render-markdown-nvim = /*lua*/ ''
			require("render-markdown").setup({
				heading = {
					sign = false,
					icons = {},
				},
			});
		'';
		todo-comments-nvim = "";
		oil-nvim = /*lua*/ ''
			require"oil".setup {}
		'';
		bufferline-nvim = /*lua*/ ''
			vim.o.mousemoveevent = true
			require('bufferline').setup ({
				options = {
					always_show_bufferline = false,
					close_command = "bd %d",
					right_mouse_command = "bd %d",
					indicator = {style = "none"},
					modified_icon = "",
					close_icon = "",
					color_icons = false,
					diagnostics = "nvim_lsp",
					separator_style = {"",""},
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Browser",
							text_align = "left",
							separator = true,
						},
					},
				},
				highlights = ${  
					let 
						accentBG = ''bg = "${accent.hex}", fg = "${c.mantle.hex}",'';
					in
					/*lua*/ '' {
						buffer_selected = {
							${accentBG}
							bold = true,
							italic = true,
						},
						modified_selected = {${accentBG}},
						close_button_selected = {${accentBG} },
						warning_selected = {${accentBG}},
						hint_selected = {${accentBG}},
					},''
				}
			})
		'';
		comment-nvim = /*lua*/ ''
			require('Comment').setup()
		'';
		nvim-scrollbar = /*lua*/ ''
			require("scrollbar").setup{
				handle = {
					color = "${c.surface1.hex}",
					blend = 0;
				},
				marks = {
				},
				handlers = {
					cursor = false;
				}
			}
		'';
		indent-blankline-nvim = /*lua*/ ''
			require("ibl").setup()
		'';
		nvim-autopairs /*lua*/ = ''
			require("nvim-autopairs").setup()
		'';
		luasnip = /*lua*/ ''
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").config.setup {}
		'';
		cmp_luasnip = "";
		cmp-nvim-lsp = "";
		cmp-buffer = "";
		cmp-path = "";
		friendly-snippets = "";
		nvim-cmp = /*lua*/ ''
				local cmp = require"cmp"
				cmp.setup ({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
							vim.snippet.expand(args.body)
						end,
					},
					sources = {
						{ name = 'nvim_lsp' },
						{ name = 'luasnip' },
						-- { name = 'buffer' },
						{ name = 'path' },
						{ name = 'render-markdown' },
					},
					mapping = {
						["<Tab>"] = cmp.mapping(function(fallback)
							  -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
							  if cmp.visible() then
								local entry = cmp.get_selected_entry()
								if not entry then
								  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
								end
								cmp.confirm()
							  else
							fallback()
						  end
					end, {"i","s",}),
				}
			})
		'';
		nvim-web-devicons = "";
		neo-tree-nvim = /*lua*/ ''
			require"neo-tree".setup({
				
			})
		'';
		rustaceanvim = "";
		lualine-nvim = 
			let
				setColor = default: fallback: if (c.${default}.hex == accent.hex) then c.${fallback}.hex else c.${default}.hex;
			in
			/*lua*/ ''
			local function modified()
				if vim.bo.modified then
					return ''
				elseif vim.bo.modifiable == false or vim.bo.readonly == true then
					return ''
				end
				return ''
			end

			local catppuccin = ${
				let 
					mode = mode: color: /*lua*/ ''
						${mode} = {
							a = { fg = "${c.mantle.hex}", bg = "${color}", gui = "bold"},
							b = { fg = "${color}", bg = "${c.surface0.hex}" },
							c = { fg = "${c.text.hex}", bg = "${c.mantle.hex}" },
							y = { fg = "${color}", bg = "${c.surface0.hex}" },
							z = { fg = "${c.mantle.hex}", bg = "${color}", gui = "bold"},
						},
					'';
				in /*lua*/ ''
					{
						${mode "normal" accent.hex}
						${mode "insert" (setColor "sapphire" "teal")}
						${mode "command" (setColor "mauve" "sky")}
						${mode "visual" (setColor "red" "pink")}
					}
				''
			}

			require('lualine').setup {

				sections = {
					lualine_a = {'mode'},
					lualine_b = {{modified}},
					lualine_c = {{
						'filename',
						path = 1,
						file_status = false,
						symbols = {unnamed = 'New File'}
					}},
					lualine_x = {'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				options = {
					section_separators = "", component_separators = "",
					icons_enabled = true,
					theme = catppuccin,
				},
				extensions = { "man", "neo-tree" }

			}
		'';
		} ++ [
			{
				plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
				config = toLua /*lua*/ ''
					require("nvim-treesitter.configs").setup {
						highlight = {
							enable = true
						}
					}
				'';
			}
		];

};

catppuccin.nvim.enable = true;

}
