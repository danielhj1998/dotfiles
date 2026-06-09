local colors   = require("colors")
local icons    = require("icons")
local settings = require("settings")

sbar.add("item", { width = 5 })

local apple = sbar.add("item", "apple", {
  position = "left",
  icon = {
    string        = icons.apple,
    font          = { size = 16.0 },
    color         = colors.text,
    padding_left  = 8,
    padding_right = 8,
  },
  label        = { drawing = false },
  background   = {
    color        = colors.surface1,
    border_color = colors.crust,
    border_width = 1,
  },
  padding_left  = 1,
  padding_right = 1,
  click_script  = "open -a 'System Settings'",
  popup = {
    horizontal = false,
    align      = "left",
    background = {
      color         = colors.surface0,
      corner_radius = 8,
      border_color  = colors.overlay0,
      border_width  = 1,
    },
  },
})

sbar.add("bracket", "apple_bracket", { apple.name }, {
  background = {
    color        = colors.transparent,
    height       = 30,
    border_color = colors.overlay0,
    border_width = 1,
  }
})

sbar.add("item", { width = 7 })

local MAX_MENUS = 8
local menu_items = {}
for i = 1, MAX_MENUS do
  local slot = sbar.add("item", "apple.menu." .. i, {
    position = "popup." .. apple.name,
    icon     = { drawing = false },
    label    = {
      font  = {
        family = settings.font.text,
        style  = settings.font.style_map["Regular"],
        size   = 13.0,
      },
      color  = colors.text,
      string = "",
    },
    background    = {
      color         = colors.transparent,
      corner_radius = 6,
    },
    padding_left  = 8,
    padding_right = 8,
    drawing       = false,
  })
  local idx = i
  slot:subscribe("mouse.entered", function()
    slot:set({ background = { color = colors.surface1 } })
  end)
  slot:subscribe("mouse.exited", function()
    slot:set({ background = { color = colors.transparent } })
  end)
  slot:subscribe("mouse.clicked", function()
    apple:set({ popup = { drawing = false } })
    sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -s " .. idx)
  end)
  menu_items[i] = slot
end

apple:subscribe("mouse.entered", function()
  sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(output)
    local lines = {}
    for line in output:gmatch("[^\n]+") do
      lines[#lines + 1] = line
    end
    for i = 1, MAX_MENUS do
      if lines[i] then
        menu_items[i]:set({ label = { string = lines[i] }, drawing = true })
      else
        menu_items[i]:set({ drawing = false })
      end
    end
    apple:set({ popup = { drawing = true } })
  end)
end)

apple:subscribe("mouse.exited.global", function()
  apple:set({ popup = { drawing = false } })
end)
