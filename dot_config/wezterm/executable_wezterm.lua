-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

--fonts
config.font = wezterm.font("JetBrainsMonoNL Nerd Font Propo", {weight="Regular", stretch="Normal", style="Normal"})

--tabs
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Blurred Backdrop
config.window_background_opacity = 0.90

-- For example, changing the color scheme:
config.color_scheme = "catppuccin-mocha"

-- and finally, return the configuration to wezterm
return config
