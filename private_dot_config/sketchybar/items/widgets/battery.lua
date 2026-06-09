local colors       = require("colors")
local icons        = require("icons")
local settings     = require("settings")
local hover_reveal = require("helpers.hover_reveal")

local battery = sbar.add("item", "battery", {
  position    = "right",
  update_freq = 120,
  icon = {
    font = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 19.0,
    },
    padding_left = settings.paddings + 2,
  },
  label = {
    padding_right = settings.paddings + 2,
    width         = 0,
  },
})

local battery_popup = sbar.add("item", {
  position      = "popup." .. battery.name,
  icon          = { drawing = false },
  label = {
    font = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 13.0,
    },
    color  = colors.text,
    string = "Calculating…",
  },
  padding_left  = 12,
  padding_right = 12,
})

local current_charge = nil

battery:subscribe("mouse.clicked", function()
  local open = battery:query().popup.drawing == "off"
  battery:set({ popup = { drawing = open } })
  if open then
    sbar.exec("pmset -g batt", function(output)
      local label
      if output:find("[Cc]harged") or output:find("AC Power") and output:find("100%%") then
        label = "Charged"
      else
        local h, m = output:match("(%d+):(%d+) remaining")
        if h and m then
          label = h .. "h " .. m .. "m remaining"
        else
          label = "Calculating…"
        end
      end
      battery_popup:set({ label = { string = label } })
    end)
  end
end)

battery:subscribe("mouse.exited.global", function()
  battery:set({ popup = { drawing = false } })
end)

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(output)
    local charge = tonumber(output:match("(%d+)%%"))
    if not charge then return end

    current_charge = charge
    local charging = output:find("AC Power") ~= nil
    local icon, color

    if charging then
      icon  = icons.battery.charging
      color = colors.green
    elseif charge > 80 then
      icon  = icons.battery._100
      color = colors.text
    elseif charge > 60 then
      icon  = icons.battery._75
      color = colors.text
    elseif charge > 40 then
      icon  = icons.battery._50
      color = colors.text
    elseif charge > 20 then
      icon  = icons.battery._25
      color = colors.text
    else
      icon  = icons.battery._0
      color = colors.red
    end

    battery:set({
      icon  = { string = icon, color = color },
      label = { string = charge .. "%" },
    })
  end)
end)

hover_reveal.wire(battery, function()
  if current_charge then
    battery:set({ label = { string = current_charge .. "%" } })
  end
end)

sbar.add("bracket", "controls_bracket", { "volume", "battery" }, {
  background = {
    color         = colors.base,
    corner_radius = 12,
    height        = 34,
    drawing       = true,
  },
})

sbar.add("item", "controls_padding", {
  position = "right",
  width    = settings.group_paddings,
})
