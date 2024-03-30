-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- ===================================================================
-- Standard Libraries
-- ===================================================================

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")

-- ===================================================================
-- Error Handling
-- ===================================================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end

-- ===================================================================
-- Theme
-- ===================================================================

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")

beautiful.wallpaper = awful.util.get_configuration_dir() .. "themes/default/colored_waves.png"

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- ===================================================================
-- User Configuration
-- ===================================================================

-- This is used later as to determine default Applications
Apps = {
  terminal = "kitty",                     --Standard Terminal
  editor = os.getenv("EDITOR") or "nano", --Standard Editor
  launcher = "rofi -show drun",           --Standard Launcher
  browser = "firefox",                    --Standard Browser
  filemanager = "thunar",                 --Standard File Manager
  music = "spotify",                      --Standard Music Player
  screenshot = "flameshot gui",           --Standard Screenshot Tool
}

local editor_cmd = Apps.terminal .. " -e " .. Apps.editor

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
}

-- ===================================================================
-- Screen Setup
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

-- ===================================================================
-- Mouse and Key Bindings
-- ===================================================================

local keys = require("keys")
root.keys(keys.globalkeys)

-- ===================================================================
-- Rules
-- ===================================================================

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("rules").create(keys.clientkeys, keys.clientbuttons)


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================

require("awful.autofocus")

-- Focus client under mouse
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- ===================================================================
-- Gaps
-- ===================================================================

-- Gaps
beautiful.useless_gap = 5
beautiful.gap_single_client = true

-- ===================================================================
-- Autostart
-- ===================================================================

awful.spawn("syncthing serve --no-browser --logfile=default")
awful.spawn("ckb-next --background")

awful.spawn.with_shell("sh ~/.config/awesome/scripts/autorun.sh")

-- ===================================================================
-- Notifications
-- ===================================================================

naughty.config.defaults['icon_size'] = 100
