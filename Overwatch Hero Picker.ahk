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

IniRead, y, Config.ini, Hero Icons, yPosition , 888

IniRead, yRoles, Config.ini, Role Icons, yPosition , 832

IniRead, xOffense, Config.ini, Offense Icons, xPosition , 112
IniRead, xDefense, Config.ini, Defense Icons, xPosition , 641
IniRead, xTank, Config.ini, Tank Icons, xPosition , 1044
IniRead, xSupport, Config.ini, Support Icons, xPosition , 1446

IniRead, xAbilities, Config.ini, Abilities Button, xPosition , 1815
IniRead, yAbilities, Config.ini, Abilities Button, yPosition , 120

IniRead, xContinue, Config.ini, Continue Button, xPosition , 960
IniRead, yContinue, Config.ini, Continue Button, yPosition , 1000

Gui, Font, s10
Gui, Add, Text,, Select a hero
Gui, Add, DropDownList,w85 vElement gAction, %names%
Gui, Add, Text,,Press F2 to toggle. The selected`nhero will be picked as soon as the`nselection screen appears.`n`n
Gui, Show, w225 h145, Hero Picker
return

x =
y =
name =

Action:
Gui, Submit, nohide
x = % heroes[Element]
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
        PixelGetColor, offense, xOffense, yRoles
        PixelGetColor, defense, xDefense, yRoles
        PixelGetColor, tank, xTank, yRoles
        PixelGetColor, support, xSupport, yRoles
        
        PixelGetColor, abilities, xAbilities, yAbilities
        
        OutputDebug, % abilities

        if Compare(ToRGB(offense), ToRGB(0xffffff),5) && Compare(ToRGB(defense), ToRGB(0xffffff),5) && Compare(ToRGB(tank), ToRGB(0xffffff),5) && Compare(ToRGB(support), ToRGB(0xffffff),5) &&Compare(ToRGB(abilities), ToRGB(0xFFF19B),120){
        MouseClick, left, x, y
        Sleep, 51
        MouseClick, left, 956, 1010
        SoundPlay, confirm.wav
        toggle := false
        }
    }
}
return
