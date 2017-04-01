############################################################
# (c) Daniel Petrescu
############################################################
# The software is provided "as is", without warranty of any kind, express or implied, including but
# not limited to the warranty of fitness for a particular purpose. In no event shall the authors or
# copyright holders be liable for any claim, damages or other liability, whether in an action of
# contract or otherwise, arising from, out of, or in connection with the software or the use or
# other dealings in the software.
############################################################


### Get variables
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptpath
Push-Location $scriptDir
. '.\Variables.ps1'


############################################################


#region Script Init

### Copy the output to a log file
$ScriptName = ([io.fileinfo]$MyInvocation.MyCommand.Name).basename
$OutputFileLocation = "$($PSScriptRoot)\logs\$($ScriptName)_output_$($TheDateOutput).txt"
''
Start-Transcript -path $OutputFileLocation -append
''

### Print headers
$scriptLogo = @"
   ___  ____ ____ ____ ____ _  _ ____ _    _ ____ ____ ___ _ ____ _  _ 
   |__] |___ |__/ [__  |  | |\ | |__| |    | [__  |__|  |  | |  | |\ | 
   |    |___ |  \ ___] |__| | \| |  | |___ | ___] |  |  |  | |__| | \| 
"@
Print-Headers "$scriptLogo"

#endregion


##############################


#region Start Script

Write-Host "`r`n===== START =====" -ForegroundColor "Black" -BackgroundColor "yellow"

### Make sure the Execution Policy is 'Unrestricted'
$currentExecutionPolicy = Get-ExecutionPolicy
$resetExecutionPolicy = 0
Write-Host "`r`n$myOSstring"
Write-Host "`r`nThe current Execution Policy is: $currentExecutionPolicy" -ForegroundColor "Gray"
if ($currentExecutionPolicy -ne "Unrestricted") {
    $resetExecutionPolicy = 1
    Write-Host 'Setting Execution Policy to: Unrestricted. This will be changed back at the end of the script.' -ForegroundColor "Gray"
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
}

#endregion


############################################################


#region Settings: Personalisation options
Write-Host "`r`n`r`nCHANGING PERSONALISATION OPTIONS" -ForegroundColor "Green"

<#'    Personalization -> Colors -> Accent color'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\S-1-5-21-1779794566-258786271-1422341266-1001\AnyoneRead\Colors\' `
                  -Name 'StartColor' `
                  -Value 0xFF9E5A00
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\S-1-5-21-1779794566-258786271-1422341266-1001\AnyoneRead\Colors\' `
                  -Name 'AccentColor' `
                  -Value 0xFFD77800#>

'    Personalization -> Colors -> Make Start, taskbar, and action center transparent (on)'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\' `
                  -Name 'EnableTransparency' `
                  -Value 1 `
                  -Type 'DWord'

'    Personalization -> Colors -> Show color on Start, taskbar, and action center (on)'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\' `
                  -Name 'ColorPrevalence' `
                  -Value 1 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Personalization -> Colors -> Show color on title bar (on)'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM\' `
                  -Name 'ColorPrevalence' `
                  -Value 1 `
                  -Type 'DWord'
}

If ($myOS.BuildNumber -ge 14393) {    # Apply only for version 1607 (Redstone 1) or newer
'    Personalization -> Colors -> App mode: light'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\' `
                  -Name 'AppsUseLightTheme' `
                  -Value 1 `
                  -Type 'DWord'
}

If ($myOS.BuildNumber -ge 14393) {    # Apply only for version 1607 (Redstone 1) or newer
'    Personalization -> Lock screen -> Get fun facts, tips, tricks, and more on your lock screen (off)'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\' `
                  -Name 'RotatingLockScreenOverlayEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

<#If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Personalization -> Lock screen -> Show lock screen background picture on the sign-in screen (on)'
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\S-1-5-21-1779794566-258786271-1422341266-1001\AnyoneRead\LockScreen\' `
                  -Name 'HideLogonBackgroundImage' `
                  -Value 0 `
                  -Type 'DWord'
}#>

<# '    Personalization -> Start -> Show more tiles (on)' #>

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Personalization -> Start -> Occasionally show suggestions in Start (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\' `
                  -Name 'SystemPaneSuggestionsEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

'    Personalization -> Start -> Show most used apps (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Start_TrackProgs' `
                  -Value 1 `
                  -Type 'DWord'

<# ... #>

'    Personalization -> Taskbar -> Lock the taskbar (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarSizeMove' `
                  -Value 0 `
                  -Type 'DWord'

'    Personalization -> Taskbar -> Use small taskbar buttons (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarSmallIcons' `
                  -Value 0 `
                  -Type 'DWord'

'    Personalization -> Taskbar -> Use peek to preview the desktop (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'DisablePreviewDesktop' `
                  -Value 0 `
                  -Type 'DWord'

'    Personalization -> Taskbar -> Use Powershell on WIN+X (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'DontUsePowerShellOnWinX' `
                  -Value 1 `
                  -Type 'DWord'

'    Personalization -> Taskbar -> Show badges on taskbar buttons (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarBadges' `
                  -Value 1 `
                  -Type 'DWord'

'    Personalization -> Taskbar -> Combine taskbar buttons: "Always combine, hide labels"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarGlomLevel' `
                  -Value 0 `
                  -Type 'DWord'
                  <# OPTIONS:
                    0 = Always combine, hide labels
                    1 = Combine when taskbar is full
                    2 = Never combine
                  #>

'    Taskbar -> "Show Task View button" (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowTaskViewButton' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                    0 = Off
                    1 = On
                  #>

'    Taskbar -> "Cortana" (icon)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search\' `
                  -Name 'SearchboxTaskbarMode' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                    0 = Hidden
                    1 = Show Cortana icon
                    2 = Show search box
                  #>

'    Taskbar -> Windows Search -> My device history (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search\' `
                  -Name 'HistoryViewEnabled' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search\' `
                  -Name 'DeviceHistoryEnabled' `
                  -Value 0 `
                  -Type 'DWord'

'    Taskbar -> Increased transperancy (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'UseOLEDTaskbarTransparency' `
                  -Value 0 `
                  -Type 'DWord'

'    Cortana (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\Windows Search\' `
                  -Name 'AllowCortana' `
                  -Value 0 `
                  -Type 'DWord'

'    Bing Search (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search\' `
                  -Name 'BingSearchEnabled' `
                  -Value 0 `
                  -Type 'DWord'

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
