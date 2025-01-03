return {
  -- UFO Folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { " " }, maxwidth = 1 },
              {
                sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
                click = "v:lua.ScSa",
              },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
              {
                sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
                click = "v:lua.ScSa",
              },
            },
          })
        end,
      },
    },
    event = "BufRead",
    keys = {
      {
        "zm",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds({ "comment", "imports" })
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek folded lines",
      },
    },
    config = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]
      require("ufo").setup({
        close_fold_kinds_for_ft = {
          default = { "comment", "imports" },
        },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<M-k>",
            scrollD = "<M-j>",
          },
        },
        enable_get_fold_virt_text = false,
        open_fold_hl_timeout = 800,
        provider_selector = function(_, ft, _)
          local noLspFold = { "markdown", "python", "css", "json", "bash", "zsh" }
          if vim.tbl_contains(noLspFold, ft) then
            return { "treesitter", "indent" }
          end
          return { "lsp", "indent" }
        end,
      })
    end,
  },
  -- Nvim tree for file explorer
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,
      },
      -- Show explorer window in the middle of the screen
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screenW = vim.opt.columns:get()
            local screenH = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local windowW = screenW * 0.5
            local windowH = screenH * 0.8
            local windowWInt = math.floor(windowW)
            local windowHInt = math.floor(windowH)
            local centerX = (screenW - windowW) / 2
            local centerY = ((vim.opt.lines:get() - windowH) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = centerY,
              col = centerX,
              width = windowWInt,
              height = windowHInt,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * 0.5)
        end,
      },
    },
  },
}
