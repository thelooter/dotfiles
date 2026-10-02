-- Autostart configs
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- hl.exec_cmd() spawns asynchronously, no need for "& disown"

hl.on("hyprland.start", function()
    -- Launch waybar via a watcher that restarts it on monitor add/remove. On cold
    -- boot the LG (HDMI-A-1) comes up after waybar inits and a plain launch leaves
    -- the bar on only the TERRA; the watcher reattaches it (and handles hotplug).
    hl.exec_cmd("~/.config/hypr/scripts/waybar-monitor-watch.sh")
    hl.exec_cmd("hypr-u")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("dunst")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("syncthing -no-browser")

    -- Clipboard. Wayland hands out an *offer* (a list of MIME types), not the
    -- data -- the bytes are pulled from the source app at paste time, so the
    -- clipboard dies with whatever you copied from. wl-clip-persist grabs the
    -- data and re-offers it when the owner exits; cliphist keeps searchable
    -- history behind SUPER+SHIFT+V. Both skip KeePassXC's
    -- x-kde-passwordManagerHint offers, so its clipboard auto-clear still works
    -- and passwords never reach ~/.cache/cliphist/db.
    hl.exec_cmd("wl-clip-persist --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).*'")
    hl.exec_cmd("wl-paste --type text --watch ~/.config/hypr/scripts/cliphist-store.sh")
    hl.exec_cmd("wl-paste --type image --watch ~/.config/hypr/scripts/cliphist-store.sh")
    -- Handy: WebKitGTK's DMABUF/GBM path is broken on NVIDIA Wayland (empty
    -- layer-shell surfaces, "Failed to create GBM buffer"), so run the overlay
    -- as a regular frameless window (HANDY_NO_GTK_LAYER_SHELL) with the DMABUF
    -- renderer disabled. Float rule in extra/rules/window/handy.lua.
    hl.exec_cmd("HANDY_NO_GTK_LAYER_SHELL=1 WEBKIT_DISABLE_DMABUF_RENDERER=1 handy --start-hidden")

    -- Windows on specific workspaces
    hl.dispatch(hl.dsp.exec_cmd("keepassxc", { workspace = "9 silent" }))
    hl.dispatch(hl.dsp.exec_cmd("vesktop", { workspace = "8 silent" }))

    -- Special Workspaces
    hl.dispatch(hl.dsp.exec_cmd("thunderbird", { workspace = "special:mail silent" }))
end)
