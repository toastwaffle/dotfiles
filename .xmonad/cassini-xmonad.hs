import XMonad
import XMonad.ManageHook
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh,fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Renamed
import XMonad.Layout.MultiColumns
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutHints
import XMonad.Layout.Tabbed
import XMonad.Util.Run (safeSpawn,spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Scratchpad
import Data.List
import Data.Monoid (mappend)
import Data.Ratio ((%))
import System.IO
import qualified XMonad.StackSet as W
import XMonad.Util.WorkspaceCompare
import qualified XMonad.Actions.FlexibleResize as Flex
import qualified Data.Map as M

myManageHook = composeAll . concat $
    [ [ className =? c --> doFloat | c <- myClassFloats ]
    , [ className =? "Chromium" --> doShift "1" ]
    , [ className =? "Spotify" --> doShift "2" ]
    , [ className =? "Sublime_text" --> doShift "3" ]
    , [ className =? "Org.gnome.Nautilus" --> doShift "4" ]
    , [ className =? "Skype" --> doShift "9" ]
    , [ className =? "Xfce4-notifyd" --> doIgnore ]
    , [ queryNotElem className myUnshiftedClasses --> doShift "5" ]
    , [ isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
    ]
    where
        myClassFloats = ["Scratchpad", "Pinentry"]
        myUnshiftedClasses = ["Chromium", "Spotify", "Sublime_text", "Org.gnome.Nautilus", "Skype", "Xfce4-notifyd", "Xfce4-terminal", "Scratchpad", "Pinentry"]

manageScratchPad = scratchpadManageHook (W.RationalRect 0 0 1 0.5)

myWorkspaces = map show [1 .. 9]

-- Default number of windows in master pane
layoutNMaster = 1
-- Default proportion of screen occupied by master
layoutRatio = 1/2
-- Percent of screen to increment by when resizing
layoutDelta = 1/182

tiledPart = Tall layoutNMaster layoutDelta layoutRatio

myTheme = def { fontName = "xft:Ubuntu Mono:size=10"
              , decoHeight = 40
              }

myTabbed = tabbed shrinkText myTheme

tiledLayout = myTabbed ||| tiledPart ||| Mirror tiledPart ||| Full ||| Grid

myMouse x = [ ((controlMask .|. mod4Mask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) ]

newMouse x = M.union (mouseBindings def x) (M.fromList (myMouse x))

myKeys =
    [ ((controlMask .|. mod1Mask, xK_l), spawn "lock")
    , ((shiftMask .|. mod4Mask, xK_w), spawn "systemctl reboot")
    , ((mod4Mask, xK_w), spawn "systemctl poweroff")
    , ((controlMask, xK_F1), spawn "chromium")
    , ((controlMask, xK_F2), spawn "spotify")
    , ((controlMask, xK_F3), spawn "subl")
    , ((controlMask, xK_F4), spawn "nautilus")
    , ((0, xK_F12), scratchpadSpawnActionCustom "lxterminal --name scratchpad --class Scratchpad --geometry=200x25")
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((0, 0x1008FF11), spawn "volume -5%")
    , ((0, 0x1008FF12), spawn "volume toggle-mute")
    , ((0, 0x1008FF13), spawn "volume +5%")
    , ((0, 0x1008FF14), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    , ((0, 0x1008FF16), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
    , ((0, 0x1008FF17), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
    ]

boringWorkspaces :: [String]
boringWorkspaces = ["NSP"]

queryNotElem :: Query String -> [String] -> Query Bool
queryNotElem a b = do
    aStr <- a
    return (notElem aStr b)

main = do
    xmproc <- spawnPipe "xmobar /home/samuel/.xmobarrc"
    xmonad $ ewmh desktopConfig
        { terminal = "xfce4-terminal"
        , focusedBorderColor = "#8bcd00"
        , modMask = mod4Mask
        , workspaces = myWorkspaces
        , mouseBindings = newMouse
        , manageHook = myManageHook <+> manageScratchPad <+> manageHook desktopConfig
        , layoutHook = desktopLayoutModifiers $ tiledLayout
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#ff007f" "" . shorten 80
                        , ppHidden = \x -> if x `elem` boringWorkspaces then "" else x
                        }
        } `additionalKeys` myKeys
