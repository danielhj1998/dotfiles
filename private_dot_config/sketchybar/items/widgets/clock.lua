local colors   = require("colors")
local settings = require("settings")
local icons    = require("icons")

local clock = sbar.add("item", "clock", {
  position     = "right",
  update_freq  = 10,
  click_script = "open -a 'Calendar'",
  icon = {
    string        = icons.clock,
    color         = colors.blue,
    padding_left  = settings.paddings + 2,
    padding_right = settings.paddings,
  },
  label = {
    color         = colors.text,
    padding_right = settings.paddings + 2,
  },
})

local is_expanded = false

local function update_label(expanded)
  clock:set({ label = { string = os.date(expanded and "%a %d %b  %H:%M" or "%H:%M") } })
end

clock:subscribe({ "routine", "forced" }, function()
  update_label(is_expanded)
end)

clock:subscribe("mouse.entered", function()
  is_expanded = true
  sbar.animate("tanh", 30, function()
    update_label(true)
  end)
end)

clock:subscribe("mouse.exited", function()
  is_expanded = false
  sbar.animate("tanh", 30, function()
    update_label(false)
  end)
end)

sbar.add("bracket", "clock_bracket", { "clock" }, {
  background = {
    color         = colors.base,
    corner_radius = 12,
    height        = 34,
    drawing       = true,
  },
})

sbar.add("item", "clock_padding", {
  position = "right",
  width    = settings.group_paddings,
})
