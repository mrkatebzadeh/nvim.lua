return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "RRethy/vim-illuminate",
    lazy = true,
    event = "BufReadPost",
    opts = {
      filetypes_denylist = {
        "NvimTree",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local highlight = "#51576d"
      vim.api.nvim_set_hl(0, "IlluminatedWordText", {
        bg = highlight,
      })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
        bg = highlight,
      })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
        bg = highlight,
      })
    end,
  },
  {
    "cappyzawa/trim.nvim",
    opts = {},
  },
  {
    -- Visual Studio Code inspired breadcrumbs plugin for the Neovim editor
    "utilyre/barbecue.nvim",
    version = "v1.*",
    lazy = true,
    opts = {
      show_modified = true,
      symbols = {
        modified = "󰽃",
      },
    },
    event = "BufReadPre",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({})
    end,
  },
  {
    -- The fastest Neovim colorizer.
    "norcalli/nvim-colorizer.lua",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#e78284" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e5c890" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8caaee" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ef9f76" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#a6d189" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#ca9ee6" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#85c1dc" })
      end)

      require("ibl").setup({
        indent = {
          -- highlight = highlight,
          -- char = "|",
          char = "│",
        },
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "3.1.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "folke/todo-comments.nvim",
    version = "1.4.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
    },
    opts = {
      extensions = {
        undo = {},
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    -- A snazzy bufferline for Neovim
    "akinsho/bufferline.nvim",
    enabled = true,
    version = "v4.9.1",
    opts = function()
      local Offset = require("bufferline.offset")
      if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
          if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs({ "left", "right" }) do
              local sb = layout[pos]
              if sb and #sb.wins > 0 then
                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                ret[pos .. "_size"] = sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then
              return ret
            end
          end
          return get()
        end
        Offset.edgy = true
      end
    end,
  },
  {
    -- Decorate scrollbar for Neovim
    "lewis6991/satellite.nvim",
    tag = "v1.0.0",
    config = function()
      require("satellite").setup({})
    end,
  },
  {
    "chentoast/marks.nvim",
    commit = "74e8d01",
    config = function()
      require("marks").setup({})
    end,
  },
}
