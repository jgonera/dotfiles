local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "OneDark (base16)"
-- config.color_scheme = "zenwritten_dark"
-- config.color_scheme = "Afterglow"
-- config.color_scheme = "Edge Dark (base16)"
-- config.color_scheme = "Eighties (base16)"
config.colors = {
  background = "black",
}
config.font = wezterm.font("Hack")
config.font_size = 14.5
config.line_height = 1.05
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.initial_cols = 320
config.initial_rows = 240
config.window_padding = {
  left = "1cell",
  right = "1cell",
  top = "0.4cell",
  bottom = 0,
}
config.window_close_confirmation = "NeverPrompt"

return config
