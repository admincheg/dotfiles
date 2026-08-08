-- ~/.config/hypr/hyprland.lua

local home = os.getenv("HOME")

local terminal = "kitty"
local menu = [[sh -lc 'cmd="$(tofi-run)"; [ -n "$cmd" ] && setsid -f sh -lc "$cmd"']]
local main_mod = "SUPER"


----------------
-- MONITORS
----------------

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.5,
})


----------------
-- AUTOSTART
----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("hyprctl setcursor DMZ-Black 24")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd(
        "sleep 1 && " ..
        "dbus-update-activation-environment --systemd " ..
        "WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )

    hl.exec_cmd(
        'gsettings set org.gnome.desktop.interface ' ..
        'cursor-theme "DMZ-Black"'
    )

    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd(home .. "/.bin/wlp")
end)


----------------
-- ENVIRONMENT
----------------

hl.env("XCURSOR_THEME", "DMZ-Black")
hl.env("XCURSOR_SIZE", "24")

hl.env("HYPRCURSOR_THEME", "DMZ-Black")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")


----------------
-- LOOK AND FEEL
----------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border = {
                colors = {
                    "rgba(33ccffee)",
                    "rgba(00ff99ee)",
                },
                angle = 45,
            },

            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,

        active_opacity = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    cursor = {
        inactive_timeout = 0,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,

        vrr = 1,

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,

        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,

        enable_swallow = false,
        swallow_regex = "(foot|kitty|allacritty|Alacritty)",

        allow_session_lock_restore = true,
        initial_workspace_tracking = false,
        focus_on_activate = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true,
    },
})


----------------
-- ANIMATIONS
----------------

hl.curve("easeOutQuint", {
    type = "bezier",
    points = {
        { 0.23, 1 },
        { 0.32, 1 },
    },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = {
        { 0.65, 0.05 },
        { 0.36, 1 },
    },
})

hl.curve("linear", {
    type = "bezier",
    points = {
        { 0, 0 },
        { 1, 1 },
    },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = {
        { 0.5, 0.5 },
        { 0.75, 1.0 },
    },
})

hl.curve("quick", {
    type = "bezier",
    points = {
        { 0.15, 0 },
        { 0.1, 1 },
    },
})

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    bezier = "easeOutQuint",
    style = "popin 87%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick",
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})

hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade",
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})


----------------
-- INPUT
----------------

hl.config({
    input = {
        kb_layout = "lv,ru",
        kb_variant = ",winkeys",
        kb_model = "",
        kb_options = "grp:caps_toggle,lv3:ralt,compose:menu",
        kb_rules = "",

        follow_mouse = 2,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})


----------------
-- BASIC BINDS
----------------

hl.bind(
    main_mod .. " + Return",
    hl.dsp.exec_cmd(terminal)
)

hl.bind(
    main_mod .. " + SHIFT + Return",
    hl.dsp.exec_cmd("hyprlock")
)

hl.bind(
    main_mod .. " + SHIFT + Escape",
    hl.dsp.exit()
)

hl.bind(
    main_mod .. " + W",
    hl.dsp.window.close({})
)

hl.bind(
    main_mod .. " + SHIFT + W",
    hl.dsp.window.kill({})
)

hl.bind(
    main_mod .. " + S",
    hl.dsp.window.float({
        action = "toggle",
    })
)

hl.bind(
    main_mod .. " + SHIFT + S",
    hl.dsp.exec_cmd(
        "sh -lc 'mkdir -p \"$HOME/.scrs\" && hyprshot -o \"$HOME/.scrs/\" -m region'"
    )
)

hl.bind(
    main_mod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    })
)

hl.bind(
    main_mod .. " + Space",
    hl.dsp.exec_cmd(menu)
)

hl.bind(
    main_mod .. " + T",
    hl.dsp.window.pseudo({
        action = "toggle",
    })
)

hl.bind(
    main_mod .. " + Z",
    hl.dsp.exec_cmd(
        [[notify-send -a "Time" "Current time" ]] ..
        [["$(date '+%d.%m.%y %H:%M:%S')"]]
    )
)

hl.bind(
    main_mod .. " + Grave",
    hl.dsp.focus({
        last = true,
    })
)


----------------
-- FOCUS
----------------

hl.bind(
    main_mod .. " + left",
    hl.dsp.focus({
        direction = "l",
    })
)

hl.bind(
    main_mod .. " + right",
    hl.dsp.focus({
        direction = "r",
    })
)

hl.bind(
    main_mod .. " + up",
    hl.dsp.focus({
        direction = "u",
    })
)

hl.bind(
    main_mod .. " + down",
    hl.dsp.focus({
        direction = "d",
    })
)


----------------
-- MONITOR WORKSPACE SUBMAPS
----------------

local function define_workspace_submap(name, first_workspace, move_window)
    hl.define_submap(name, "reset", function()
        for key = 1, 9 do
            local workspace = first_workspace + key - 1
            local dispatcher

            if move_window then
                dispatcher = hl.dsp.window.move({
                    workspace = workspace,
                })
            else
                dispatcher = hl.dsp.focus({
                    workspace = workspace,
                })
            end

            hl.bind(
                tostring(key),
                dispatcher,
                {
                    repeating = true,
                }
            )
        end

        hl.bind(
            "Escape",
            hl.dsp.submap("reset")
        )
    end)
end


-- Monitor 1: workspaces 1..9

hl.bind(
    main_mod .. " + 1",
    hl.dsp.submap("Mon1")
)

hl.bind(
    main_mod .. " + SHIFT + 1",
    hl.dsp.submap("Mon1Move")
)

define_workspace_submap("Mon1", 1, false)
define_workspace_submap("Mon1Move", 1, true)


-- Monitor 2: workspaces 11..19

hl.bind(
    main_mod .. " + 2",
    hl.dsp.submap("Mon2")
)

hl.bind(
    main_mod .. " + SHIFT + 2",
    hl.dsp.submap("Mon2Move")
)

define_workspace_submap("Mon2", 11, false)
define_workspace_submap("Mon2Move", 11, true)


-- Monitor 3: workspaces 21..29

hl.bind(
    main_mod .. " + 3",
    hl.dsp.submap("Mon3")
)

hl.bind(
    main_mod .. " + SHIFT + 3",
    hl.dsp.submap("Mon3Move")
)

define_workspace_submap("Mon3", 21, false)
define_workspace_submap("Mon3Move", 21, true)


----------------
-- WORKSPACE SCROLL
----------------

hl.bind(
    main_mod .. " + mouse_down",
    hl.dsp.focus({
        workspace = "e+1",
    })
)

hl.bind(
    main_mod .. " + mouse_up",
    hl.dsp.focus({
        workspace = "e-1",
    })
)


----------------
-- MOUSE BINDS
----------------

hl.bind(
    main_mod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
    }
)

hl.bind(
    main_mod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
    }
)


----------------
-- AUDIO AND BRIGHTNESS
----------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(
        "brightnessctl s 10%+"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(
        "brightnessctl s 10%-"
    ),
    {
        locked = true,
        repeating = true,
    }
)


----------------
-- MEDIA
----------------

hl.bind(
    "CTRL + Up",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh toggle"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "CTRL + Right",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh next"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "CTRL + Left",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh prev"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh next"
    ),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh toggle"
    ),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh toggle"
    ),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd(
        home .. "/.bin/media_buttons.sh prev"
    ),
    {
        locked = true,
    }
)


----------------
-- WINDOW RULES
----------------

hl.window_rule({
    name = "pavucontrol-float",

    match = {
        class = "^(org%.pulseaudio%.pavucontrol)$",
    },

    float = true,
})

hl.window_rule({
    name = "pavucontrol-size",

    match = {
        class = "^(org%.pulseaudio%.pavucontrol)$",
    },

    size = "30% 50%",
})

hl.window_rule({
    name = "pinentry-stay-focused",

    match = {
        class = "(pinentry%-)(.*)",
    },

    stay_focused = true,
})

hl.window_rule({
    name = "rofi-stay-focused",

    match = {
        class = "Rofi",
    },

    stay_focused = true,
})

hl.window_rule({
    name = "float-modal-windows",

    match = {
        modal = true,
    },

    float = true,
})

hl.window_rule({
    name = "no-shadow-for-tiled-windows",

    match = {
        float = false,
    },

    no_shadow = true,
})

hl.window_rule({
    name = "telegram-ignore-activation",

    match = {
        class = "^org%.telegram%.desktop.*$",
    },

    focus_on_activate = false,
})

hl.window_rule({
    name = "pgmodeler-float",

    match = {
        class = "^pgmodeler$",
    },

    float = true,
})

hl.window_rule({
    name = "pgmodeler-main-window-tile",

    match = {
        class = "^pgmodeler$",
        title = "^pgModeler$",
    },

    float = false,
})
