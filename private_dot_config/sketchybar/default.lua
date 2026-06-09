local colors   = require("colors")
local settings = require("settings")

sbar.default({
  updates       = "when_shown",
  padding_left  = settings.paddings,
  padding_right = settings.paddings,
  icon = {
    font = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 15.0,
    },
    color         = colors.text,
    padding_left  = settings.paddings,
    padding_right = settings.paddings,
  },
  label = {
    font = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 13.0,
    },
    color         = colors.text,
    padding_left  = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height        = 30,
    corner_radius = 8,
  },
})
