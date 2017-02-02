import XMonad
import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh,fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
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
    , [ className =? "Subl3" --> doShift "3" ]
    , [ className =? "Nautilus" --> doShift "4" ]
    , [ className =? "Skype" --> doShift "9" ]
    , [ className =? "Xfce4-notifyd" --> doIgnore ]
    , [ queryNotElem className myUnshiftedClasses --> doShift "5" ]
    , [ isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
    , [ manageDocks ]
    ]
    where
        myClassFloats = ["Scratchpad", "Pinentry"]
        myUnshiftedClasses = ["Chromium", "Spotify", "Subl3", "Nautilus", "Skype", "Xfce4-notifyd", "Xfce4-terminal", "Scratchpad", "Pinentry"]

manageScratchPad = scratchpadManageHook (W.RationalRect 0 0 1 0.5)

myWorkspaces = map show [1 .. 9]

-- Default number of windows in master pane
layoutNMaster = 1
-- Default proportion of screen occupied by master
layoutRatio = 1/2
-- Percent of screen to increment by when resizing
layoutDelta = 1/182

tiledPart = Tall layoutNMaster layoutDelta layoutRatio

tiledLayout = simpleTabbed ||| tiledPart ||| Mirror tiledPart ||| Full ||| Grid

skypeRoster  = (ClassName "Skype")                  `And`
               (Not (Title "Options"))              `And`
               (Not (Title "File Transfers"))       `And`
               (Not (Title "Add a Skype Contact"))  `And`
               (Not (Title "Add to Chat"))          `And`
               (Not (Role "ConversationsWindow"))   `And`
               (Not (Role "CallWindow"))

imLayout = renamed [CutWordsLeft 2] $
           withIM (1%6) (skypeRoster) $
           reflectHoriz $ withIM (1%5) (Role "buddy_list") $
           tiledLayout

myMouse x = [ ((controlMask .|. mod4Mask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) ]

newMouse x = M.union (mouseBindings defaultConfig x) (M.fromList (myMouse x))

myKeys =
    [ ((controlMask .|. mod1Mask, xK_l), spawn "lock")
    , ((shiftMask .|. mod4Mask, xK_w), spawn "systemctl reboot")
    , ((mod4Mask, xK_w), spawn "systemctl poweroff")
    , ((shiftMask .|. mod4Mask, xK_a), spawn "keepass --auto-type")
    , ((controlMask, xK_F1), spawn "chromium")
    , ((controlMask, xK_F2), spawn "spotify")
    , ((controlMask, xK_F3), spawn "subl3")
    , ((controlMask, xK_F4), spawn "nautilus")
    , ((0, xK_F12), scratchpadSpawnActionCustom "lxterminal --name scratchpad --class Scratchpad --geometry=200x25")
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((0, 0x1008FF02), spawn "xbacklight -inc 5")
    , ((0, 0x1008FF03), spawn "xbacklight -dec 5")
    , ((0, 0x1008FF11), spawn "volume -5%")
    , ((0, 0x1008FF12), spawn "volume toggle-mute")
    , ((0, 0x1008FF13), spawn "volume +5%")
    , ((mod4Mask .|. shiftMask, xK_Down), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    , ((mod4Mask .|. shiftMask, xK_Left), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
    , ((mod4Mask .|. shiftMask, xK_Right), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
    ]

boringWorkspaces :: [String]
boringWorkspaces = ["NSP"]

queryNotElem :: Query String -> [String] -> Query Bool
queryNotElem a b = do
    aStr <- a
    return (notElem aStr b)

main = do
    xmproc <- spawnPipe "xmobar /home/samuel/.xmobarrc"
    xmonad $ ewmh defaultConfig
        { terminal = "xfce4-terminal"
        , focusedBorderColor = "#8bcd00"
        , modMask = mod4Mask
        , workspaces = myWorkspaces
        , mouseBindings = newMouse
        , manageHook = myManageHook <+> manageHook defaultConfig <+> manageScratchPad
        , layoutHook = smartBorders $ avoidStruts $ onWorkspace "9" imLayout tiledLayout
        , handleEventHook = mappend docksEventHook fullscreenEventHook
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#ff007f" "" . shorten 80
                        , ppHidden = \x -> if x `elem` boringWorkspaces then "" else x
                        -- Comment to report layout
                        --, ppLayout = \x -> ""
                        }
        } `additionalKeys` myKeys
