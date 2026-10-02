-- Toolbox otherwise reopens wherever it last was, which after a monitor
-- layout change can land fully off-screen. Pin it under the tray icon
-- (top-right of the monitor you are currently focused on) instead.
--
-- NOTE: move expressions are monitor-local Lua expressions (monitor_w,
-- window_w, ...). The old hyprlang "100%-450" form is NOT valid here:
-- "%" is not a percentage operator in this language, so the window was
-- flung off-screen instead of under the tray.
hl.window_rule({
    name  = "toolbox_position",
    match = { class = "jetbrains-toolbox" },

    float = true,
    pin   = true,
    no_anim = true,
    move  = { "monitor_w-window_w-22", "62" },
})

-- Toolbox is an XWayland client and re-applies its own remembered geometry
-- right after mapping, which overrides the static `move` above (classic
-- "x11 is x11": the app immediately requests its own move, sometimes even
-- on another monitor). Re-pin it under the tray icon of the monitor you
-- are focused on shortly after it opens, so the remembered (possibly
-- off-screen) position never sticks. One-shot per window: user drags after
-- that are left alone. `pin` in the rule above already keeps it visible on
-- every workspace, so only the position needs enforcing here.
-- `no_anim` above keeps the correction instant instead of a visible slide.
hl.on("window.open", function(win)
    if win == nil or win.class ~= "jetbrains-toolbox" then
        return
    end
    local addr = "address:" .. win.address
    -- Snapshot the monitor the user is looking at *now*: by the time the
    -- timer below fires, focus may have wandered elsewhere. Active monitor
    -- wins; cursor monitor is the fallback.
    local target = hl.get_active_monitor()
    if target == nil then
        target = hl.get_monitor_at_cursor()
    end
    if target == nil then
        return
    end
    local mx, my, mw = target.x or 0, target.y or 0, target.width or 0
    hl.timer(function()
        local ok, w = pcall(hl.get_window, addr)
        if not ok or w == nil or not w.mapped then
            return
        end
        local ww = 0
        if type(w.size) == "table" then
            ww = w.size.x or w.size[1] or 0
        end
        local tx = mx + mw - ww - 22
        if tx < mx then
            tx = mx
        end
        local ty = my + 62
        hl.dispatch(hl.dsp.window.move({ x = tx, y = ty, window = w }))
    end, { timeout = 250, type = "oneshot" })
end)
