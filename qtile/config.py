#### My Qtile configuration

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import (
        Click, Drag, DropDown, Group, Key, KeyChord, Match, ScratchPad, Screen)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import os
import subprocess


@hook.subscribe.startup_once
def autostart():
    processes = [
            ['pnmixer'],
            ['nm-applet'],
            ['redshift-gtk'],
            ['flameshot'],
            ['dropbox', 'start'],
            ]

    for p in processes:
        subprocess.Popen(p)

### Begin Gnome-session integration
_in_gnome = False

@hook.subscribe.startup
def dbus_register():
    id = os.environ.get('DESKTOP_AUTOSTART_ID')
    if not id:
        return
    subprocess.Popen([
        'dbus-send',
        '--session',
        '--print-reply',
        '--dest=org.gnome.SessionManager',
        '/org/gnome/SessionManager',
        'org.gnome.SessionManager.RegisterClient',
        'string:qtile',
        'string:' + id
        ])
    _in_gnome = True
### End Gnome-session integration

mod = 'mod4'
terminal = guess_terminal(['alacritty'])
app_launcher = 'rofi -combi-modi drun,run -show combi -modi combi'

keys = [
    # About WM
    Key([mod, "control"], "r", lazy.restart()),

    # Open/close windows
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "space", lazy.spawn(app_launcher)),
    Key([mod, "shift"], "q", lazy.window.kill()),

    # Window's state
    Key([mod, "control"], "f", lazy.window.toggle_floating()),

    # Layouts
    Key([mod, "control"], "Tab", lazy.next_layout()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),

    Key([mod], "j", lazy.group.next_window()),
    Key([mod], "k", lazy.group.prev_window()),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    # Rezise windows
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod], "equal", lazy.layout.normalize()),
    # Stuff to windows
    Key([mod], "s", lazy.layout.toggle_split()),

    # Screen
    Key([mod], "comma", lazy.prev_screen()),
    Key([mod], "period", lazy.next_screen()),
]

if _in_gnome:
    keys.extend([
        Key([mod, 'control'], 'q',
            lazy.spawn('gnome-session-quit --logout --no-prompt')),
        Key([mod, 'control'], 'l',
            lazy.spawn('gnome-screensaver-command -l')),
        ])
else:
    keys.extend([Key([mod, "control"], "q", lazy.shutdown())])

groups = [Group(i) for i in "12345678"]

def go_to_group(name):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].cmd_toscreen()
        else:
            if name in '1234':
                qtile.focus_screen(0)
                qtile.groups_map[name].cmd_toscreen()
            else:
                qtile.focus_screen(1)
                qtile.groups_map[name].cmd_toscreen()
    return _inner

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.function(go_to_group(i.name))),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        ])

groups.append(
        ScratchPad("scratch", [
            DropDown("passman", "keepassxc", on_focus_lost_hide=False,
                height=0.1, width=0.45, x=0.25, y=0.01),
            DropDown("sysmon", "gnome-system-monitor",
                on_focus_lost_hide=False, height=0.5, y=0.1),
            DropDown("vifm", "kitty --class=monfm vifm", height=0.7, y=0.1),
            ]))

keys.extend([
    Key([], 'F1', lazy.group['scratch'].dropdown_toggle('passman')),
    Key([mod], 'e', lazy.group['scratch'].dropdown_toggle('vifm')),
    Key([mod], 'i', lazy.group['scratch'].dropdown_toggle('sysmon'))
    ])

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

groupbox1 = widget.GroupBox(
        visible_groups=['1', '2', '3', '4', '5', '6', '7', '8'],
        disable_drag=True,
        highlight_method='line')
groupbox2 = widget.GroupBox(
        visible_groups=['5', '6', '7', '8'],
        disable_drag=True,
        highlight_method='line')

screens = [
    Screen(
        top=bar.Bar([
            widget.CurrentLayoutIcon(),
            widget.CurrentScreen(),
            groupbox1,
            widget.Prompt(),
            widget.TaskList(),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            widget.Systray(),
            widget.BatteryIcon(),
            widget.Clock(format="%a %d %b %H:%M"),
            widget.QuickExit(default_text='[X]', countdown_format='[{}]'),
            ],
            24
        )
    ),
    Screen(
        top=bar.Bar([
            widget.CurrentLayoutIcon(),
            widget.CurrentScreen(),
            groupbox2,
            widget.TaskList(),
            ],
            24
        )
    )]

@hook.subscribe.screens_reconfigured
def update_screens_groupbox():
    if len(qtile.screens) > 1:
        groupbox1.visible_groups = ['1', '2', '3', '4']
    else:
        groupbox1.visible_groups = ['1', '2', '3', '4', '5', '6', '7', '8']
    if hasattr(groupbox1, 'bar'):
        groupbox1.bar.draw()

# Mouse callbacks
mouse = [
    Drag([mod], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),

    Drag([mod], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),

    Click([mod], "Button2",
        lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = False

# Floating apps
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="Gnome-calculator"),
        Match(wm_class="Gnome-system-monitor"),
        Match(wm_class="Nm-connection-editor"),
        Match(wm_class="Org.gnome.Nautilus"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="VirtualBox Machine"),
        Match(wm_class="keepassxc"),
        Match(wm_class="org.remmina.Remmina"),
        Match(wm_class="retroarch"),
        Match(wm_class="totem"),
    ]
)

# [Wayland backend] Configure input devices
wl_input_rules = None

# Fix JVM desktop apps
wmname = "LG3D"
