-- Machine-specific sub-configs (gitignored, may not exist on all machines)
-- monitors.lua: NVIDIA env, monitor layout, xrandr/dbus setup
-- workspaces.lua: workspace-to-monitor assignments
pcall(require, "monitors")
pcall(require, "workspaces")

-- Programs
local terminal    = "ghostty"
local fileManager = "dolphin"
local menu        = "rofi -show combi -show-icons -theme rounded-orange-dark"
local browser     = "google-chrome-stable"

-- Autostart: runs once on Hyprland startup
-- Uses hl.on("hyprland.start") — multiple callbacks are supported,
-- so autostart.lua (machine-specific) adds its own separately
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("nextcloud")
    hl.exec_cmd("kbuildsycoca6")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("$HOME/.config/hypr/scripts/gaming-inhibit.sh")
end)

-- Machine-specific autostart (gitignored)
pcall(require, "autostart")

-- Environment variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("XDG_MENU_PREFIX", "plasma-")

-- Permissions for portal integration
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

-- Look and feel: general + decoration in one hl.config() call
-- You can group multiple top-level keys into a single hl.config({})
hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 5,
        border_size      = 2,
        col              = {
            active_border   = "rgba(f57c00cc)", -- orange
            inactive_border = "rgba(212121b3)", -- dark gray
        },
        resize_on_border = false,
        allow_tearing    = true,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur             = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },
})

-- Layer rules: apply blur to specific layer surfaces
hl.layer_rule({
    name         = "waybar-blur",
    blur         = true,
    ignore_alpha = 0.5,
    match        = { namespace = "waybar" },
})

hl.layer_rule({
    name         = "rofi-blur",
    blur         = true,
    ignore_alpha = 0.5,
    match        = { namespace = "rofi" },
})

-- Animation curves (bezier only — springs also supported via { type = "spring", ... })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations: leaf = animation name, speed = duration multiplier, bezier/spring = curve name
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
    misc = {
        disable_hyprland_logo = true,  -- removes the hyprland anime girl
        enable_anr_dialog     = false, -- disable "app not responding" popups
    },
})

hl.config({
    dwindle = {
        preserve_split = true, -- keeps window split orientation when moving
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    group = {
        auto_group = true,
        insert_after_current = true,
        focus_removed_window = true,
        col = {
            border_active   = "rgba(f57c00cc)",
            border_inactive = "rgba(212121b3)",
        },
        groupbar = {
            enabled           = true,
            render_titles     = true,
            scrolling         = false,
            gradients         = true,
            gradient_rounding = 10,
            height            = 20,
            indicator_height  = 0,
            gaps_in           = 3,
            gaps_out          = 0,
            rounding          = 10,
            priority          = 3,
            font_size         = 11,
            text_color        = "rgba(ffffffff)",
            col               = {
                active   = "rgba(f57c00cc)",
                inactive = "rgba(424242cc)",
            },
        },
    },
})

hl.config({
    binds = {
        movefocus_cycles_groupfirst = false,
    },
})

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = {
            natural_scroll = true,
        },
    },
})

-- Touchpad gesture: 4-finger horizontal swipe to switch workspaces
hl.gesture({
    fingers   = 4,
    direction = "horizontal",
    action    = "workspace",
})

-- Per-device config (example — probably unused)
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Keybinds
-- hl.bind("MODS + KEY", hl.dsp.<dispatcher>(...), { flags })
--   flags: { mouse = true } for mouse binds (bindm)
--          { repeating = true } for held-key repeats (binde)
--          { locked = true } for lock-screen access (bindl)
--   hl.dsp.window.float({ action = "toggle" }) — toggle/set/unset
--   hl.dsp.layout("...") — dispatches layoutmsg
--   hl.dsp.resize({ x, y, relative = true }) — keyboard resize (relative = delta)
--   hl.dsp.resize() (no args) — mouse resize mode

local mainMod = "SUPER"

-- Launchers & actions
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())       -- dwindle: toggle pseudotile
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit")) -- dwindle: toggle split orientation
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))

-- Tab groups
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.group.prev())
hl.bind(mainMod .. " + bracketleft", hl.dsp.group.move_window({ forward = false }))
hl.bind(mainMod .. " + bracketright", hl.dsp.group.move_window({ forward = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.move({ into_or_create_group = "left" }))
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.move({ into_or_create_group = "right" }))
hl.bind(mainMod .. " + CTRL + SHIFT + up", hl.dsp.window.move({ into_or_create_group = "up" }))
hl.bind(mainMod .. " + CTRL + SHIFT + down", hl.dsp.window.move({ into_or_create_group = "down" }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize windows (relative = true means values are deltas, not absolute sizes)
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Workspace switching (0 key maps to workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Cycle workspaces (e-1/e+1 = empty next/prev)
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media player controls (requires playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots (requires hyprshot)
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))

-- Machine-specific keybinds (gitignored)
pcall(require, "keybinds-local")

-- Window rules
-- Suppress maximize requests, but exclude Steam/game windows so they can go fullscreen
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = "^(?!steam$|steam_app_|VR_Server).*$" },
    suppress_event = "maximize",
})

-- Steam: float popups and dialogs
hl.window_rule({
    name  = "steam-main-float",
    match = { class = "steam", title = "^(Friends|Friends List|Settings|Chat|.* chat|Server Browser)$" },
    float = true,
})

hl.window_rule({
    name  = "steam-dialogs-float",
    match = { class = "steam", xwayland = false, title = "^(?!Steam$).*$" },
    float = true,
})

-- Fix dragging issues with XWayland apps
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
