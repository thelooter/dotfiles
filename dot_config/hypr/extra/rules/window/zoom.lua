-- Zoom opens its hover overlays, toolbars and popups as regular toplevels,
-- so they get tiled next to the meeting and the layout twitches on every
-- hover. Float everything except the main and meeting windows.
hl.window_rule({
    name  = "zoom_float_popups",
    match = { class = "^(zoom|Zoom)$", title = "negative:^(Zoom Workplace.*|Zoom Meeting.*|Meeting.*)$" },

    float = true,
})

-- Keep the screenshare toolbar and the floating webcam window visible on
-- every workspace while sharing.
hl.window_rule({
    name  = "zoom_pin_share_windows",
    match = { class = "^(zoom|Zoom)$", title = "^(as_toolbar|zoom_linux_float_video_window)$" },

    float = true,
    pin   = true,
})
