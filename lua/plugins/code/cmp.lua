--[[ cmp.lua

Author: M.R. Siavash Katebzadeh <mr@katebzadeh.xyz>
Keywords: Lua, Neovim
Version: 0.0.1

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

return {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },

	{
		"hrsh7th/nvim-cmp",
		tag = "v0.0.2",
		dependencies = {
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			local cmp_mapping = require("cmp.config.mapping")
			local cmp_types = require("cmp.types.cmp")
			local ConfirmBehavior = cmp_types.ConfirmBehavior
			local SelectBehavior = cmp_types.SelectBehavior
			local luasnip = require("luasnip")
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local function jumpable(dir)
				local luasnip_ok, luasnip = pcall(require, "luasnip")
				if not luasnip_ok then
					return false
				end

				local win_get_cursor = vim.api.nvim_win_get_cursor
				local get_current_buf = vim.api.nvim_get_current_buf

				---@return boolean true if a node is found, false otherwise
				local function seek_luasnip_cursor_node()
					if not luasnip.session.current_nodes then
						return false
					end

					local node = luasnip.session.current_nodes[get_current_buf()]
					if not node then
						return false
					end

					local snippet = node.parent.snippet
					local exit_node = snippet.insert_nodes[0]

					local pos = win_get_cursor(0)
					pos[1] = pos[1] - 1

					if exit_node then
						local exit_pos_end = exit_node.mark:pos_end()
						if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
							snippet:remove_from_jumplist()
							luasnip.session.current_nodes[get_current_buf()] = nil

							return false
						end
					end

					node = snippet.inner_first:jump_into(1, true)
					while node ~= nil and node.next ~= nil and node ~= snippet do
						local n_next = node.next
						local next_pos = n_next and n_next.mark:pos_begin()
						local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
							or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

						if n_next == nil or n_next == snippet.next then
							snippet:remove_from_jumplist()
							luasnip.session.current_nodes[get_current_buf()] = nil

							return false
						end

						if candidate then
							luasnip.session.current_nodes[get_current_buf()] = node
							return true
						end

						local ok
						ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
						if not ok then
							snippet:remove_from_jumplist()
							luasnip.session.current_nodes[get_current_buf()] = nil

							return false
						end
					end

					-- No candidate, but have an exit node
					if exit_node then
						-- to jump to the exit node, seek to snippet
						luasnip.session.current_nodes[get_current_buf()] = snippet
						return true
					end

					-- No exit node, exit from snippet
					snippet:remove_from_jumplist()
					luasnip.session.current_nodes[get_current_buf()] = nil
					return false
				end

				if dir == -1 then
					return luasnip.in_snippet() and luasnip.jumpable(-1)
				else
					return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
				end
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						max_width = 50,
						symbol_map = { Copilot = "" },
					}),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp_mapping.preset.insert({
					["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
					["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
					["<Down>"] = cmp_mapping(
						cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }),
						{ "i" }
					),
					["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
					["<C-d>"] = cmp_mapping.scroll_docs(-4),
					["<C-f>"] = cmp_mapping.scroll_docs(4),
					["<C-y>"] = cmp_mapping({
						i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
					}),
					["<Tab>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif jumpable(1) then
							luasnip.jump(1)
						elseif has_words_before() then
							-- cmp.complete()
							fallback()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp_mapping.complete(),
					["<C-e>"] = cmp_mapping.abort(),
					["<CR>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							local confirm_opts = vim.deepcopy({
								behavior = ConfirmBehavior.Replace,
								select = false,
							}) -- avoid mutating the original opts below
							local is_insert_mode = function()
								return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
							end
							if is_insert_mode() then -- prevent overwriting brackets
								confirm_opts.behavior = ConfirmBehavior.Insert
							end
							local entry = cmp.get_selected_entry()
							local is_copilot = entry and entry.source.name == "copilot"
							if is_copilot then
								confirm_opts.behavior = ConfirmBehavior.Replace
								confirm_opts.select = true
							end
							if cmp.confirm(confirm_opts) then
								return -- success, exit early
							end
						end
						fallback() -- if not exited early, always fallback
					end),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "neorg" },
					{ name = "copilot", group_index = 2 },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}

--[[ cmp.lua ends here. ]]
