local colors    = require("colors")
local icons     = require("icons")
local settings  = require("settings")
local app_icons = require("helpers.app_icons")
local aerospace = require("helpers.aerospace")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_window_change")

local workspaces      = { "1", "2", "3", "4" }
local ws_items        = {}  -- ws_items[ws]              = local item
local ws_remote_items = {}  -- ws_remote_items[ws][disp] = remote item on `disp`

-- Build initial workspace → sbar display mapping synchronously
local init_ws_to_sbar = {}
for aero_mon, sbar_disp in pairs(aerospace.mon_to_sbar) do
  for _, ws in ipairs(aerospace.popen_lines("aerospace list-workspaces --monitor " .. aero_mon)) do
    if ws:match("^%d+$") then init_ws_to_sbar[ws] = sbar_disp end
  end
end

-- Sorted list of all known sbar display IDs (for bracket ordering)
local all_displays = {}
for disp in pairs(aerospace.display_names) do all_displays[#all_displays + 1] = disp end
table.sort(all_displays)

-- Create items — one local + one remote-per-other-display per workspace
for _, ws in ipairs(workspaces) do
  local home = init_ws_to_sbar[ws] or 0

  -- Local item: pinned to home display, shows number + app glyphs
  ws_items[ws] = sbar.add("item", "workspace." .. ws, {
    display  = home,
    position = "left",
    icon = {
      string = ws,
      color  = colors.overlay0,
      font   = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 14.0 },
      padding_left  = 8,
      padding_right = 4,
    },
    label = {
      string        = "",
      color         = colors.overlay1,
      padding_right = 8,
      font          = "sketchybar-app-font:Regular:14.0",
      drawing       = true,
    },
    background   = { drawing = false },
    click_script = "aerospace workspace " .. ws,
  })

  -- Remote items: one per display that is NOT the home display
  ws_remote_items[ws] = {}
  for _, disp in ipairs(all_displays) do
    if disp ~= home then
      ws_remote_items[ws][disp] = sbar.add("item", "workspace." .. ws .. ".remote." .. disp, {
        display  = disp,
        position = "left",
        icon = {
          string = ws,
          color  = colors.surface1,
          font   = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 14.0 },
          padding_left  = 0,
          padding_right = 0,
          width         = 0,
        },
        label = {
          string        = icons.monitor .. " " .. aerospace.direction_from_to(disp, home),
          color         = colors.surface1,
          padding_right = 0,
          width         = 0,
          font          = { family = settings.font.text, style = settings.font.style_map["Regular"], size = 12.0 },
        },
        background   = { drawing = false },
        click_script = "aerospace workspace " .. ws,
      })
    end
  end
end

-- Build bracket membership per display: local items + remote items, ordered by workspace number
local bracket_bg = { color = colors.base, corner_radius = 12, height = 34, drawing = true }

if #all_displays > 0 then
  for _, disp in ipairs(all_displays) do
    local names = {}
    for _, ws in ipairs(workspaces) do
      -- Local item for this display
      if (init_ws_to_sbar[ws] or 0) == disp then
        names[#names + 1] = "workspace." .. ws
      end
      -- Remote item targeting this display
      if ws_remote_items[ws] and ws_remote_items[ws][disp] then
        names[#names + 1] = "workspace." .. ws .. ".remote." .. disp
      end
    end
    if #names > 0 then
      sbar.add("bracket", "workspaces_bracket_" .. disp, names, {
        display    = disp,
        background = bracket_bg,
      })
    end
  end
else
  -- Single-monitor fallback: one bracket for all local items
  local names = {}
  for _, ws in ipairs(workspaces) do names[#names + 1] = "workspace." .. ws end
  sbar.add("bracket", "workspaces_bracket", names, { background = bracket_bg })
end

sbar.add("item", "workspaces_padding", {
  position = "left",
  width    = settings.group_paddings,
})

local current_focused_ws = ""

local function update_all_workspaces(focused_ws)
  current_focused_ws = focused_ws

  aerospace.async_ws_to_sbar(function(ws_to_sbar)
    for _, ws in ipairs(workspaces) do
      local new_home   = ws_to_sbar[ws] or 0
      local is_focused = (ws == focused_ws)

      -- Update local item + remote items together (remote visibility depends on window count)
      sbar.exec("aerospace list-windows --workspace " .. ws .. " --format '%{app-name}'", function(win_output)
        local icon_line = ""
        local has_windows = false
        for line in win_output:gmatch("[^\n]+") do
          local name = line:match("^%s*(.-)%s*$")
          if name ~= "" then
            has_windows = true
            local lookup = app_icons[name]
            icon_line = icon_line .. (lookup ~= nil and lookup or app_icons["Default"])
          end
        end
        ws_items[ws]:set({
          display = new_home,
          icon    = { color = is_focused and colors.green or colors.overlay0 },
          label   = {
            string = icon_line,
            color  = is_focused and colors.blue or colors.overlay1,
            font   = "sketchybar-app-font:Regular:14.0",
          },
        })

        -- Remote items: collapsed for empty/unfocused workspaces; bracket stays drawing=true always
        if ws_remote_items[ws] then
          for disp, remote in pairs(ws_remote_items[ws]) do
            local on_other  = new_home ~= disp
            local show      = on_other and (has_windows or is_focused)
            if show then
              remote:set({
                icon  = { width = "dynamic", padding_left = 8, padding_right = 4,
                          color = is_focused and colors.green or colors.surface1 },
                label = { width = "dynamic", padding_right = 8,
                          string = icons.monitor .. " " .. aerospace.direction_from_to(disp, new_home),
                          color  = colors.surface1 },
              })
            else
              remote:set({
                icon  = { width = 0, padding_left = 0, padding_right = 0 },
                label = { width = 0, padding_right = 0 },
              })
            end
          end
        end
      end)
    end
  end)
end

local ws_observer = sbar.add("item", { drawing = false, updates = true })
ws_observer:subscribe("aerospace_workspace_change", function(env)
  update_all_workspaces(env.FOCUSED_WORKSPACE)
end)
ws_observer:subscribe("aerospace_window_change", function()
  update_all_workspaces(current_focused_ws)
end)

sbar.exec("aerospace list-workspaces --focused", function(output)
  local ws = output:match("^%s*(.-)%s*$")
  update_all_workspaces(ws ~= "" and ws or workspaces[1])
end)
