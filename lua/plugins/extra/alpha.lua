return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.header.val = {

			[[███╗   ███╗ █████╗ ███████╗██████╗ ██╗██╗   ██╗]],
			[[████╗ ████║██╔══██╗╚══███╔╝██╔══██╗██║██║   ██║]],
			[[██╔████╔██║███████║  ███╔╝ ██║  ██║██║██║   ██║]],
			[[██║╚██╔╝██║██╔══██║ ███╔╝  ██║  ██║██║╚██╗ ██╔╝]],
			[[██║ ╚═╝ ██║██║  ██║███████╗██████╔╝██║ ╚████╔╝ ]],
			[[╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═══╝  ]],
			[[                                               ]],
		}
		dashboard.section.buttons.val = {
			dashboard.button("fn", "󰈞  Find file", "<CMD>FindFilesCwd<CR>"),
			dashboard.button("p", "  Projects", "<CMD>Telescope projects<CR>"),
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("fo", "  Recently used files", ":Telescope oldfiles <CR>"),
			dashboard.button("fg", "󰛔  Find text", ":Telescope live_grep <CR>"),
			dashboard.button("cc", "  Configuration", ":EditNvimConfig<CR>"),
			dashboard.button("q", "󰈆  Quit Neovim", ":qa<CR>"),
		}

		local function footer()
			return "[-< True happiness can be found when two contrary powers cooperate together >-]"
		end

		dashboard.section.footer.val = footer()

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
