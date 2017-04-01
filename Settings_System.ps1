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
   ____ _   _ ____ ___ ____ _  _ 
   [__   \_/  [__   |  |___ |\/| 
   ___]   |   ___]  |  |___ |  | 
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


#region Settings: System options
Write-Host "`r`n`r`nCHANGING SYSTEM OPTIONS" -ForegroundColor "Green"

If ($myOS.BuildNumber -ge 14393) {    # Apply only for version 1607 (Redstone 1) or newer
'    System -> Notifications & actions -> Get notifications from apps and other senders (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\' `
                  -Name 'SoftLandingEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

'    System -> Notifications & actions -> Show notifications on the lock screen (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\' `
                  -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Notifications & actions -> Show alarms, reminders, and incoming VoIP calls on the lock screen (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\' `
                  -Name 'NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Notifications & actions -> Hide notifications when duplicating the screen (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\' `
                  -Name 'NOC_GLOBAL_SETTING_SUPRESS_TOASTS_WHILE_DUPLICATING' `
                  -Value 1 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    System -> Notifications & actions -> Get tips, tricks, and suggestions as you use Windows (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\' `
                  -Name 'SoftLandingEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

'    System -> Notifications & actions -> Show app notifications (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications\' `
                  -Name 'ToastEnabled' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Offline maps -> Metered connections (off)'
Set-RegistryValue -Path 'HKLM:SYSTEM\Maps\' `
                  -Name 'UpdateOnlyOnWifi' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Offline maps -> Automatically update maps (on)'
Set-RegistryValue -Path 'HKLM:SYSTEM\Maps\' `
                  -Name 'AutoUpdateEnabled' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Tablet mode (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'TabletMode' `
                  -Value 0 `
                  -Type 'DWord'

'    System -> Tablet mode -> When I sign in: go to the desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'SignInMode' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Use tablet mode
                        1 = Use desktop mode
                        2 = Use the appropriate mode for my hardware
                  #>

'    System -> Tablet mode -> When automatically switching tablet mode on/off (always ask)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'ConvertibleSlateModePromptPreference' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Don't ask and don't switch
                        1 = Always ask before switching
                        2 = Don't ask and always switch
                  #>

'    System -> Tablet mode -> Hide app icons on the taskbar in tablet mode (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarAppsVisibleInTabletMode' `
                  -Value 1 `
                  -Type 'DWord' `
                  -OnError 'SilentlyContinue'

'    System -> Tablet mode -> Automatically hide the taskbar in tablet mode (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TaskbarAutoHideInTabletMode' `
                  -Value 0 `
                  -Type 'DWord' `
                  -OnError 'SilentlyContinue'

'    System -> Multitasking -> Snap (on)'
#Write-Host '        └-> Error.' -ForegroundColor "Red"
Set-RegistryValue -Path 'HKCU:Control Panel\Desktop\' `
                  -Name 'WindowArrangementActive' `
                  -Value 1

'    System -> Multitasking -> When I snap a window, automatically size it to fill available space (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'SnapFill' `
                  -Value 1 `
                  -Type 'DWord'

'    System -> Multitasking -> When I snap a window, show what I can snap next to it (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'SnapAssist' `
                  -Value 0 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    System -> Multitasking -> When I resize a snapped a window, resize any other snapped windows (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'JointResize' `
                  -Value 1 `
                  -Type 'DWord'
}

<#'    System -> Multitasking -> Virtual desktops -> On the taskbar, show windows that are open on: only the desktop used'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'VirtualDesktopTaskbarFilter' `
                  -Value 0 `
                  -Type 'DWord'

'    System -> Multitasking -> Virtual desktops -> Pressing ALT+TAB shows windows that are open on: only the desktop used'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'VirtualDesktopAltTabFilter' `
                  -Value 1 `
                  -Type 'DWord'#>
                  
                  
'    Enable hidden "System -> Share" page on Settings (on)'
Set-RegistryValue -Path 'HKCU:Control Panel\' `
                  -Name 'EnableShareSettings' `
                  -Value 1 `
                  -Type 'DWord'
                  
'    System -> Share -> Show apps I use most often at the top of the app list (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Start_TrackShareContractMFU' `
                  -Value 0 `
                  -Type 'DWord'
                  
'    System -> Share -> Show a list of how I share most often (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Start_TrackShareContractHistory' `
                  -Value 1 `
                  -Type 'DWord'
                  
'    System -> Share -> Items in list: 5'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Start_ShareContractHistoryCount' `
                  -Value 5 `
                  -Type 'DWord'
                  <# VALUE is the count in hexadecimal. Examples:
                  		Value = 5     |    Count = 5    |    works
                  		Value = "A"   |    Count = 10   |    doesn't work
                  		Value = 14    |    Count = 20   |    works
                  #>

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
