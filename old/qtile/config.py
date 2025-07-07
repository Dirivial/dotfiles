# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import os
import re
import socket
import subprocess
from typing import List  # noqa: F401
from libqtile import layout, bar, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule
from libqtile.command import lazy

from libqtile.widget import Spacer

# My stuff
from colors import gruvbox_dark
from unicodes import *

#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

myTerm = "alacritty" # My terminal of choice

keys = [

# SUPER + FUNCTION KEYS
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "d", lazy.spawn('nwggrid -p -o 0.4')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn(myTerm)),
    Key([mod], "KP_Enter", lazy.spawn('alacritty')),
    Key([mod], "x", lazy.shutdown()),
    Key([mod], "a", lazy.spawn(home + '/.config/qtile/scripts/keyb.sh'), desc="Next keyboard layout."),

    Key([mod], "e", lazy.spawn("emacsclient -c -a 'emacs'")),

# SUPER + SHIFT KEYS
    Key([mod, "shift"], "Return", lazy.spawn('pcmanfm')),
#    Key([mod, "shift"], "d", lazy.spawn("dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")),
    Key([mod, "shift"], "d", lazy.spawn(home + '/.config/qtile/scripts/dmenu.sh')),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "x", lazy.shutdown()),

# CONTROL + ALT KEYS
    Key(["mod1", "control"], "o", lazy.spawn(home + '/.config/qtile/scripts/picom-toggle.sh')),
    Key(["mod1", "control"], "t", lazy.spawn('xterm')),
    Key(["mod1", "control"], "u", lazy.spawn('pavucontrol')),

# ALT + ... KEYS
    Key(["mod1"], "p", lazy.spawn('pamac-manager')),
    Key(["mod1"], "f", lazy.spawn('firedragon')),
    Key(["mod1"], "m", lazy.spawn('pcmanfm')),
    Key(["mod1"], "w", lazy.spawn('garuda-welcome')),


# CONTROL + SHIFT KEYS
    Key([mod2, "shift"], "Escape", lazy.spawn('lxtask')),


# SCREENSHOTS
    Key([], "Print", lazy.spawn('flameshot full -p ' + home + '/Pictures')),
    Key([mod2], "Print", lazy.spawn('flameshot full -p ' + home + '/Pictures')),
#    Key([mod2, "shift"], "Print", lazy.spawn('gnome-screenshot -i')),

# MULTIMEDIA KEYS

# INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%- ")),

# INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

#    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
#    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
#    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
#    Key([], "XF86AudioStop", lazy.spawn("mpc stop")),

# QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    #Key([mod], "space", lazy.next_layout()),

# CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),


# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip()),

# FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

# MOVE WINDOWS UP OR DOWN BSP LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

         ### Treetab controls
    Key([mod, "control"], "k",
        lazy.layout.section_up(),
        desc='Move up a section in treetab'
        ),
    Key([mod, "control"], "j",
        lazy.layout.section_down(),
        desc='Move down a section in treetab'
        ),



# MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

# TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),]

# Groups
groups = []

group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]
#group_labels = ["f", "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "w",]
group_labels = ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ",]
group_layouts = ["max", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "max", "max",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift" ], "Tab", lazy.screen.prev_group()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        #Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin":10,
            "border_width":2,
            "border_focus": gruvbox_dark["fg0"],
            "border_normal": gruvbox_dark["bg0_s"]
            }

layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(margin=10, border_width=2, border_focus=gruvbox_dark["fg0"], border_normal=gruvbox_dark["bg0_s"]),
    layout.MonadWide(margin=10, border_width=2, border_focus=gruvbox_dark["fg0"], border_normal=gruvbox_dark["bg0_s"]),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Columns(**layout_theme),
    layout.Stack(**layout_theme),
    layout.Tile(**layout_theme),
    layout.TreeTab(
        sections=['FIRST', 'SECOND'],
        bg_color = gruvbox_dark["bg0_s"],
        active_bg = gruvbox_dark["bg1"],
        inactive_bg = gruvbox_dark["bg0"],
        padding_y =5,
        section_top =10,
        panel_width = 280),
    layout.VerticalTile(**layout_theme),
    layout.Zoomy(**layout_theme)
]

# COLORS FOR THE BAR


def init_colors():
    return [["#2F343F", "#2F343F"], # color 0
            ["#2F343F", "#2F343F"], # color 1
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#ff5050", "#ff5050"], # color 3
            ["#f4c2c2", "#f4c2c2"], # color 4
            ["#ffffff", "#ffffff"], # color 5
            ["#ffd47e", "#ffd47e"], # color 6
            ["#62FF00", "#62FF00"], # color 7
            ["#000000", "#000000"], # color 8
            ["#c40234", "#c40234"], # color 9
            ["#6790eb", "#6790eb"], # color 10
            ["#ff00ff", "#ff00ff"], #11
            ["#4c566a", "#4c566a"], #12 
            ["#282c34", "#282c34"], #13
            ["#212121", "#212121"], #14
            ["#e75480", "#e75480"], #15 
            ["#2aa899", "#2aa899"], #16 
            ["#abb2bf", "#abb2bf"],# color 17
            ["#81a1c1", "#81a1c1"], #18 
            ["#56b6c2", "#56b6c2"], #19 
            ["#b48ead", "#b48ead"], #20 
            ["#e06c75", "#e06c75"], #21
            ["#fb9f7f", "#fb9f7f"], #22
            ["#ffd47e", "#ffd47e"]] #23

colors = init_colors()

def base(fg='text', bg='dark'):
    return {'foreground': gruvbox_dark["fg0"],'background': gruvbox_dark["bg0"]}


# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="Noto Sans",
                fontsize = 9,
                padding = 2,
                background=gruvbox_dark["bg0"])

widget_defaults = init_widgets_defaults()


def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [

        widget.Sep(
            linewidth = 1,
            padding = 10,
            foreground = gruvbox_dark["bg1"],
            background = gruvbox_dark["bg1"]
            ),              #
        widget.Image(
            filename = "~/.config/qtile/icons/moon.png",
            iconsize = 2,
            background = gruvbox_dark["bg1"],
            mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn('jgmenu_run')}
            ),

        widget.Sep(
            linewidth = 1,
            padding = 10,
            foreground = gruvbox_dark["bg1"],
            background = gruvbox_dark["bg1"]
            ),

        lower_left_triangle(gruvbox_dark["bg1"], gruvbox_dark["bg0"]),
        widget.GroupBox(

            **base(bg=gruvbox_dark["bg0"]),
            font='UbuntuMono Nerd Font',

            fontsize = 17,
            margin_y = 3,
            margin_x = 1,
            padding_y = 5,
            padding_x = 3,
            borderwidth = 3,

            active=gruvbox_dark["fg2"],
            inactive=gruvbox_dark["fg4"],
            rounded= False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=gruvbox_dark["orange1"],
            this_current_screen_border=gruvbox_dark["red2"],
            this_screen_border=gruvbox_dark["red1"],
            other_current_screen_border=gruvbox_dark["aqua2"],
            other_screen_border=gruvbox_dark["aqua1"],
            disable_drag=True),
        
        lower_left_triangle(gruvbox_dark["bg0"], gruvbox_dark["bg4"]),
        widget.Sep(
            linewidth = 1,
            padding = 10,
            foreground = gruvbox_dark["bg4"],
            background = gruvbox_dark["bg4"]
            ), 
        widget.CurrentLayoutIcon(
            custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            foreground = gruvbox_dark["fg0"],
            background = gruvbox_dark["bg4"],
            padding = 0,
            scale = 0.7
            ),
        lower_left_triangle(gruvbox_dark["bg4"], gruvbox_dark["bg0"]),

        widget.TaskList(

            border=gruvbox_dark["bg3"],
            
            highlight_method = 'block', # or block
            icon_size=20,
            max_title_width=150,
            rounded=False,
            padding_x=5,
            padding_y=3,
            margin_y=0,
            fontsize=17,
            foreground=gruvbox_dark["fg0"],
            txt_floating='🗗',
            txt_minimized='>_ ',
            background=gruvbox_dark["bg0"],
        ),


        # widget.Net(
        #     font="Noto Sans",
        #     fontsize=12,
        #     # Here enter your network name
        #     interface=["wlp6s0"],
        #     format = '{down} ↓↑ {up}',
        #     foreground=colors[5],
        #     background=colors[19],
        #     padding = 0,
        #     ),

        lower_left_triangle(gruvbox_dark["bg0"], gruvbox_dark["bg1"]),
        widget.CPU(
            font="Noto Sans",
            #format = '{MemUsed}M/{MemTotal}M',
            update_interval = 1,
            fontsize = 12,
            foreground = gruvbox_dark["fg0"],
            background = gruvbox_dark["bg1"],
            mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn(myTerm + ' -e htop')},
            ),
        
        lower_left_triangle(gruvbox_dark["bg1"], gruvbox_dark["bg0"]),

        widget.Memory(
            font="Noto Sans",
            format = '{MemUsed: .0f}M/{MemTotal: .0f}M',
            update_interval = 1,
            fontsize = 12,
            measure_mem = 'M',
            foreground = gruvbox_dark["fg0"],
            background = gruvbox_dark["bg0"],
            mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn(myTerm + ' -e htop')},
            ),

        lower_left_triangle(gruvbox_dark["bg0"], gruvbox_dark["bg1"]),

        widget.Clock(
            foreground = gruvbox_dark["fg0"],
            background = gruvbox_dark["bg1"],
            fontsize = 12,
            format="%Y-%m-%d %H:%M"
            ),]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    widgets_screen1.append(lower_left_triangle(gruvbox_dark["bg1"], gruvbox_dark["bg0"]))
    # Seems to not work
    widgets_screen1.append(
        widget.KeyboardLayout(
            configured_layouts=['us', 'se'],
            mouse_callbacks = {'Button1': lambda : this.next_keyboard()}))
    
    widgets_screen1.append(
        widget.Systray(
            background=gruvbox_dark["bg0"],
            icon_size=20,
            padding = 4))
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=30, opacity=1, background= "000000")),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=30, opacity=1, background= "000000"))]
screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN

#########################################################
################ assgin apps to groups ##################
#########################################################
@hook.subscribe.client_new
def assign_app_group(client):
    d = {}
    d["1"] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
              "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
    d["2"] = [ "Atom", "Subl3", "Geany", "Brackets", "Code-oss", "Code", "TelegramDesktop",
               "atom", "subl3", "geany", "brackets", "code-oss", "code", "telegramDesktop",  ]
    d["3"] = ["Inkscape", "Nomacs", "Ristretto", "Nitrogen", "Feh",
              "inkscape", "nomacs", "ristretto", "nitrogen", "feh", ]
    d["4"] = ["Gimp", "gimp" ]
    d["5"] = ["Meld", "meld", "org.gnome.meld" "org.gnome.Meld" ]
    d["6"] = ["Vlc","vlc", "Mpv", "mpv" ]
    d["7"] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
              "virtualbox manager", "virtualbox machine", "vmplayer", ]
    d["8"] = ["pcmanfm", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
              "pcmanfm", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
    d["9"] = ["Evolution", "Geary", "Mail", "Thunderbird","Discord",
              "evolution", "geary", "mail", "thunderbird", "discord" ]
    d["0"] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
              "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
    ##########################################################
    wm_class = client.window.get_wm_class()[0]

    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)
            client.group.cmd_toscreen()

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME



main = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = False 
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='confirmreset'),
    Match(wm_class='makebranch'),
    Match(wm_class='maketag'),
    Match(wm_class='Arandr'),
    Match(wm_class='feh'),
    Match(wm_class='Galculator'),
    Match(title='branchdialog'),
    Match(title='Open File'),
    Match(title='pinentry'),
    Match(wm_class='ssh-askpass'),
    Match(wm_class='lxpolkit'),
    Match(wm_class='Lxpolkit'),
    Match(wm_class='yad'),
    Match(wm_class='Yad'),
    Match(wm_class='Cairo-dock'),
    Match(wm_class='cairo-dock'),


],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True

focus_on_window_activation = "smart" # or smart

wmname = "LG3D"
