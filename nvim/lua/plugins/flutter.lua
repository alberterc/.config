return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  opts = {
    decorations = {
      statusline = {
        app_version = true,
        device = true,
      },
    },
  },
}
