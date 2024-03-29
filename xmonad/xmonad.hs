---------------------------------------------------------------------------------------------------
-- KWS Xmonad conf
module Main (main) where

---------------------------------------------------------------------------------------------------
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.DwmPromote (dwmpromote)
import XMonad.Config.Desktop (desktopConfig, desktopLayoutModifiers)
import XMonad.Hooks.DynamicLog (dynamicLogString, xmonadPropLog, xmobarColor, wrap, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.InsertPosition (Focus(..), Position(..), insertPosition)
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..), MirrorResize(..))
import XMonad.Layout.Tabbed (tabbedAlways, shrinkText, Theme(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad (NamedScratchpad(NS),
                                    namedScratchpadAction,
                                    namedScratchpadFilterOutWorkspacePP,
                                    namedScratchpadManageHook,
                                    defaultFloating)

import qualified Data.Map.Strict as Map
import qualified XMonad.StackSet as W

---------------------------------------------------------------------------------------------------
main = do
    xmonad $ desktopConfig
        { modMask = myModMask
        , normalBorderColor = "#104010"
        , focusedBorderColor = "#FF4000" --"#CC5522"
        , terminal = myTerminal
        , borderWidth = 1
        , workspaces = myWorkspaces
        , focusFollowsMouse = False
        , clickJustFocuses = False

        , manageHook = myManageHook <+> insertPosition Above Newer <+> manageHook desktopConfig
        , layoutHook = smartBorders $ desktopLayoutModifiers $ myLayouts
        , logHook = (dynamicLogString . namedScratchpadFilterOutWorkspacePP) myXmobarPP >>= xmonadPropLog
        , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
        }
        `removeKeysP`
        [ "M-S-<Return>"
        , "M-p", "M-S-p"
        , "M-S-c"
        , "M-<Space>", "M-S-<Space>"
        , "M-n"
        , "M-<Tab>", "M-S-<Tab>"
        , "M-j", "M-k", "M-m"
        , "M-<Return>"
        , "M-S-j", "M-S-k"
        , "M-h", "M-l"
        , "M-t"
        , "M-,", "M-."
        , "M-S-q", "M-q"
        , "M-S-/", "M-?"
        -- about workspaces
        , "M-7", "M-8", "M-9"
        , "M-S-7", "M-S-8", "M-S-9"
        -- about screens
        , "M-w", "M-e", "M-r"
        , "M-S-w", "M-S-e", "M-S-r"
        ]
        `additionalKeysP`
        [ -- about wm
          ("M-C-r",  spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
        , ("M-C-q", confirmPrompt myPromptConfig "exit" (io exitSuccess))

          -- open and close windows
        , ("M-<Return>", spawn myTerminal)
        , ("M-<Space>", spawn  "rofi -combi-modi drun,run -show combi -modi combi")
        , ("M-S-q", kill)
        , ("<F1>", namedScratchpadAction myScratchpads "keepassxc")
        , ("M-e", namedScratchpadAction myScratchpads "filemanager")
        , ("M-c", namedScratchpadAction myScratchpads "calculator")
        , ("M-n s", namedScratchpadAction myScratchpads "systray")

          -- window's state
        , ("M-C-f", withFocused $ windows . W.sink) -- sink floating window

          -- layouts
        , ("M-C-<Tab>", sendMessage NextLayout)
        , ("M-f", sendMessage (Toggle "Full"))

          -- focus window
        , ("M-j", windows W.focusDown)
        , ("M-k", windows W.focusUp)

          -- move window
        , ("M-S-j", windows W.swapDown)
        , ("M-S-k", windows W.swapUp)
        , ("M-m",   dwmpromote)

          -- resize window
        , ("M-l", sendMessage Expand)
        , ("M-h", sendMessage Shrink)
        , ("M-S-l", sendMessage MirrorExpand)
        , ("M-S-h", sendMessage MirrorShrink)

          -- custom
        , ("<XF86AudioRaiseVolume>", spawn ("pactl set-sink-volume 0 +5%"))
        , ("<XF86AudioLowerVolume>", spawn ("pactl set-sink-volume 0 -5%"))
        , ("<XF86AudioPlay>",        spawn ("pactl set-sink-mute 0 toggle"))
        ]
        -- `additionalKeys`
        -- mod-{1..6} %! Switch to workspace 1..6
        -- mod-shift-{1..6} %! Move client to workspace 1..6
        -- [((m .|. myModMask, k), windows $ f i)
         -- | (i, k) <- zip myWorkspaces [xK_1 .. xK_6]
         -- , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
        `additionalKeys`
        -- mod-{7,8,9} %! Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{7,8,9} %! Move client to screen 1, 2, or 3
        [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_7, xK_8, xK_9] [0..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myModMask = mod4Mask
myTerminal = "alacritty"

myWorkspaces = ["1", "2", "3", "4", "5", "6"]

myScratchpads =
    [ NS "keepassxc" "keepassxc" (className =? "KeePassXC") defaultFloating
    , NS "filemanager" "kitty --class=monfm vifm" (className =? "monfm") defaultFloating
    , NS "systemmonitor" "gnome-system-monitor" (className =? "Gnome-system-monitor") defaultFloating
    , NS "calculator" "gnome-calculator" (className =? "Gnome-calculator") defaultFloating
    ]

myWorkspaceIndices = Map.fromDistinctAscList $ zipWith (,) myWorkspaces [1..]
wrapWithClick a b ws = "<action=xdotool key super+"++show i++">"++a++ws++b++"</action>"
    where i = myWorkspaceIndices Map.! ws

myXmobarPP = def
    { ppCurrent = xmobarColor "orange" "" . wrap "[" "]"
    , ppVisible = wrapWithClick "(" ")"
    , ppHidden = wrapWithClick " " "’"
    , ppHiddenNoWindows = wrapWithClick " " " " -- const ""
    , ppUrgent  = xmobarColor "red" "gray"
    , ppSep     = " | "
    , ppWsSep   = ""
    , ppTitle   = xmobarColor "#aaaaff"  "" . shorten 80
    , ppLayout  = const ""
    }

---------------------------------------------------------------------------------------------------
-- Layouts
myLayouts = toggleLayouts (noBorders Full) (myTabbed ||| myTiled)
    where
        myTiled = ResizableTall 1 (5/100) (3/5) []
        myTabbed = noBorders $ tabbedAlways shrinkText myTabConf

myTabConf = def
    { fontName = "xft:DejaVu Sans Mono:size=10:antialias=true"
    , activeColor         = "#267326"
    , activeBorderColor   = "#40bf40"
    , activeTextColor     = "#ffffff"
    , inactiveColor       = "#496749"
    , inactiveBorderColor = "#333333"
    , inactiveTextColor   = "#dddddd"
    , urgentColor         = "#900000"
    , urgentBorderColor   = "#2f343a"
    , urgentTextColor     = "#ffffff"
    }

---------------------------------------------------------------------------------------------------
-- Prompt
myPromptConfig = def
    { position          = Top
    , alwaysHighlight   = True
    , promptBorderWidth = 0
    , font              = "xft:monospace:size=9"
    }

---------------------------------------------------------------------------------------------------
-- Windows
myManageHook = composeOne
    [ transience
    , isDialog -?> doFloat
    ] <+> composeAll
    [ isModal --> (doShiftMaster <+> doFloat),
      className =? "Gnome-calculator" --> doCenterFloat,
      className =? "Gnome-system-monitor" --> doCenterFloat,
      className =? "Org.gnome.Nautilus" --> doCenterFloat,
      className =? "Pavucontrol" --> doFloat,
      className =? "Hiro" --> doCenterFloat,
      className =? "keepassxc" --> doCenterFloat,
      className =? "org.remmina.Remmina" --> doFloat,
      className =? "pritunl" --> doFloat,
      className =? "retroarch" --> doCenterFloat
    ] <+> namedScratchpadManageHook myScratchpads

isModal :: Query Bool
isModal = isInProperty "_NET_WM_STATE" "_NET_WM_STATE_MODAL"

doShiftMaster :: ManageHook
doShiftMaster = ask >>= \w -> doF W.shiftMaster
