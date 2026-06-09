local colors       = require("colors")
local icons        = require("icons")
local settings     = require("settings")
local hover_reveal = require("helpers.hover_reveal")

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    color        = colors.text,
    padding_left = settings.paddings + 2,
  },
  label = {
    color         = colors.text,
    padding_right = settings.paddings,
    width         = 0,
  },
})

local current_label = ""

volume:subscribe("volume_change", function(env)
  local vol = tonumber(env.INFO)
  local icon

  if vol == 0 then
    icon          = icons.volume.muted
    current_label = "Muted"
  elseif vol < 30 then
    icon          = icons.volume.low
    current_label = vol .. "%"
  elseif vol < 60 then
    icon          = icons.volume.medium
    current_label = vol .. "%"
  else
    icon          = icons.volume.high
    current_label = vol .. "%"
  end

  volume:set({ icon = { string = icon }, label = { string = current_label } })
end)

hover_reveal.wire(volume)
