local wezterm = require("wezterm")
local config = wezterm.config_builder()

--! Shell
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }

--! Keybinds
config.leader = { key = "w", mods = "ALT" }
config.keys = {
  -- Prevent sending "^C" (SIGINT) when there is a selection
  -- but still able to send SIGINT when there is no selection
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(win, pane)
      local selection = win:get_selection_text_for_pane(pane) ~= ""
      if selection then
        win:perform_action(wezterm.action.CopyTo({ "ClipboardAndPrimarySelection" }), pane)
      else
        win:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
      end
    end),
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "1",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = "2",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = "3",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = "4",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = "5",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(4),
  },
  {
    key = "6",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(5),
  },
  {
    key = "7",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(6),
  },
  {
    key = "8",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(7),
  },
}

--! Appeareance
config.max_fps = 120
config.front_end = "WebGpu"
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == "Dx12" and gpu.device_type == "DiscreteGpu" then
    config.webgpu_power_preference = "HighPerformance"
    config.webgpu_preferred_adapter = gpu
    break
  end
end

--[appeareance] Colors
-- Modified version of kanagawa
local colors = {
  foreground = "#dcd7ba",
  background = "#1f1f28",
  cursor_bg = "#c8c093",
  cursor_fg = "#c8c093",
  cursor_border = "#c8c093",
  selection_fg = "#c8c093",
  selection_bg = "#2d4f67",
  scrollbar_thumb = "#16161d",
  split = "#16161d",
  ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
  brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
  indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}
config.colors = colors

--[appeareance] Window
config.window_frame = {
  active_titlebar_bg = colors.background,
}
config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 1,
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 5,
  bottom = 5,
}

--[appeareance] Tab
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

--[appeareance] Font
config.font = wezterm.font("Cascadia Code")
config.font_size = 12.0
config.freetype_load_target = "Normal"

return config
