; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;; get monitor status (temporaly hotkey)
^#o::
SysGet, Nmonitor, MonitorCount
SysGet, Pmonitor, MonitorPrimary
SysGet, M, Monitor, %Nmonitor%
SysGet, monitorArea, MonitorWorkArea, 1
SysGet, Mname, MonitorName, 1
MsgBox, 1, Monitor data, MonitorCount : %NMonitor%`nPrimary : %Pmonitor%`nMonitor : %M%`nMonitorArea : %monitorArea%`nName : %MonitorName% , 100
Return

^#r::
Reload
Return


;; Window controlls
;; http://ahkwiki.net/WinMove
setWinSize() {
  global
  SysGet, DisplayWidth, 61
  SysGet, DisplayHeight, 62
  SysGet, MonitorWorkArea, MonitorWorkArea, 1
  MonitorAreaXoffset = -6
  MonitorAreaYoffset = -3
  MonitorWidthOffset = 7
  MonitorWidthHalfOffset := 14
  WinPosRightOffset = 8
  WinPosLeft := MonitorWorkAreaLeft + MonitorAreaXoffset
  WinPosRight := MonitorWorkAreaRight / 2 + MonitorAreaXoffset - WinPosRightOffset
  WinPosRight2 := MonitorWorkAreaRight / 3 * 1 + MonitorAreaXoffset - WinPosRightOffset
  WinPosRight3 := MonitorWorkAreaRight / 3 * 2 + MonitorAreaXoffset - WinPosRightOffset
  WinPosTop := MonitorWorkAreaTop + MonitorAreaYoffset
  WinWidth := MonitorWorkAreaRight - MonitorAreaXoffset + MonitorWidthOffset
  WinHeight := MonitorWorkAreaBottom - MonitorAreaYoffset * 3
  WinWidthHalf := WinWidth / 2 + MonitorWidthHalfOffset
  WinWidthOneThird := WinWidth / 3 + MonitorWidthHalfOffset
  WinWidthTwoThird := WinWidth / 3 * 2 + MonitorWidthHalfOffset

  ; MsgBox, %WinPosLeft% %WinPosTop% %DisplayWidth% %DisplayHeight% %MonitorWorkAreaRight% %MonitorWorkAreaBottom% %WinWidthHalf%
}

vFlg := 0

^!w::
    setWinSize()
    If m_win_left = 0
    {
        WinMove,A ,,%WinPosLeft%, %WinPosTop%, %WinWidthHalf%,  %WinHeight%
        m_win_left = 1
    }
    Else If m_win_left = 1
    {
        WinMove,A ,,%WinPosLeft%, %WinPosTop%, %WinWidthOneThird%,  %WinHeight%
        m_win_left = 2
    }
    Else If m_win_left = 2
    {
        WinMove,A ,,%WinPosLeft%, %WinPosTop%, %WinWidthTwoThird%,  %WinHeight%
        m_win_left = 0
        Return
    }
    SetTimer, init_m_win_left, 400
    Return

^!e::
    If m_win_right = 0
    {
        WinMove,A ,,%WinPosRight%, %WinPosTop%, %WinWidthHalf%,  %WinHeight%
        m_win_right = 1
    }
    Else If m_win_right = 1
    {
        WinMove,A ,,%WinPosRight3%, %WinPosTop%, %WinWidthOneThird%,  %WinHeight%
        m_win_right = 2
    }
    Else If m_win_right = 2
    {
        WinMove,A ,,%WinPosRight2%, %WinPosTop%, %WinWidthTwoThird%,  %WinHeight%
        m_win_right = 0
        Return
    }
    SetTimer, init_m_win_right, 400
    Return
^!r::
    If m_win_center = 0
    {
        WinMove,A ,,%WinPosLeft%, %WinPosTop%, %WinWidth%,  %WinHeight%
        m_win_center = 1
    }
    Else If m_win_center = 1
    {
        WinMove,A ,,%WinPosLeft%, %WinPosTop%, %WinWidth%,  %WinHeight%
        m_win_center = 0
        Return
    }
    SetTimer, init_m_win_center, 400
    Return

init_m_win_left:
    m_win_left = 0
    Return
init_m_win_right:
    m_win_right = 0
    Return
init_m_win_center:
    m_win_center = 0
    Return


;; IME setting
#Include IME.ahk

RShift_State = 0
*RShift Up::
    Send, {Shift up}
    If IME_GET() AND (RShift_state <> 1) {
       IME_SET(0)
    }
    RShift_State = 0
    Return

*RShift::
    Send, {Shift Down}
    KeyWait, RShift, T0.2
    If (ErrorLevel)
    {
        RShift_State = 1
    }
    Return

sc029::IME_SET(1)

#Include MyEmacsKeymap.ahk
