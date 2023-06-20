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
config.font_size = 14
config.line_height = 1.1
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.initial_cols = 240
config.initial_rows = 120
config.window_padding = {
  left = "1cell",
  right = "1cell",
  top = "0.4cell",
  bottom = 0,
}

wezterm.on("format-tab-title", function(tab)
  local pane = tab.active_pane
  local tab_title = pane.title
  local cwd = string.gsub(pane.current_working_dir, "(.*/)(.*)", "%2")

  if tab.tab_title and #tab.tab_title > 0 then
    tab_title = tab.tab_title
  end

  return " " .. tab.tab_index + 1 .. ": " .. cwd .. " — " .. tab_title .. " "
end)

return config
