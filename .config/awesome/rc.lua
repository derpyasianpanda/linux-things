--       ___           ___     
--      /\  \         /\  \    
--     /::\  \       /::\  \   
--    /:/\:\  \     /:/\:\  \  
--   /::\~\:\  \   /:/  \:\  \ 
--  /:/\:\ \:\__\ /:/__/ \:\__\
--  \/_|::\/:/  / \:\  \  \/__/
--     |:|::/  /   \:\  \      
--     |:|\/__/     \:\  \     
--     |:|  |        \:\__\    
--      \|__|         \/__/ 

--                     ___           ___
--                    /__/\         /  /\
--                    \  \:\       /  /::\
--   ___     ___       \  \:\     /  /:/\:\
--  /__/\   /  /\  ___  \  \:\   /  /:/~/::\
--  \  \:\ /  /:/ /__/\  \__\:\ /__/:/ /:/\:\
--   \  \:\  /:/  \  \:\ /  /:/ \  \:\/:/__\/
--    \  \:\/:/    \  \:\  /:/   \  \::/
--     \  \::/      \  \:\/:/     \  \:\
--      \__\/        \  \::/       \  \:\
--                    \__\/         \__\/    


-- ===============================================================
-- ===============================================================
--
-- Hello and welcome to derpyasianpanda's rc.lua for the "Awesome"
-- window manager. I hope you enjoy your stay!
--
-- ===============================================================
-- ===============================================================


-- ==========================
-- Initializing Prerequisites
-- ==========================

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget/Layout library
local wibox = require("wibox")

-- Theme library
local beautiful = require("beautiful")

-- Notification libraries
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local lain = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- ============
-- User options
-- ============

user = {
    terminal = "kitty -1",
    editor_cmd = "kitty -1 --class editor -e vim",
    editor = os.getenv("EDITOR") or "vim",
    browser = "google-chrome-stable",
    theme = "static",
    modkey = "Mod1",
}

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.max,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.spiral,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

-- Theme Initialization
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" ..
    user.theme .. "/theme.lua")

-- ==============
-- Error handling
-- ==============

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- ==========
-- Menu Setup
-- ==========

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() 
       hotkeys_popup.show_help(nil, awful.screen.focused())
   end },
   { "Docs", user.browser .. " /usr/share/doc/awesome/doc/index.html" },
   { "Config", user.editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { 
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
    { "Terminal", user.terminal }
}})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

menubar.utils.terminal = user.terminal

-- ===============
-- Wallpaper Setup
-- ===============

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

-- Dynamic Wallpaper Setting
script_path = gears.filesystem.get_configuration_dir() .. "scripts/"
if beautiful.dynamic_wallpaper then
    bg_path = gears.filesystem.get_configuration_dir() .. 
        "themes/" .. user.theme .. "/background.mp4"
    awful.spawn.with_shell(script_path .. "setlivewallpaper.sh " .. bg_path)
else
    awful.spawn.with_shell(script_path .. "killlivewallpapers.sh")
end

-- ==================
-- Wibar/Widget Setup
-- ==================

-- Date/Time
local date = wibox.widget.textclock("%a, %b. %e")
local time = wibox.widget.textclock("%H:%M")
date.align = "center"
time.align = "center"

-- Taglist
local taglist_buttons = gears.table.join(
    awful.button(
        { }, 1,
        function(t) t:view_only() end
    ),
    awful.button(
        { user.modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button(
        { }, 3,
        awful.tag.viewtoggle
    ),
    awful.button(
        { user.modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        { }, 4,
        function(t) awful.tag.viewnext(t.screen) end
    ),
    awful.button(
        { }, 5,
        function(t) awful.tag.viewprev(t.screen) end
    )
)

-- (WIP) Power menu of some kind
local power_button = wibox.widget.imagebox(beautiful.shutdown)
power_button.forced_height = 25

power_button:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("")
    end)
))


-- PulseAudio Volume Controller
local volume_text = lain.widget.pulse {
    settings = function()
        vlevel = volume_now.right .. "%"
        if volume_now.muted == "yes" then
            vlevel = "Mute"
        end
        widget:set_markup(vlevel)
    end
}

local volume = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.speaker,
            resize = true,
        }
    },
    volume_text.widget,
}

volume:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 3, function() -- right click
        os.execute(
            string.format("pactl set-sink-mute %s toggle", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({}, 4, function() -- scroll up
        os.execute(
            string.format("pactl set-sink-volume %s +1%%", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({}, 5, function() -- scroll down
        os.execute(
            string.format("pactl set-sink-volume %s -1%%", volume_text.device)
        )
        volume_text.update()
    end)
))

-- Battery Indicator
local battery_text = lain.widget.bat({
    settings = function()
        widget.text =
            ((bat_now.perc == "N/A") and "?" or bat_now.perc) .. "%"
    end,
})

local battery = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 10,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.battery,
            resize = true,
        }
    },
    battery_text.widget,
}

-- CPU Indicator
local cpu_text = lain.widget.cpu({
    settings = function()
        widget.text = cpu_now.usage .. "%"
    end,
})

local cpu = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 15,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.cpu,
            resize = true,
        }
    },
    cpu_text.widget,
}

-- Memory Indicator
local mem_text = lain.widget.mem({
    settings = function()
        widget.text = mem_now.used / 1000 .. "GiB"
    end,
})

local mem = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 15,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.ram,
            resize = true,
        }
    },
    mem_text.widget,
}

-- Creates floating wibar sections
local wibar_section = function(screen, args)
    local section = wibox({
        screen = s, height = args.height, width = args.width,
        x = screen.geometry.x + args.x,
        y = screen.geometry.y + args.y,
        bg = beautiful.bg_normal, visible = true,
        ontop = false, shape = gears.shape.rectangle,
        input_passthrough = true, type = "dock",
    })
    section:struts({ top = 45 })
    section:setup {
        layout = wibox.layout.fixed.horizontal,
        args.widget
    }

    return section
end

-- Add a widgets to each screen
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ " ", " ", " ", " ", " " }, s, awful.layout.layouts[1])

    -- System Tray (BUGGED: No Transparency)
    s.systray = wibox.widget.systray()
    s.systray.visible = false
    s.systray.forced_height = 25

    -- Imagebox which contains an icon indicating current layout
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.circle,
            spacing = 5,
            bg_focus = beautiful.fg_focus,
            bg_empty = beautiful.fg_minimize,
            bg_occupied = beautiful.fg_normal,
            font = "Monaco 15"
        },
        buttons = taglist_buttons,
    }

    -- Create Wibar
    s.wibar = {}

    s.wibar.first = wibar_section(s, {
        widget = {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                left = 15, {
                    layout = wibox.layout.fixed.horizontal,
                    {
                            widget = wibox.container.margin,
                            right = 5, top = 5, bottom = 5,
                            s.layoutbox,
                    },
                    s.taglist,
                }
            }
        },
        x = 15, y = 10, width = 165, height = 40,
    })

    s.wibar.second = wibar_section(s, {
        widget = {
            widget = wibox.container.place,
            halign = "center", forced_width = 500,
            {
                widget = wibox.container.margin,
                left = 15, top = 8, bottom = 8, {
                    widget = wibox.layout.fixed.horizontal,
                    volume,
                    mem,
                    cpu,
                    battery,
                    {
                        widget = wibox.container.margin,
                        left = 15,
                        s.systray,
                    },
                },
            },
        },
        x = s.geometry.width / 2 - 250, y = 10, width = 500, height = 40,
    })

    s.wibar.third = wibar_section(s, {
        widget = {
            widget = wibox.container.margin,
            left = 15, top = 8, bottom = 8, {
                widget = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    right = 5,
                    {
                        widget = wibox.widget.imagebox,
                        image = beautiful.calendar,
                        resize = true,
                    }
                },
                date,
                {
                    widget = wibox.container.margin,
                    left = 10, right = 5,
                    {
                        widget = wibox.widget.imagebox,
                        image = beautiful.clock,
                        resize = true,
                    }
                },
                time,
            },
        },
        x = s.geometry.width - 265, y = 10, width = 250, height = 40,
    })

    s.cal = awful.widget.calendar_popup.month({
        margin = 15, screen = s, spacing = 10,
        week_numbers = true,
        style_focus = { fg_color = beautiful.fg_normal, border_width = 1 },
        style_weekday = { border_width = 0, bg_color = "#00000000" },
        style_normal = { border_width = 0, bg_color = "#00000000" },
        style_header = { border_width = 0, bg_color = "#00000000" },
        style_month  = { padding = 25 },
        style_weeknumber  = {
            fg_color = beautiful.fg_minimize,
            bg_color = beautiful.fg_normal,
            border_width = 0,
        },
    })
    s.cal:attach(s.wibar.third.widget, "tr")
end)

-- ==================
-- Bindings/Shortcuts
-- ==================

-- Mouse
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Global Keys
globalkeys = gears.table.join(
    awful.key(
        { user.modkey }, "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key(
        { user.modkey }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key(
        { user.modkey }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key(
        { user.modkey }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),
    awful.key({ user.modkey }, "j",
        function () awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ user.modkey }, "k",
        function () awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key(
        { user.modkey }, "w",
        function () mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),
    awful.key(
        { user.modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
        { user.modkey }, ",",
        function()
            awful.screen.focused().systray.visible =
                not awful.screen.focused().systray.visible
        end,
        { description = "toggle system tray", group = "awesome" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key(
        { user.modkey, "Control" }, "f", 
        function()
            screen = awful.screen.focused()
            for _, section in pairs(screen.wibar) do
                section.visible = not section.visible

                for _, tag in pairs(screen.tags) do
                    if section.visible then
                        tag.gap = 8
                    else 
                        tag.gap = 0
                    end
                end
            end
        end,
        { description = "toggle focus mode", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key(
        { user.modkey, "Shift" }, "j", 
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "k",
        function () awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "j",
        function () awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key(
        { user.modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key(
        { user.modkey }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    awful.key(
        { user.modkey }, "l",
        function () awful.tag.incmwfact(0.025) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key(
        { user.modkey }, "h",
        function () awful.tag.incmwfact(-0.025) end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "h",
        function () awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "l",
        function () awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "h",
        function () awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "l",
        function () awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),
    awful.key(
        { user.modkey }, "space",
        function () awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "space",
        function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
              c:emit_signal(
                  "request::activate", "key.unminimize", {raise = true}
              )
            end
        end,
        { description = "restore minimized", group = "client"}
    ),

    -- Standard programs
    awful.key(
        { user.modkey }, "Return",
        function () awful.spawn(user.terminal) end,
        { description = "open a terminal", group = "apps" }
    ),
    awful.key(
        { user.modkey }, "b", function () awful.spawn(user.browser) end,
        { description = "open browser", group = "apps" }
    ),
    awful.key(
        { user.modkey }, "d", function () awful.spawn("discord") end,
        { description = "open discord", group = "apps" }
    ),
 
    -- Rofi Prompts (Launcher)
    awful.key(
        { user.modkey }, "r",
        function() awful.spawn("rofi -show run") end,
        { description = "show the run menu", group = "launcher" }
    ),
    awful.key(
        { user.modkey }, "p",
        function() awful.spawn("rofi -show drun -show-icons true") end,
        { description = "show the application launcher", group = "launcher" }
    ),
    awful.key(
        { user.modkey }, ".",
        function() awful.spawn("rofimoji")  end,
        { description = "open emoji selector", group = "launcher" }
    ),
    awful.key(
        { user.modkey }, "Tab",
        function () awful.spawn("rofi -show window") end,
        { description = "open window list", group = "custom" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { user.modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key(
        { user.modkey }, "c",
        function (c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),
    awful.key(
        { user.modkey }, "o",
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
    ),
    awful.key(
        { user.modkey }, "t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key(
        { user.modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
    ),
    awful.key(
        { user.modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "(un)maximize", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Taglist Controls
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,

        -- View tag only.
        awful.key(
            { user.modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}
        ),

        -- Toggle tag display.
        awful.key(
            { user.modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),

        -- Move client to tag.
        awful.key(
            { user.modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i] if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}
        ),
                  
        -- Toggle tag on focused client.
        awful.key(
            { user.modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

clientbuttons = gears.table.join(
    awful.button(
        { }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),
    awful.button(
        { user.modkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        { user.modkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true }},
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end 

    -- Border Radius
    -- c.shape = function(cr, w, h)
    --     gears.shape.rounded_rect(cr, w, h, 10)
    -- end
end)

-- Sloppy Focus (Focus follows mouse)
client.connect_signal("mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal("focus",
    function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal("unfocus",
    function(c) c.border_color = beautiful.border_normal end
)

-- ===============
-- Autostart Setup
-- ===============

awful.spawn.with_shell("picom -cb --experimental-backends")
