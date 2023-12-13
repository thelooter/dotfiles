-- ===================================================================
-- Load libraries and define mod keys
-- ===================================================================

local gears = require("gears")
local awful = require("awful")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

local keys = {}

-- ===================================================================
-- Mouse Keys
-- ===================================================================


-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
-- Left Click in Window
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),

  -- Super + LeftClick+ Hold to move
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),

  -- Super + Right Hold to resize
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- ===================================================================
-- Client Keys
-- ===================================================================

keys.clientkeys = gears.table.join(
-- Fullscreen Client
  awful.key({ modkey, }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "Toggle fullscreen", group = "client" }),

  -- Quit Client
  awful.key({ modkey, "Shift" }, "q",
    function(c)
      c:kill()
    end,
    { description = "Close client", group = "client" }),

  -- Move Client between screens
  awful.key({ modkey, }, "o",
    function(c)
      c:move_to_screen()
    end,
    { description = "Move to screen", group = "client" }),

  --Toggle Maximize Client
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "Toggle maximize", group = "client" })
)

-- ===================================================================
-- Global Keys
-- ===================================================================

keys.globalkeys = gears.table.join(
  -- ==========================
  -- Generic Keys
  -- ==========================

  -- Show Hotkeys Popup
  awful.key({ modkey, }, "s",
    hotkeys_popup.show_help,
    { description = "View Hotkeys", group = "awesome" }),

  -- ==========================
  -- Lock Keys
  awful.key({ modkey, "Control" }, "l",
    function()
      awful.spawn("betterlockscreen -l blur")
    end,
    { description = "Lock Screen", group = "awesome" }),

  -- ==========================
  -- Tag Keys
  -- ==========================

  -- View Next Tag
  awful.key({ modkey, }, "Left",
    awful.tag.viewprev,
    { description = "View previous", group = "tag" }),

  -- View Previous Tag
  awful.key({ modkey, }, "Right",
    awful.tag.viewnext,
    { description = "View next", group = "tag" }),

  -- View Previous Used Tag
  awful.key({ modkey, }, "Escape",
    awful.tag.history.restore,
    { description = "Go to previous used tag", group = "tag" }),

  -- ==========================
  -- Launcher Keys
  -- ==========================

  -- Open Rofi Launcher
  awful.key({ modkey, }, "F12",
    function()
      awful.spawn("rofi -show drun")
    end,
    { description = "Open Rofi", group = "launcher" }),

  awful.key({ altkey, "Control" }, "f",
    function()
      awful.spawn("firefox")
    end,
    { description = "Open Firefox", group = "launcher" }),

  awful.key({ modkey, }, "Return",
    function()
      awful.spawn(Apps.terminal)
    end,
    { description = "Open a terminal", group = "launcher" }),

  awful.key({ altkey, "Control" }, "t",
    function()
      awful.spawn(Apps.terminal)
    end,
    { description = "Open a terminal", group = "launcher" }),

  awful.key({ modkey, }, "b",
    function()
      awful.spawn(Apps.filemanager)
    end,
    { description = "Open a file manager", group = "launcher" }),

  awful.key({ modkey, altkey }, "s",
    function()
      awful.spawn(Apps.music)
    end,
    { description = "Open Music Player", group = "launcher" }),


  -- ==========================
  -- Client Keys
  -- ==========================

  -- Focus Next Client by Index
  awful.key({ modkey, }, "j",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "Focus next by index", group = "client" }),

  -- Focus Previous Client by Index
  awful.key({ modkey, }, "k",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "Focus previous by index", group = "client" }
  ),

  -- Swap current Client with Next Client by Index
  awful.key({ modkey, "Shift" }, "j",
    function()
      awful.client.swap.byidx(1)
    end,
    { description = "Swap with next client by index", group = "client" }),

  -- Swap current Client with Previous Client by Index
  awful.key({ modkey, "Shift" }, "k",
    function()
      awful.client.swap.byidx(-1)
    end,
    { description = "Swap with previous client by index", group = "client" }),

  -- Jump to Urgent Client
  awful.key({ modkey, }, "u",
    awful.client.urgent.jumpto,
    { description = "Jump to urgent client", group = "client" }),

  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "Go back", group = "client" }),

  -- ==========================
  -- Awesome Keys
  -- ==========================

  -- Reload Awesome
  awful.key({ modkey, "Control" }, "r",
    awesome.restart,
    { description = "Reload awesome", group = "awesome" }),

  -- ==========================
  -- Screen Keys
  -- ==========================

  -- Focus Next Screen
  awful.key({ modkey, "Control" }, "j",
    function()
      awful.screen.focus_relative(1)
    end,
    { description = "Focus the next screen", group = "screen" }),

  -- Focus Previous Screen
  awful.key({ modkey, "Control" }, "k",
    function()
      awful.screen.focus_relative(-1)
    end,
    { description = "Focus the previous screen", group = "screen" }),

  -- ==========================
  -- Layout Keys
  -- ==========================

  -- Make Client Bigger horizontally
  awful.key({ modkey, }, "l",
    function()
      awful.tag.incmwfact(0.05)
    end,
    { description = "Make Client bigger horizontally", group = "layout" }),

  -- Make Client Smaller horizontally
  awful.key({ modkey, }, "h",
    function()
      awful.tag.incmwfact(-0.05)
    end,
    { description = "Make Client smaller horizontally", group = "layout" }),

  -- Increase Number of Master Clients
  awful.key({ modkey, "Shift" }, "h",
    function()
      awful.tag.incnmaster(1, nil, true)
    end,
    { description = "Increase the number of master clients", group = "layout" }),

  -- Decrease Number of Master Clients
  awful.key({ modkey, "Shift" }, "l",
    function()
      awful.tag.incnmaster(-1, nil, true)
    end,
    { description = "Decrease the number of master clients", group = "layout" }),

  -- Increase Number of Columns
  awful.key({ modkey, "Control" }, "h",
    function()
      awful.tag.incncol(1, nil, true)
    end,
    { description = "Increase the number of columns", group = "layout" }),

  -- Decrease Number of Columns
  awful.key({ modkey, "Control" }, "l",
    function()
      awful.tag.incncol(-1, nil, true)
    end,
    { description = "Decrease the number of columns", group = "layout" })
)

-- ===================================================================
-- Bind all key numbers to tags.
-- ===================================================================

for i = 1, 9 do
  keys.globalkeys = gears.table.join(keys.globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "View tag #" .. i, group = "tag" }),

    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "Move tag #" .. i .. " on next screen", group = "tag" }),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "Move focused client to tag #" .. i, group = "tag" }),

    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })

  )
end

return keys

