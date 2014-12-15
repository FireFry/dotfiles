-- Core
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS (nextScreen,prevScreen)
import Data.List
 
-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell
 
-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
 
-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.DragPane
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.DecorationMadness
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Layout.LayoutHints

import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers

defaults = defaultConfig {
        terminal		= "urxvt"
        , normalBorderColor  = "black"
        , focusedBorderColor  = "orange"        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , borderWidth         = 2
        , startupHook         = setWMName "LG3D"
        , layoutHook          = myLayoutHook
        , manageHook          = myManageHooks
        , handleEventHook     = fullscreenEventHook
	}`additionalKeys` myKeys

myWorkspaces :: [String]
myWorkspaces = map show [1..9]

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "green"
xmobarVisibleWorkspaceColor = "#CEFFAC"
xmobarHiddenWorkspaceColor = "#666666"

myLayoutHook = spacing 10 $ gaps [(U,15)] $ toggleLayouts (noBorders Full) $
    smartBorders $ tiled ||| Mirror tiled ||| Full
      where 
        tiled = Tall nmaster delta ratio
        nmaster = 1
        delta   = 3/100
        ratio   = 1/2

myManageHooks = composeAll
	[ isFullscreen --> doFullFloat
	]
	
myKeys = [
           ((mod4Mask, xK_Right), nextScreen) 
         , ((mod4Mask .|. controlMask, xK_Left ), prevScreen)
         , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
         , ((mod4Mask, xK_s), spawnSelected defaultGSConfig ["chromium","idea","gvim"])
         , ((mod4Mask, xK_KP_Add), spawn "amixer set Master 10%+ && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
         , ((mod4Mask, xK_KP_Subtract), spawn "amixer set Master 10%- && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
         , ((mod4Mask, xK_b     ), sendMessage ToggleStruts)
         ]

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaults {
	logHook =  dynamicLogWithPP $ defaultPP {
            ppOutput = System.IO.hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
          , ppHidden = xmobarColor xmobarVisibleWorkspaceColor "" . wrap " " " "
          , ppHiddenNoWindows = xmobarColor xmobarHiddenWorkspaceColor "" . wrap " " " "
          , ppSep = "   "
          , ppWsSep = " "
      } 
}
