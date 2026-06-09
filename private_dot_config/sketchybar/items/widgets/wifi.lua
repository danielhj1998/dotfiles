local icons        = require("icons")
local colors       = require("colors")
local settings     = require("settings")
local hover_reveal = require("helpers.hover_reveal")

sbar.exec("killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = {
    string        = icons.wifi.connected,
    color         = colors.overlay0,
    padding_left  = settings.paddings + 2,
    padding_right = settings.paddings,
  },
  label = {
    string        = "↑ ---  ↓ ---",
    color         = colors.text,
    width         = 0,
    padding_right = settings.paddings + 2,
    font = {
      family = settings.font.numbers,
      style  = settings.font.style_map["Regular"],
      size   = 11.0,
    },
  },
})

wifi:subscribe("network_update", function(env)
  local active = env.upload ~= "000 Bps" or env.download ~= "000 Bps"
  wifi:set({
    icon  = { color = active and colors.blue or colors.overlay0 },
    label = { string = "↑ " .. env.upload .. "  ↓ " .. env.download },
  })
end)

wifi:subscribe({ "wifi_change", "system_woke" }, function()
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = ip ~= nil and ip ~= ""
    wifi:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color  = connected and colors.overlay0 or colors.red,
      }
    })
  end)
end)

hover_reveal.wire(wifi)

sbar.add("bracket", "widgets.wifi.bracket", { wifi.name }, {
  background = {
    color         = colors.base,
    corner_radius = 12,
    height        = 34,
    drawing       = true,
  },
})

sbar.add("item", "widgets.wifi.padding", {
  position = "right",
  width    = settings.group_paddings,
})
