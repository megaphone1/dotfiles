--------------------
---- WORKSPACES ----
--------------------

local supressMaximizeRule = hl.window_rule({
    name = "supress-maximize-events",
    match = { class = ".*" },
    supress_event = "maximize",
})

supressMaximizeRule:set_enabled(true)

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
	title = "^$",
	xwayland = true,
	float = true,
	fullscreen = false,
	pin = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})