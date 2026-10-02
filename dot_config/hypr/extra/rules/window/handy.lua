-- Handy's recording overlay.
--
-- WebKitGTK cannot paint into gtk-layer-shell surfaces on this NVIDIA/Wayland
-- stack ("Failed to create GBM buffer of size ...: Invalid argument"), so Handy
-- runs with HANDY_NO_GTK_LAYER_SHELL=1 (see extra/autostart.lua) and the
-- overlay becomes an ordinary frameless transparent window rather than a layer
-- surface. Hyprland therefore owns it now, hence this rule:
--
--   float        the 256x46 panel would otherwise be tiled into the layout,
--                which stretches it to the full tile and turns the
--                transparent window into a large blurred rectangle.
--   move         Handy positions the overlay before the window maps, which
--                Wayland discards, so pin it bottom-centre here instead.
--                40 is Handy's OVERLAY_BOTTOM_OFFSET on Linux.
--   no_blur      the window is transparent and draws its own rounded pill, so
--   no_shadow    anything Hyprland decorates it with shows up as a blurred,
--   rounding     bordered square sitting behind that pill.
--   border_size
--   no_focus     it must never take the keyboard focus it is transcribing into.
--
-- Field names are validated against `hyprctl configerrors`; note it is
-- `rounding = 0`, not `no_rounding` (that field does not exist).
hl.window_rule({
    name  = "handy_overlay",
    match = { initial_class = "^handy$", initial_title = "^Recording$" },

    float           = true,
    no_focus        = true,
    no_follow_mouse = true,
    no_blur         = true,
    no_shadow       = true,
    no_anim         = true,
    decorate        = false,
    border_size     = 0,
    rounding        = 0,
    move            = { "(monitor_w*0.5)-(window_w*0.5)", "monitor_h-window_h-40" },
})
