---------------------------------------------------------------------------------------------------
-- KWS Xmonad conf
module Main (main) where

---------------------------------------------------------------------------------------------------
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.DwmPromote (dwmpromote)
import XMonad.Config.Desktop (desktopConfig, desktopLayoutModifiers)
import XMonad.Hooks.DynamicLog (dynamicLogString, xmonadPropLog)
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import XMonad.Hooks.InsertPosition (Focus(..), Position(..), insertPosition)
import XMonad.Hooks.ManageHelpers (composeOne, doRectFloat, doCenterFloat, transience, isDialog, (-?>))
import XMonad.Layout.BoringWindows (boringWindows, focusUp, focusDown, focusMaster)
import XMonad.Layout.Minimize (minimize, minimizeWindow, MinimizeMsg(..))
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.Tabbed (tabbedAlways, shrinkText, Theme(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt (confirmPrompt)
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig (removeKeysP, additionalKeys, additionalKeysP)
import XMonad.Util.NamedScratchpad (NamedScratchpad(NS),
                                    namedScratchpadAction,
                                    namedScratchpadManageHook,
                                    defaultFloating)

import qualified Data.Map as M
import qualified XMonad.StackSet as W

---------------------------------------------------------------------------------------------------
centerRect = W.RationalRect 0.20 0.20 0.6 0.6

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Float a window in the centre
centreFloat' w = windows $ W.float w centerRect

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()


-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centreFloat')


myModMask = mod4Mask
myTerminal = "kitty"
myScratchpads =
    [ NS "keepassxc" "keepassxc" (className =? "keepassxc") defaultFloating ]

main = do
    xmonad $ desktopConfig
        { modMask = myModMask
        , normalBorderColor  = "#104010"
        , focusedBorderColor = "#CC5522" -- "#709548"
        , terminal = myTerminal
        , borderWidth = 1
        , workspaces = ["I", "II", "III", "IV", "V", "VI"]
        , focusFollowsMouse = False
        , clickJustFocuses = False

        , manageHook = insertPosition Below Newer <+> myManageHook <+> manageHook desktopConfig
        , layoutHook = desktopLayoutModifiers $ boringWindows $ minimize $ myLayouts
        , logHook = (dynamicLogString def >>= xmonadPropLog) <+> logHook desktopConfig
        , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
        }
        `removeKeysP`
        [ "M-S-<Return>"
        , "M-p" , "M-S-p"
        , "M-S-c"
        , "M-n"
        , "M-t"
        , "M-/", "M-?"
        -- about workspaces
        , "M-7", "M-8", "M-9"
        , "M-S-7", "M-S-8", "M-S-9"
        -- about screens
        , "M-w", "M-e", "M-r"
        , "M-S-w", "M-S-e", "M-S-r"
        ]
        `additionalKeysP`
        [ -- launching and killing
          ("M-<Return>", spawn myTerminal)
        , ("M-<Space>", spawn  "rofi -combi-modi drun,run -show combi -modi combi")
        , ("M-S-q", kill)
        , ("M-c", sendMessage NextLayout)
        , ("M-S-r", refresh)

          -- move focus
        , ("M-<Tab>",   focusDown)
        , ("M-S-<Tab>", focusUp)
        , ("M-j", focusDown)
        , ("M-k", focusUp)
        , ("M-<Right>", focusDown)
        , ("M-<Left>",  focusUp)
        , ("M-o", spawn  "rofi -show window")

          -- move window
        , ("M-m",   dwmpromote)
        , ("M-S-j", windows W.swapDown)
        , ("M-S-k", windows W.swapUp)
        , ("M-S-<Right>", windows W.swapDown)
        , ("M-S-<Left>",  windows W.swapUp)
        , ("M-i",  withFocused minimizeWindow)
        , ("M-S-i",  sendMessage RestoreNextMinimizedWin)

          -- resize window
        , ("M-h", sendMessage Shrink)
        , ("M-l", sendMessage Expand)

          -- floating support
        , ("M-w", toggleFloat)

          -- quit, restart
        , ("M-S-e", confirmPrompt myPromptConfig "exit" (io exitSuccess))

          -- custom
        , ("M-f", sendMessage (Toggle "Full"))
        , ("<F1>", namedScratchpadAction myScratchpads "keepassxc")

        , ("<XF86AudioRaiseVolume>", spawn ("pactl set-sink-volume 0 +5%"))
        , ("<XF86AudioLowerVolume>", spawn ("pactl set-sink-volume 0 -5%"))
        , ("<XF86AudioPlay>",        spawn ("pactl set-sink-mute 0 toggle"))
        ]
        `additionalKeys`
        -- mod-{7,8,9} %! Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{7,8,9} %! Move client to screen 1, 2, or 3
        [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_7, xK_8, xK_9] [0..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

---------------------------------------------------------------------------------------------------
-- Layouts
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

myLayouts = toggleLayouts myFull $ (myTabbed ||| myTiled)
    where
        myFull = noBorders Full
        myTiled = ResizableTall 1 (5/100) (1/3) []
        myTabbed = noBorders $ tabbedAlways shrinkText myTabConf

---------------------------------------------------------------------------------------------------
-- Prompt
myPromptConfig = def
    { position          = Top
    , alwaysHighlight   = True
    , promptBorderWidth = 0
    , font              = "xft:monospace:size=9"
    }

---------------------------------------------------------------------------------------------------
-- Hooks
myManageHook = composeOne
  [ transience, isDialog -?> doCenterFloat
  ] <+> composeAll
  [ className =? "Remmina" --> doFloat
  , className =? "keepassxc" --> doFloat
  , className =? "Nautilus" --> doRectFloat centerRect
  , className =? "Gnome-system-monitor" --> doFloat
  , className =? "Pavucontrol" --> doFloat
  , className =? "copyq" --> doFloat
  , className =? "pritunl" --> doFloat
  ] <+> namedScratchpadManageHook myScratchpads
