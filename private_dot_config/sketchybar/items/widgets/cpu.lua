local icons        = require("icons")
local colors       = require("colors")
local settings     = require("settings")
local hover_reveal = require("helpers.hover_reveal")

sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("item", "widgets.cpu", {
  position = "right",
  icon = {
    string        = icons.cpu,
    color         = colors.blue,
    padding_left  = settings.paddings + 2,
    padding_right = settings.paddings,
  },
  label = {
    string        = "??%",
    color         = colors.text,
    width         = 0,
    padding_right = settings.paddings + 2,
    font = {
      family = settings.font.numbers,
      style  = settings.font.style_map["Bold"],
      size   = 11.0,
    },
  },
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  local color = colors.blue
  if load > 80 then
    color = colors.red
  elseif load > 60 then
    color = colors.peach
  elseif load > 30 then
    color = colors.yellow
  end

  cpu:set({
    icon  = { color = color },
    label = { string = env.total_load .. "%" },
  })
end)

hover_reveal.wire(cpu)

cpu:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = {
    color         = colors.base,
    corner_radius = 12,
    height        = 34,
    drawing       = true,
  },
})

sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width    = settings.group_paddings,
})
