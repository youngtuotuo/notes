-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

local function getOS()
  -- ask LuaJIT first
  if jit then
    return jit.os
  end

  -- Unix, Linux variants
  local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
  if fh then
    osname = fh:read()
  end

  return osname or "Windows"
end

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 11
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_background_image_hsb = {
  -- Darken the background image by reducing it to 1/3rd
  brightness = 0.02,

  -- You can adjust the hue by scaling its value.
  -- a multiplier of 1.0 leaves the value unchanged.
  hue = 1.0,

  -- You can adjust the saturation also.
  saturation = 1.0,
}
config.hide_tab_bar_if_only_one_tab = true
config.selection_word_boundary = " \t\n{}[]()\"'`@.,;:"
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
    mods = "NONE",
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = wezterm.action.ExtendSelectionToMouseCursor("Word"),
  },
}

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 800
config.color_scheme = "Dark Pastel"

config.tab_bar_at_bottom = true

local dimmer = { brightness = 0.1 }
local bg = "/github/dotfiles/pictures/future-buildings-minimal-ve.jpg"
local file = ""
if os.getenv("HOME") then
  file = os.getenv("HOME") .. bg
end
if getOS() == "Windows" then
  file = "C:/Users/User" .. bg
  config.default_domain = 'WSL:Ubuntu-20.04'
end
config.background = {
  {
    source = {
      File = file,
    },
    hsb = dimmer,
  },
}

-- and finally, return the configuration to wezterm
return config