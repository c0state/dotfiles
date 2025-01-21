local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_wayland = false
config.color_scheme = 'Darcula'

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#202020',
}

return config
