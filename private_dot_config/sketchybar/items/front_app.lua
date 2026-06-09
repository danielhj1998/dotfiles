local colors    = require("colors")
local settings  = require("settings")
local aerospace = require("helpers.aerospace")

sbar.add("event", "aerospace_workspace_change")

-- Returns the label to show for a given sbar display:
-- the user-configured alias from settings.monitor_names, or the full aerospace name.
local function display_label(sbar_disp)
  local full = aerospace.display_names[sbar_disp] or ("Display " .. sbar_disp)
  return (settings.monitor_names and settings.monitor_names[full]) or full
end

local initial_ws      = (aerospace.popen_lines("aerospace list-workspaces --focused")[1] or ""):match("^%s*(.-)%s*$")
local focused_display = aerospace.sbar_display_for_ws(initial_ws)
local current_app     = ""

local item_base = {
  position = "left",
  icon     = { drawing = false },
  label    = {
    font  = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 14.0 },
    color = colors.text,
  },
  background    = { color = colors.base, corner_radius = 12, height = 34, drawing = true },
  padding_left  = settings.paddings + 4,
  padding_right = settings.paddings + 4,
  updates       = true,
  drawing       = false,
}

-- One item per display; single fallback item when no multi-monitor data is available
local front_app_items = {}
if next(aerospace.display_names) then
  for disp in pairs(aerospace.display_names) do
    local cfg = {}
    for k, v in pairs(item_base) do cfg[k] = v end
    cfg.display = disp
    front_app_items[disp] = sbar.add("item", "front_app_" .. disp, cfg)
  end
else
  front_app_items[0] = sbar.add("item", "front_app", item_base)
end

local function update_labels()
  if current_app == "" then
    for _, item in pairs(front_app_items) do item:set({ drawing = false }) end
    return
  end
  for disp, item in pairs(front_app_items) do
    local label = (disp == focused_display or disp == 0)
      and current_app
      or display_label(focused_display) .. " | " .. current_app
    item:set({ drawing = true, label = { string = label } })
  end
end

local observer = sbar.add("item", "front_app_observer", { drawing = false, updates = true })

observer:subscribe("front_app_switched", function(env)
  local app = env.INFO
  current_app = (app == nil or app == "" or app == "Finder") and "" or app
  update_labels()
end)

observer:subscribe("aerospace_workspace_change", function(env)
  focused_display = aerospace.sbar_display_for_ws(env.FOCUSED_WORKSPACE)
  update_labels()
end)
