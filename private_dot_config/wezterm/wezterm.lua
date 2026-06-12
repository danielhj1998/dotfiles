local wezterm = require("wezterm")
local custom_keys = require("keys")

return {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "Catppuccin Mocha",
	-- color_scheme = "Dracula",
	-- color_scheme = "Gruvbox dark, pale (base16)",
	enable_tab_bar = false,
	font_size = 15.0,
	font = wezterm.font("JetBrainsMono Nerd Font"),
	macos_window_background_blur = 30,
	window_background_opacity = 1.0,
	window_decorations = "RESIZE",

	disable_default_key_bindings = true,
	keys = custom_keys.keys,
	enable_csi_u_key_encoding = true,

	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
