local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({
	"CaskaydiaMono Nerd Font Mono",
	"Noto Color Emoji",
	"Symbols Nerd Font",
})

config.font_size = 16
config.cell_width = 0.9

config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.window_background_opacity = 1
config.text_background_opacity = 1
config.color_scheme = "jayzone"
config.default_prog = { "fish" }

config.keys = {
	{
		key = ";",
		mods = "CTRL",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|TABS",
		}),
	},
	{
		key = "y",
		mods = "CTRL",
		action = act.ActivateLastTab,
	},
	{
		key = "F1",
		action = act.SpawnCommandInNewTab,
	},
	{
		key = "F3",
		action = act.SpawnCommandInNewTab({
			args = { "fish", "-c", "~/Repos/scripts/run.fish" },
		}),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = act.ScrollByPage(-0.5)
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = act.ScrollByPage(0.5)
	},
}

config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 0,
}

return config
