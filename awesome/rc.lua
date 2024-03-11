-- My Awesome WM configuration

-- {{{ Load luarocks
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- }}}

-- {{{ Imports
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Shared Tags library
local sharedtags = require("sharedtags")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Load theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")
-- }}}

-- {{{ Variable definitions
modkey = "Mod4"

terminal = "kitty"
terminal_exec = terminal .. " "

editor = "nvim"
editor_cmd = terminal_exec .. editor .. " "
-- }}}

-- {{{ Activated layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Try to load freedesktop  menu entries
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Build all menu entries
myawesomemenu = {
    {
        "hotkeys",
        function() hotkeys_popup.show_help(nil, awful.screen.focused()) end,
    },
    { "manual", terminal_exec .. "man awesome" },
    { "edit config", editor_cmd .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open " .. terminal, terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after = { menu_terminal },
    })
else
    mymainmenu = awful.menu({ items = { menu_awesome, menu_terminal } })
end

-- Create shared tags
local tags = sharedtags({
    { name = "1", layout = awful.layout.layouts[1] },
    { name = "2", layout = awful.layout.layouts[1] },
    { name = "3", layout = awful.layout.layouts[1] },
    { name = "4", layout = awful.layout.layouts[1] },
    { name = "5", layout = awful.layout.layouts[1] },
    { name = "6", layout = awful.layout.layouts[1] },
    { name = "7", layout = awful.layout.layouts[1] },
    { name = "8", layout = awful.layout.layouts[1] },
})

-- Configure menu bar
menubar.utils.terminal = terminal
-- }}}

-- {{{ Wallpaper helpers

-- Get the list of files from a directory.
-- Must be all images or folders and non-empty.
function scanDir(directory)
    local i, fileList, popen = 0, {}, io.popen
    for filename in popen([[find "]] .. directory .. [[" -type f]]):lines() do
        i = i + 1
        fileList[i] = filename
    end
    return fileList
end
local wallpaperList = scanDir(os.getenv("HOME") .. "/Images/wallpaper/current/")

math.randomseed(os.time())

local function set_wallpaper(s)
    -- Apply a random wallpaper
    gears.wallpaper.maximized(
        wallpaperList[math.random(1, #wallpaperList)],
        s,
        true
    )
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button(
        {},
        3,
        function() awful.menu.client_list({ theme = { width = 250 } }) end
    )
)

-- Prepare custom widgets   ▓
local lain = require("lain")

-- cpu
local cpu_widget = lain.widget.cpu({
    settings = function()
        widget:set_text(string.format("   %3d%% ", cpu_now.usage))
    end
})
-- memory
local mem_widget = lain.widget.mem({
    settings = function()
        widget:set_text(string.format("   %3d%% ", mem_now.perc))
    end
})
-- disk
local fshome_widget = lain.widget.fs({
    settings = function()
        widget:set_text(string.format("  /home %.1f %s ",
        fs_now["/home"].free, fs_now["/home"].units))
    end
})
-- bat
local bat_widget = lain.widget.bat({
    batteries = {"BAT0", "BAT1"},
    ac = "AC",
    settings = function()
        local status = bat_now.status
        if status == "Charging" then
            widget:set_text("  AC⚡ ")
            return
        end

        local capacity = bat_now.perc
        if not capacity or capacity == "N/A" then
            widget:set_text("  ▒ na  ")
        elseif capacity // 25 == 4 then
            widget:set_text(string.format("  ▉%3d%%  ", capacity))
        elseif capacity // 25 == 3 then
            widget:set_text(string.format("  ▓ %2d%%  ", capacity))
        elseif capacity // 25 == 2 then
            widget:set_text(string.format("  ▒ %2d%%  ", capacity))
        elseif capacity // 25 == 1 then
            widget:set_text(string.format("  ░ %2d%%  ", capacity))
        elseif capacity // 25 == 0 then
            widget:set_text(string.format("  ▁ %2d%%  ", capacity))
        end
    end
})

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Assign tags to the newly connected screen here
    -- sharedtags.viewonly(tags[1], s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which
    -- layout we're using. We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        gears.table.join(
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end)
        )
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            cpu_widget,
            mem_widget,
            fshome_widget,
            bat_widget,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button({}, 3, function() mymainmenu:toggle() end)
    )
)
-- }}}

-- {{{ Set scratchpads
local bling = require("bling")
local passman_scratch = bling.module.scratchpad({
    command = "keepassxc",
    rule = { instance = "keepassxc" },
    sticky = false,
    autoclose = false,
    floating = true,
    geometry = { x = 1100, y = 50, height = 500, width = 800 },
    reapply = false,
    dont_focus_before_close = false,
})
local fm_scratch = bling.module.scratchpad({
    command = "kitty --name=monfm vifm",
    rule = { instance = "monfm" },
    sticky = false,
    autoclose = true,
    floating = true,
    geometry = { x = 255, y = 150, height = 700, width = 1400 },
    reapply = false,
    dont_focus_before_close = false,
})
local sysmon_scratch = bling.module.scratchpad({
    command = "gnome-system-monitor",
    rule = { instance = "gnome-system-monitor" },
    sticky = false,
    autoclose = false,
    floating = true,
    geometry = { x = 900, y = 560, height = 500, width = 1000 },
    reapply = false,
    dont_focus_before_close = false,
})
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key(
        { modkey, "Control" },
        "k",
        hotkeys_popup.show_help,
        { description = "show key bindings", group = "awesome" }
    ),
    awful.key(
        { modkey, "Control" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
        { modkey, "Control" },
        "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    -- Focus window
    awful.key(
        { modkey },
        "j",
        function() awful.client.focus.byidx(1) end,
        { description = "focus next window", group = "client" }
    ),
    awful.key(
        { modkey },
        "k",
        function() awful.client.focus.byidx(-1) end,
        { description = "focus previous window", group = "client" }
    ),

    -- Swap window
    awful.key(
        { modkey, "Shift" },
        "j",
        function() awful.client.swap.byidx(1) end,
        { description = "swap with next window", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" },
        "k",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous window", group = "client" }
    ),

    -- Focus screen
    awful.key(
        { modkey },
        ".",
        function() awful.screen.focus_relative(1) end,
        { description = "focus next screen", group = "screen" }
    ),
    awful.key(
        { modkey },
        ",",
        function() awful.screen.focus_relative(-1) end,
        { description = "focus previous screen", group = "screen" }
    ),

    -- Jump to window
    awful.key(
        { modkey },
        "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent window", group = "client" }
    ),

    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "jump back to previous window", group = "client" }),

    -- Standard program
    awful.key(
        { modkey },
        "Return",
        function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),

    awful.key(
        {},
        "F1",
        function() passman_scratch:toggle() end,
        { description = "toggle Keypass manager", group = "launcher" }
    ),

    awful.key(
        { modkey },
        "e",
        function() fm_scratch:toggle() end,
        { description = "toggle file manager", group = "launcher" }
    ),

    awful.key(
        { modkey },
        "i",
        function() sysmon_scratch:toggle() end,
        { description = "toggle system manager", group = "launcher" }
    ),

    -- Resize tiled windows
    awful.key(
        { modkey },
        "l",
        function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key(
        { modkey },
        "h",
        function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),

    -- Update number of master & columns
    awful.key(
        { modkey, "Shift" },
        "l",
        function() awful.tag.incnmaster(1, nil, true) end,
        {
            description = "increase the number of master clients",
            group = "layout",
        }
    ),
    awful.key(
        { modkey, "Shift" },
        "h",
        function() awful.tag.incnmaster(-1, nil, true) end,
        {
            description = "decrease the number of master clients",
            group = "layout",
        }
    ),
    awful.key(
        { modkey, "Control" },
        "l",
        function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key(
        { modkey, "Control" },
        "h",
        function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),

    -- Select layout
    awful.key(
        { modkey, "Control" },
        "Tab",
        function() awful.layout.inc(1) end,
        { description = "select next layout", group = "layout" }
    ),

    -- Restore window
    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal(
                "request::activate",
                "key.unminimize",
                { raise = true }
            )
        end
    end, { description = "restore minimized", group = "client" }),

    -- Launcher
    awful.key(
        { modkey },
        "space",
        function() awful.spawn("rofi -combi-modi drun,run -show combi -modi combi") end,
        { description = "run prompt", group = "launcher" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { modkey, "Shift" },
        "q",
        function(c) c:kill() end,
        { description = "close", group = "client" }
    ),

    -- Swap to master
    awful.key(
        { modkey },
        "m",
        function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),

    -- Move to screen
    awful.key(
        { modkey, "Shift" },
        ".",
        function(c) c:move_to_screen() end,
        { description = "move to next screen", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" },
        ",",
        function(c) c:move_to_screen() end,
        { description = "move to next screen", group = "client" }
    ),

    -- Toggle window property
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    awful.key(
        { modkey, "Control" },
        "f",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key(
        { modkey, "Control" },
        "t",
        function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),

    awful.key(
        { modkey, "Control" },
        "s",
        function(c) c.sticky = not c.sticky end,
        { description = "toggle sticky", group = "client" }
    ),

    -- Minimize
    awful.key(
        { modkey },
        "n",
        function(c) c.minimized = true end,
        { description = "minimize", group = "client" }
    ),

    -- Expand client window
    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),

    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 8 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = tags[i]
            if tag then
                sharedtags.viewonly(tag, screen)
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = tags[i]
            if tag then
                sharedtags.viewtoggle(tag, screen)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key(
            { modkey, "Shift" },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        ),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, {
            description = "toggle focused client on tag #" .. i,
            group = "tag",
        })
    )
end

clientbuttons = gears.table.join(
    awful.button(
        {},
        1,
        function(c) c:emit_signal("request::activate", "mouse_click", { raise = true }) end
    ),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        c.floating = true
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "VirtualBox Machine",
                "VirtualBox Manager",
                "Gnome-calculator",
                "org.remmina.Remmina",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal" } },
        properties = { titlebars_enabled = false },
    },
    {
        rule_any = { type = { "dialog" } },
        properties = { titlebars_enabled = true },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c) c:emit_signal("request::activate", "mouse_enter", { raise = false }) end
)

client.connect_signal(
    "focus",
    function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal(
    "unfocus",
    function(c) c.border_color = beautiful.border_normal end
)
-- }}}

-- {{{ Autorun applications
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
-- }}}
