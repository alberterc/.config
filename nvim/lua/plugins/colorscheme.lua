return {
  "rebelot/kanagawa.nvim",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    local function setColor(color)
      vim.cmd.colorscheme(color or "kanagawa-dragon")

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    setColor()
  end,
}
