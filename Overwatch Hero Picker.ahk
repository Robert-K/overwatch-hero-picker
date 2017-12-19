#NoEnv
SendMode Input
#SingleInstance Force
#MaxThreadsPerHotkey 2
SetWorkingDir %A_ScriptDir%

FileInstall, enable.wav, enable.wav
FileInstall, disable.wav, disable.wav
FileInstall, confirm.wav, confirm.wav

heroes:=Object()
names:=Object()

Loop, Read, Hero List.txt
{
    StringSplit, line, A_LoopReadLine, :, %A_Space%%A_Tab%
    heroes[line1] := line2
}

for i, element in heroes
    names .= i . "|"

Gui, Font, s10
Gui, Add, Text,, Select a hero
Gui, Add, DropDownList,w85 vElement gAction, %names%
Gui, Add, Text,,Press F2 to toggle. The selected`nhero will be picked as soon as the`nselection screen appears.`n`n(C) Robert Kossessa 2017
Gui, Show, w225 h145, Hero Picker
return

x =
y =
name =

Action:
Gui, Submit, nohide
x = % heroes[Element]
y = 888
name = % Element
return

GuiClose:
ExitApp

ToRGB(color) {
    return { "r": (color >> 16) & 0xFF, "g": (color >> 8) & 0xFF, "b": color & 0xFF }
}

Compare(c1, c2, vary) {
    rdiff := Abs( c1.r - c2.r )
    gdiff := Abs( c1.g - c2.g )
    bdiff := Abs( c1.b - c2.b )

    return rdiff <= vary && gdiff <= vary && bdiff <= vary
}
toggle=false
F2::
if !x
    return
toggle := !toggle
if !toggle {
    SoundPlay, disable.wav
    return
}
SoundPlay, enable.wav
Loop
{    
    if !toggle
        break
    
    IfWinActive, Overwatch
    {
        PixelGetColor, offense, 101, 888
        PixelGetColor, defense, 637, 892
        PixelGetColor, tank, 1060, 888
        PixelGetColor, support, 1480, 888

        if Compare(ToRGB(offense), ToRGB(0xffffff),5) && Compare(ToRGB(offense), ToRGB(0xffffff),5) && Compare(ToRGB(offense), ToRGB(   0xffffff),5) && Compare(ToRGB(offense), ToRGB(0xffffff),5) {
        MouseClick, left, x, y
        Sleep, 51
        MouseClick, left, 956, 1010
        SoundPlay, confirm.wav
        toggle := false
        }
    }
}
return