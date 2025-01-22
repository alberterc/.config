local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

--! Shell
config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe" }

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
    key = "t",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = "Enter a new title for tab",
      action = wezterm.action_callback(function(window, _, line)
        -- `line` is `nil` if escape character is sent
        -- `line` is '' if enter key is pressed without entering anything
        -- `line` is [str] if enter key is pressed
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "d",
    mods = "LEADER",
    action = wezterm.action.ShowDebugOverlay,
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

--! Appearance
config.front_end = "WebGpu"
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == "Vulkan" and gpu.device_type == "DiscreteGpu" then
    config.webgpu_preferred_adapter = gpu
    break
  end
end

--[appearance] Colors
-- Uses kanagawa-dragon color palette
local colorScheme = {
  foreground = "#c5c9c5",
  background = "#181616",
  cursor_bg = "#C8C093",
  cursor_fg = "#C8C093",
  cursor_border = "#C8C093",
  selection_fg = "#C8C093",
  selection_bg = "#2D4F67",
  scrollbar_thumb = "#16161D",
  ansi = { "#0D0C0C", "#C4746E", "#8A9A7B", "#C4B28A", "#8BA4B0", "#A292A3", "#8EA4A2", "#C8C093" },
  brights = { "#A6A69C", "#E46876", "#87A987", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#C5C9C5" },
}
local tab_bar_colors = {
  background = colorScheme.background,
  active_tab = {
    bg_color = "#49443C",
    fg_color = colorScheme.foreground,
    intensity = "Bold",
  },
  inactive_tab = {
    bg_color = colorScheme.background,
    fg_color = colorScheme.foreground,
    intensity = "Normal",
  },
  inactive_tab_hover = {
    bg_color = colorScheme.background,
    fg_color = colorScheme.foreground,
    intensity = "Normal",
    italic = true,
  },
  new_tab = {
    bg_color = colorScheme.background,
    fg_color = colorScheme.foreground,
    intensity = "Half",
  },
  new_tab_hover = {
    bg_color = colorScheme.background,
    fg_color = colorScheme.foreground,
    intensity = "Normal",
    italic = true,
  },
}
colorScheme.tab_bar = tab_bar_colors
colorScheme.split = colorScheme.background
config.colors = colorScheme
config.force_reverse_video_cursor = true

--[appearance] Window
config.default_cwd = "D:"
config.window_background_opacity = 1
-- NOTE: Using "Acrylic" causes window to lag when moving around in desktop
-- config.win32_system_backdrop = "Acrylic"
config.window_frame = {
  active_titlebar_bg = colorScheme.background,
}
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 4,
  bottom = 4,
}

--[appearance] Tab
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local function get_title()
    if tab.tab_title and #tab.tab_title > 0 then
      return wezterm.truncate_right(tab.tab_title, max_width - 1)
    end
    return tab.active_pane.title
  end
  local title = string.format(" %s ", get_title())
  if not tab.is_active then
    edge_foreground = colorScheme.tab_bar.background
  end
  return {
    { Text = title },
    { Background = { Color = colorScheme.tab_bar.background } },
    {
      Foreground = {
        Color = tab.is_active and colorScheme.tab_bar.active_tab.bg_color or colorScheme.tab_bar.background,
      },
    },
    { Text = wezterm.nerdfonts.ple_lower_left_triangle },
  }
end)

--[appearance] Font
config.font = wezterm.font("Cascadia Code")
config.font_size = 12.0
config.freetype_load_target = "Normal"

return config
