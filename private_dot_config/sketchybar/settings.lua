return {
	paddings = 6,
	group_paddings = 5,

	font = {
		text = "JetBrainsMono Nerd Font",
		numbers = "JetBrainsMono Nerd Font",
		style_map = {
			["Regular"] = "Regular",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
		},
	},

	-- Short display names shown in the front_app label on unfocused monitors.
	-- Keys must match exactly what `aerospace list-monitors --format '%{monitor-name}'` returns.
	-- Any monitor not listed here falls back to its full name.
	monitor_names = {
		["Built-in Retina Display"] = "MacBook",
		["LG ULTRAGEAR"]            = "LG",
	},
}
