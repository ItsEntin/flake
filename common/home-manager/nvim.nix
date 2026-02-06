{ config, lib, pkgs, ... }: 

let 
	
	cat = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
		.${config.catppuccin.flavor} # mocha
		.colors;

	accent = cat.${config.catppuccin.accent};

in {

programs.nixvim = {
	enable = true;
	opts = {
		number = true; # number line
		# relativenumber = true; # relative line numbers
		scrolloff = 8; # space left at top/bottom when scrolling
		cursorline = true; # highlight active line
		wrap = false;  #wrap lines at edge
		cmdheight = 0; # hide command line unless needed
		clipboard = "unnamedplus"; # use system clipboard 
		signcolumn = "no"; # hide diagnostic signs in gutter
		colorcolumn = "100";
		mousemoveevent = true;
		ignorecase = true;
		smartcase = true;

		tabstop = 4; # tab width
		softtabstop = 4; # tab width
		shiftwidth = 4; # tab width
		smartindent = false;

		splitbelow = true; # open hsplits below current
		splitright = true; # open vsplits to right of current

		foldmethod = "expr"; # fold based on ts expr
		foldexpr = "v:lua.vim.treesitter.foldexpr()";
		foldlevelstart = 99; # open all folds by default

		pumheight = 15; # cmp menu max height
	};
	globals = {
		mapleader = " ";
	};
	highlightOverride = {
		ColorColumn.link = "LineNr";
	};
	colorschemes.catppuccin = {
		enable = true;
		settings = {
			integrations = {
				neotree = true;
				treesitter = true;
				cmp = true;
			};
			color_overrides.mocha = {
				base = "#1e1e2e";
			};
			custom_highlights = rec {
				Directory.fg = accent.hex;
				Folded = { bg = "#313244"; };
				MsgArea.link = "lualine_c_normal";
				CursorLineNr.fg = cat.overlay1.hex;
				CursorLineNr.bg = "#2a2b3d";

				NeoTreeWinSeparator = { bg = "#181825"; fg = "#181825"; };
				NeoTreeDirectoryIcon. fg = accent.hex;
				NeoTreeDirectoryName.fg = accent.hex;
				NeoTreeIndentMarker.fg = cat.surface0.hex;
				NeoTreeRootName.fg = accent.hex;
				NeoTreeTabActive.fg = accent.hex;

				lualine_a_normal = { bg = accent.hex; };
				lualine_b_normal = { fg = accent.hex; };
				lualine_transparent.bg = cat.mantle.hex;

				MiniMapNormal.bg = cat.base.hex;
				MiniMapSymbolLine.fg = accent.hex;

				TelescopePromptNormal.bg = cat.surface0.hex;
				TelescopePromptTitle.fg = accent.hex;
				TelescopeResultsNormal.bg = cat.crust.hex;
				TelescopePreviewNormal.bg = cat.mantle.hex;

				TelescopePromptBorder.bg = TelescopePromptNormal.bg;
				TelescopePromptTitle.bg = TelescopePromptNormal.bg;
				TelescopeResultsBorder.bg = TelescopeResultsNormal.bg;
				TelescopeResultsTitle.fg = TelescopeResultsNormal.bg;
				TelescopePreviewBorder.bg = TelescopePreviewNormal.bg;
				TelescopePreviewTitle.fg = TelescopePreviewNormal.bg;
			};
		};
	};
	autoCmd = [
		{ # hide search highlight 
			event = "InsertEnter";
			command = "noh";
			pattern = "*";
		}

		{ # save folds on exit
			event = "BufWinLeave";
			command = "mkview";
			pattern = "*.*";
		}
		{ # load folds on enter
			event = "BufWinEnter";
			command = "silent! loadview";
			pattern = "*.*";
		}

		{ # hide cursor in nvimtree
			event = ["WinEnter" "BufWinEnter"];
			pattern = "Neotree*";
			command = "set guicursor+=a:Cursor/lCursor | silent! hi Cursor blend=100";
		}
		{ # show cursor when leaving nvimtree
			event = ["WinLeave" "BufWinLeave"];
			pattern = "Neotree*";
			command = "silent! hi Cursor blend=0";
		}

		{ # on vim open
			event = "VimEnter";
			callback.__raw = /*lua*/ ''
				function() 
					local map = require("mini.map")
					-- set up cursor for neotree
                    vim.cmd("set guicursor+=a:Cursor/lCursor")
					-- open tree and minimap if w>110
					if vim.o.columns > 110 then
						require("neo-tree.command").execute({action = "show"})
						map.open()
					else
						map.open({ window = { width = 1} })
					end
				end
			'';
		}
		{ # open/close nvimtree on resize
			event = "VimResized";
			callback.__raw = ''
            function()
					local tree = require("neo-tree.command")
					local map = require("mini.map")
					if vim.o.columns < 110 then
						tree.execute({action = "close"})
						map.refresh({ window = { width = 1 } })
					elseif vim.o.columns >= 110 then
						tree.execute({action = "show"})
						map.refresh({ window = { width = 10 } })
					end
				end
			'';
		}
	];
	keymaps = [
		{ # down 10 lines
			key = "J";
			action = "10j";
			mode = "n";
		}
		{ # up 10 lines 
			key = "K";
			action = "10k";
			mode = "n";
		}

		{ # comment line with ctrl + slash
			key = "<C-_>";
			action = "gcc";
			mode = "n";
		}
		{
			key = "<C-_>";
			action = "gc";
			mode = "v";
		}

		{ # ctrl + backspace
			key = "<C-BS>";
			action = "<C-W>";
			mode = "i";
		} 

		{ # select pane to left
			key = "<C-h>";
			action = ":wincmd h<CR>";
			mode = "n";
			options.silent = true;
		}
		{ # select pane above 
			key = "<C-j>";
			action = ":wincmd j<CR>";
			mode = "n";
			options.silent = true;
		}
		{ # select pane below
			key = "<C-k>";
			action = ":wincmd k<CR>";
			mode = "n";
			options.silent = true;
		}
		{ # select pane to right
			key = "<C-l>";
			action = ":wincmd l<CR>";
			mode = "n";
			options.silent = true;
		}

		{ # increase hsplit size
			key = "<C-Up>";
			action = ":resize +10<CR>";
			mode = "n";
		}
		{ # decrease hsplit size
			key = "<C-Down>";
			action = ":resize -10<CR>";
			mode = "n";
		}
		{ # increase vsplit size
			key = "<C-Right>";
			action = ":vertical resize +10<CR>";
			mode = "n";
		}
		{ # decrease vsplit size
			key = "<C-Left>";
			action = ":vertical resize -10<CR>";
			mode = "n";
		}

		{ # next buffer
			key = "<Tab>";
			action = ":BufferLineCycleNext<CR>";
			mode = "n";
			options = {
				desc = "Next buffer";
				silent = true;
			};
		}
		{ # prev buffer
			key = "<S-Tab>";
			action = ":BufferLineCyclePrev<CR>";
			mode = "n";
			options = {
				desc = "Previous buffer";
				silent = true;
			};
		}

		{ # toggle neotree
			key = "<leader>f";
			action = ":Neotree toggle<CR>";
			mode = "n";
			options = {
				desc = "Toggle file browser";
				silent = true;
			};
		}
		{ # toggle diagnostics
			key = "<leader>d";
			action = "Trouble diagnostics toggle";
			mode = "n";
			options = {
				desc = "Toggle diagnostics pane";
				silent = true;
			};
		}
		{ # toggle terminal
			key = "<leader>t";
			action = ":ToggleTerm dir=%:p:h<CR>";
			# action.__raw = ''
			# 	function()
			# 		vim.api.nvim_open_win(
			# 			vim.api.nvim_create_buf(false, true), -- buffer to open
			# 			true, -- enter split on open
			# 			{
			# 				win = 0, 
			# 				split = "below", 
			# 				style = "minimal", 
			# 				height = 10
			# 			}
			# 		)
			# 		vim.cmd("terminal")
			# 	end
			# '';
			mode = "n";
			options = {
				desc = "Toggle terminal";
				silent = true;
			};
		}
	];
	diagnostic.settings = {
		signs = {
			numhl.__raw = ''{
				[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
				[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
				[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
			}'';
			text.__raw = /*lua*/ '' {
				[vim.diagnostic.severity.ERROR] = '',
				[vim.diagnostic.severity.WARN] = '',
				[vim.diagnostic.severity.INFO] = '',
				[vim.diagnostic.severity.HINT] = '󰌶',
			}'';
		};
		underline = true;
		update_in_insert = false;
	};
	files = {
		"ftplugin/markdown.lua" = {
			opts = {
				wrap = true;
				linebreak = true;
				spell = true;
				spelllang = "en_ca";
			};
		};
	};
	plugins = {

		lsp = {
			enable = true;
			servers = {
				nixd = {
					enable = true;
					settings = {
						options = {
							nixos.expr = /*nix*/ ''
								(builtins.getFlake "/home/evren/flake")
								.nixosConfigurations.thinkpad.options
							'';
							home-manager.expr = /*nix*/ ''
								(builtins.getFlake "/home/evren/flake")
								.homeConfigurations.thinkpad.options
							'';
						};
						diagnostic.suppress = [
							"sema-unused-def-lambda-noarg-formal"
						];
					};
				};
				rust_analyzer = {
					enable = true;
					installCargo = true;
					installRustc = true;
					installRustfmt = true;
				};
				lua_ls.enable = true; # lua
				yamlls.enable = true; # yaml
				jsonls.enable = true; # json
				qmlls.enable = true; # qml
				html.enable = true; # html
				phpactor.enable = true; # php
				clangd.enable = true; # c
				marksman.enable = true; # markdown
				sqls.enable = true; # sql
				dartls.enable = true; # dart
				hyprls.enable = true; # hypr
			};
		};

		schemastore.enable = true;

		# nix.enable = true;

		treesitter = {
			enable = true;
			settings = {
				highlight.enable = true;
				indent.enable = false;
			};
		};

		blink-cmp = {
			enable = false;
			setupLspCapabilities = false;
			settings = {
				signature = {
					enable = true;
				};
				snippets = {
					preset = "luasnip";
				};
				sources = {
					default = [ "lsp" "path" ];
					providers = {
						lsp = {};
					};
				};
			};
		};

		cmp = {
			enable = true;
			settings = {
				sources = [
					{name = "calc";}
					{name = "nvim_lsp";}
					{name = "luasnip";}
					{name = "buffer";}
					{name = "path";}
				];
				view = {
					entries = {
						name = "custom";
						selection_order = "near_cursor";
					};
				};
				formatting = {
					fields = [
						"kind"
						"abbr"
						"menu"
					];
					# format = /*lua*/ ''
					# 	require('lspkind').cmp_format({
					# 		mode = "symbol",
					# 	})
					# '';
				};
				snippet.expand = /*lua*/ "function(args) require('luasnip').lsp_expand(args.body) end";
				mapping = { 
					"<Tab>" = /*lua*/ ''
						cmp.mapping(function(fallback)
							if cmp.visible() then
								local entry = cmp.get_selected_entry()
								if not entry then
									cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
								end
								cmp.confirm()
							else
								fallback()
							end
						end, {"i","s","c",}),
					'';
				};
				window = {
					completion = {
						side_padding = 2;
					};
				};
			};
			cmdline = {
				":" = {
					sources = [
						{name = "cmdline";}
					];
				};
				"?" = {
					sources = [
						{name = "buffer";}
					];
				};
			};
		};

		lspkind = {
			enable = true;
			cmp.enable = config.programs.nixvim.plugins.cmp.enable;
			settings = {
				mode = "symbol";
			};
		};

		friendly-snippets = {
			enable = true;
		};

		luasnip = {
			enable = true;
			lazyLoad.settings.event = "InsertEnter";
		};

		trouble = {
			enable = true;
		};

		lint = {
			enable = true;
		};

		lualine = {
			enable = true;
			settings = {
				options = {
					# theme.__raw = "cat";
					globalstatus = true;
					theme.__raw = ''
						function()
							local cat = require("lualine.themes.catppuccin")
							cat.normal.a.bg = '${accent.hex}'
							cat.normal.b.fg = '${accent.hex}'
							cat.insert.a.bg = '${cat.sapphire.hex}'
							cat.insert.b.fg = '${cat.sapphire.hex}'
							cat.inactive.c.bg = '${cat.mantle.hex}'
							return cat
						end
					'';
					icons_enabled = true;
					component_separators = { left = ""; right = ""; };
					section_separators = { left = ""; right = ""; };
					disabled_filetypes = [
						"neo-tree"
						"toggleterm"
						"alpha"
						"term"
					];
				};
				extensions = [
					"trouble"
					"nvim-tree"
					"neo-tree"
				];
				sections = {
					lualine_a = ["mode"];
					lualine_b = [{
						__unkeyed-1.__raw = /*lua*/ ''
							function()
								if (vim.bo.modified) then
									return '󰏫'
								elseif (vim.bo.modifiable == false) or (vim.bo.readonly == true) then
									return ''
								else 
									return ''
								end
							end
						'';
					}];
					lualine_c = [
						{
							__unkeyed-1 = "filename";
							path = 1;
							# file_status = false;
							symbols = {
								unnamed = "New File";
								modified = "";
								readonly = "";
							};
						}
					];
					lualine_x = ["filetype"];
					lualine_y = ["branch" "diagnostics"];
					lualine_z = ["location"];
				};
				# winbar = {
				# 	lualine_c = [
				# 		{
				# 			__unkeyed-1 = "navic";
				# 		}
				# 	];
				# };
			};
		};

		web-devicons.enable = true;

		autoclose.enable = true;

		indent-blankline = {
			enable = true;
			settings = {
				scope.enabled = false;
			};
		};

		scrollview = {
			# enable = true;
			settings = {
				excluded_filetypes = ["NvimTree"];
			};
		};

		comment.enable = true;

		# intellitab.enable = true;
		# smear-cursor.enable = true;

		origami = {
			enable = false;
			settings = {
				foldKeymaps = {
					setup = false;
				};
			};
		};

		which-key = {
			enable = true;

		};
		transparent = {
			# enable = true;
			settings = {
				extra_groups = [
					"MiniMapNormal"
				];
				exclude_groups = [
					"CursorLine"
				];
			};
		};

		# barbar = {
		# 	enable = true;
		# 	settings = {
		# 		sidebar_filetypes = {
		# 			neo-tree = true;
		# 		};
		# 	};
		# };

		bufferline = {
			enable = true;
			settings = {
				options = {
					right_mouse_command = null;
					middle_mouse_command = "bdelete! %d";
					modified_icon = "󰏫";
					separator_style = "thick";
					always_show_bufferline = false;
					indicator.icon = "▌";
					offsets = [
						{
							filetype = "neo-tree";
							# text = " Neovim";
							# text = "Files";
							text_align = "left";
							separator = "";
							padding = 1;
							# highlight = "NeoTreeTabInactive";
						}
					];
					hover = {
						enabled = true;
						delay = 0;
						reveal = ["close"];
					};
				};
				highlights = {
					fill.bg = cat.mantle.hex;
					indicator_selected.fg = accent.hex;
					separator.bg = cat.mantle.hex;
					buffer_selected = {
						gui = "bold";
						bg = cat.base.hex;
					};
				};
			};
		};

		neo-tree = {
			enable = true;
			settings = {
				# closeIfLastWindow = true;
				close_if_last_window = true;
				# addBlankLineAtTop = true;
				sources = [
					"filesystem"
					"buffers"
					"document_symbols"
				];
				window = {
					width = 30;
					mappings = {
						l = "open";
						h = "close_node";
					};
				};
				default_component_configs = {
					icon.default = "󰈔";
					modified.symbol = "󰏫";
				};
				event_handlers = {
					neo_tree_buffer_enter = "function() vim.cmd 'highlight! Cursor blend=100' end";
					neo_tree_buffer_leave = "function() vim.cmd 'highlight! Cursor blend=0' end";
				};
				source_selector = {
					# winbar = true;
					content_layout = "center";
					sources = [
						{
							source = "filesystem";
							displayName = "󰉓 File";
						}
						{
							source = "buffers";
							displayName = "󰈚 Buffer";
						}
						{
							source = "document_symbols";
							displayName = "󰆧 Symbol";
						}
					];
				};
				filesystem = {
					follow_current_file.enabled = true;
					leave_dirs_open = true;
				};
			};
		};

		markview = {
			enable = true;
			lazyLoad.settings.ft = "markdown";
			settings = {
				markdown = {
					headings.__raw = "require('markview.presets').headings.marker";
					list_items = {
						shift_width = 2;
						marker_minus = {
							text = "•";
							hl = "Normal";
						};
					};
				};
				markdown_inline = {
					checkboxes = {
						unchecked.text = "☐";
						checked.text = "☑";
					};
				};
			};
		};

		telescope = {
			enable = true;
			lazyLoad.settings.cmd = "Telescope";
			settings = {
				defaults = {
					prompt_prefix = "   ";
					# selection_caret = "";
					borderchars = lib.lists.replicate 8 " ";
				};
			};
		};

		virt-column = {
			enable = true;
			settings = {
				char = "│";
				highlight = "IblIndent";
			};
		};

		mini = {
			enable = true;
			modules = {
				map = {
					integrations = null;
					window = {
						width = 10;
						winblend = 0;
					};
					symbols = {
						encode.__raw = "require('mini.map').gen_encode_symbols.dot('4x2')";
					};
				};
			};
		};

		colorizer = {
			enable = true;
			settings = {
				user_default_options = {
					filetypes = [
						"*"
						"!markdown"
					];
					mode = "virtualtext";
					virtualtext = "󱓻";
					virtualtext_inline.__raw = "'before'";
				};
			};
		};

		toggleterm = {
			enable = true;
			lazyLoad.settings.cmd = "ToggleTerm";
			settings = {
				# direction = "float";
				direction = "horizontal";
				float_opts = {
					# border = "shadow";
				};
			};
		};

		project-nvim = {
			enable = true;
			enableTelescope = true;
			settings = {
				patterns = [
					".git"
					".idea"
					">~/Code"
					"flake.nix"
					"package.json"
					"Makefile"
					"shell.qml"
				];
			};
		};

		alpha = {
			enable = false;
			settings.layout = let
				pad = x: { type = "padding"; val = x; };
				space = pad 2;
			in [
				{ # logo
					type = "text";
					opts = {
						position = "center";
					};
					val = [
						"                               __                "
						"  ___     ___    ___   __  __ /\\_\\    ___ ___    "
						" / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  "
						"/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ "
						"\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\"
						" \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/"
					];
				}
				# space
				# { # date/time
				# 	type = "text";
				# 	opts = {
				# 		position = "center";
				# 		hl = "Comment";
				# 	};
				# 	val.__raw = "function() return 
				# 		os.date '%I:%M %p - ' ..
				# 		os.date '%A, %b %d'
				# 	end";
				# }
				space
				{ # main button list
					type = "group";
					opts = {
						position = "center";
						spacing = 1;
					};
					val = builtins.map (item: {
						type = "button";
						val = " " + item.text;
						on_press.__raw = item.fn;
						opts = {
							shortcut = item.shortcut;
							width = 40;
							position = "center";
							align_shortcut = "right";
			winbar = {
				lualine_c = [
					{
						__unkeyed-1 = "navic";
					}
				];
			};
							hl_shortcut = "Comment";
						};
					}) [
						{
							text = "󰈔  New";
							fn = "function() vim.cmd[[ene]] end";
							shortcut = "i";
						}
						{
							text = "  Recent";
							fn = "function() vim.cmd[[Telescope oldfiles]] end";
							shortcut = "r";
						}
						{
							text = "  Projects";
							fn = "function() vim.cmd[[Telescope projects]] end";
							shortcut = "p";
						}
						{
							text = "  Search";
							fn = "function() vim.cmd[[Telescope find_files]] end";
							shortcut = "f";
						}
						{
							text = "  Exit";
							fn = "function() vim.cmd[[qa]] end";
							shortcut = "q";
						}
					];
				}
				space
				{ # startup time
					type = "text";
					opts = {
						position = "center";
						hl = "Comment";
					};
					val.__raw = ''
						function () return
							"12 plugins loaded in 342ms"
						end
					'';
				}
			];
		};

		lz-n = {
			enable = true;
		};

		dropbar = {
			enable = true;
		};

		ts-autotag.enable = true;

		illuminate = {
			enable = true;
			settings = {
				delay = 0;
				filetypesDenylist = [
					"TelescopePrompt"
					"markdown"
				];
			};
		};

		flutter-tools = {
			enable = true;
		};

		tiny-inline-diagnostic = {
			enable = true;
			settings = {
				blend.factor = 0.13;
				signs = {
					left = "";
					right = "";
					arrow = " ";

					vertical_end = " ";
					vertical = " ";
					up_arrow = "u";
				};
				options = {
					show_related.enabled = false;
				};
			};
		};

		tiny-glimmer = {
			enable = true;
		};

		tiny-devicons-auto-colors = {
			enable = true;
		};

		# smear-cursor = {
		# 	enable = true;
		# };

	};
};

}

