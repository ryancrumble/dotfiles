local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.scrollback_lines = 5000

-- Mouse Bindings
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
-- Micellaneous Settings
config.prefer_egl = true

-- Font settings
config.font_size = 18
config.line_height = 1.1
config.font = wezterm.font("MesloLGM Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })

-- Colors
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tokyo Night Moon"
	else
		return "Tokyo Night Day"
	end
end

function background_for_appearance(appearance)
	if appearance:find("Dark") then
		return {
			{
				source = {
					File = "/Users/ryan/Pictures/wallpaper/vaporwave/wallpaperflare.com_dark_mountains.jpg",
				},
				hsb = {
					hue = 1.0,
					saturation = 1.02,
					brightness = 0.25,
				},
				width = "100%",
				height = "100%",
			},
			{
				source = {
					Color = "#1f2335",
				},
				width = "100%",
				height = "100%",
				opacity = 0.9,
			},
		}
	else
		return {
			{
				source = {
					File = "/Users/ryan/Pictures/wallpaper/vaporwave/wallpaperflare.com_dark_mountains.jpg",
				},
				hsb = {
					hue = 1.0,
					saturation = 1.02,
					brightness = 0.25,
				},
				width = "100%",
				height = "100%",
			},
			{
				source = {
					Color = "#e1e2e7",
				},
				width = "100%",
				height = "100%",
				opacity = 0.9,
			},
		}
	end
end

-- Appearance
config.window_decorations = "RESIZE"
config.window_padding = {
	top = 0,
	left = 4,
	bottom = 0,
	right = 4,
}
config.hide_tab_bar_if_only_one_tab = true

-- config.background = background_for_appearance(get_appearance())
-- config.color_scheme = scheme_for_appearance(get_appearance())

config.background = background_for_appearance("Dark")
config.color_scheme = scheme_for_appearance("Dark")

return config
