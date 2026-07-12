-- This is the aptosid default Hyprland config file.
-- Since Hyprland 0.55 the configuration language is Lua (hyprlang/.conf is
-- deprecated). Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can split this configuration into multiple files and require them:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "/usr/libexec/aptosid-wofi hyprland --show drun"
local locker      = "hyprlock"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Autostart processes that are NOT already managed by the uwsm-managed systemd
-- session. Under uwsm, graphical-session.target starts the daemons that ship
-- their own units or XDG autostart entries
hl.on("hyprland.start", function()
    hl.exec_cmd(terminal .. " -e /usr/libexec/aptosid-settings-hyprland/aptosid-hypr-hints --welcome")
    -- Keep clipboard history (cliphist + wl-clipboard), for text and images.
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Thunar in daemon mode: faster windows and thunar-volman removable media.
    hl.exec_cmd("thunar --daemon")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- Under uwsm, environment variables must NOT be set here (they would not reach
-- the systemd-managed session). They are provided instead by:
--   /etc/xdg/uwsm/env          - xcursor + GDK/Qt toolkit vars (uwsm sessions)
--   /etc/xdg/uwsm/env-hyprland - HYPR* / hyprcursor vars (Hyprland session)
--   /etc/environment.d/*.conf  - GTK_THEME, QT_STYLE_OVERRIDE (whole session)
-- uwsm also sets the XDG_* variables automatically.


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 2,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/ for info about colors
        col = {
            active_border   = { colors = {"rgba(5555ffff)", "rgba(ff55ffff)"}, angle = 45 },
            inactive_border = "rgba(581d58ff)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,

            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/ for more
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- kb_* are intentionally left empty. This file ships read-only at
-- /etc/xdg/hypr/hyprland.lua, so the live keyboard layout is not written in
-- here; fll-live-boot provides it via XKB_DEFAULT_* (a uwsm env-hyprland.d
-- drop-in), which libxkbcommon honours when the layout is empty. Leave these
-- as bare `key = ""` (an omitted kb_layout would default to "us" and mask it).
hl.config({
    input = {
        kb_layout  = "",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- The `description` on a bind is the single source of truth for the keybinding
-- cheatsheet (aptosid-hypr-hints, shown at session start and on SUPER + /).
-- It round-trips through `hyprctl binds -j`; only binds with a description are
-- listed. Add one to every bind worth surfacing to a new user.

-- Laptop multimedia keys: locked (work while a lockscreen is active) and,
-- for volume/brightness, repeating (fire while held).
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                       { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),                       { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d *::kbd_backlight set +33%"),  { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d *::kbd_backlight set 33%-"),  { locked = true, repeating = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                        { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                              { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                          { locked = true })
hl.bind("XF86AudioStop",         hl.dsp.exec_cmd("playerctl stop"),                              { locked = true })

hl.bind("Print",            hl.dsp.exec_cmd([[sh -c 'mkdir -p ~/screenshots;grim ~/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png']]),               { description = "screenshot to ~/screenshots" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd([[sh -c 'mkdir -p ~/screenshots;grim -g "$(slurp)"  ~/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png']]), { description = "screenshot a selected region" })
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | swappy -f -']]),   { description = "screenshot a region and annotate (swappy)" })

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal),                     { description = "terminal" })
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd(terminal),                     { description = "terminal" })
hl.bind(mainMod .. " + grave",  hl.dsp.exec_cmd(terminal),                     { description = "terminal" })
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd(locker),                       { description = "lock screen" })
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("x-www-browser"),              { description = "web browser" })
hl.bind(mainMod .. " + C",      hl.dsp.window.close(),                         { description = "close window" })
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("hyprshutdown"),               { description = "log out" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout"),                    { description = "power menu" })
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager),                  { description = "file manager" })
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu),                         { description = "application launcher" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd([[sh -c 'cliphist list | /usr/libexec/aptosid-wofi hyprland --dmenu | cliphist decode | wl-copy']]), { description = "clipboard history" })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a -f hex -n"), { description = "pick a colour (copied to clipboard)" })
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo(),                        { description = "toggle pseudo-tile (dwindle)" })
hl.bind(mainMod .. " + J",      hl.dsp.layout("togglesplit"),                  { description = "toggle split direction (dwindle)" })
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen(),                    { description = "fullscreen" })
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }),    { description = "toggle floating" })
hl.bind(mainMod .. " + slash",  hl.dsp.exec_cmd(terminal .. " -e /usr/libexec/aptosid-settings-hyprland/aptosid-hypr-hints --welcome"), { description = "show this keybinding cheatsheet" })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }),  { description = "focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "focus right" })
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }),    { description = "focus up" })
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }),  { description = "focus down" })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }),        { description = string.format("switch to workspace %d", i) })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }),  { description = string.format("move window to workspace %d", i) })
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"),              { description = "toggle scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }),   { description = "move window to scratchpad" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "move window (drag)" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "resize window (drag)" })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Avoid idle for fullscreen apps
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

hl.window_rule({ match = { class = "([Tt]hunar)", title = "(File Operation Progress)" }, center = true, float = true })
hl.window_rule({ match = { class = "([Tt]hunar)", title = "(Confirm to replace files)" }, center = true, float = true })

hl.window_rule({ match = { class = "^(pavucontrol|pavucontrol-qt|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true, float = true })

hl.window_rule({ match = { class = "^(hyprpolkitagent)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(hyprlauncher)$" }, float = true, center = true })
hl.window_rule({ match = { class = "(xdg-desktop-portal-hyprland|xdg-desktop-portal-gtk|xdg-desktop-portal-kde)" }, float = true })

hl.window_rule({ match = { class = "^(io.calamares.calamares|[Cc]alamares)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-qt)$" }, float = true })
hl.window_rule({ match = { class = "^(eom|eog|org.gnome.Loupe|qpiv)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-tray|nm-applet|nm-connection-editor|blueman-manager)$" }, float = true })

hl.window_rule({ match = { class = "^(nwg-look|qt5ct|qt6ct)$" }, float = true })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, float = true })

hl.window_rule({ match = { class = "^(Alacritty|kitty)$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^([Tt]hunar|org.gnome.Nautilus)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { class = "^(pcmanfm|dolphin)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad|pluma|featherpad|kate)$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^(nwg-look|qt5ct|qt6ct)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, opacity = "0.9 0.8" })
