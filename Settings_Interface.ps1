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
   _ _  _ ___ ____ ____ ____ ____ ____ ____ 
   | |\ |  |  |___ |__/ |___ |__| |    |___ 
   | | \|  |  |___ |  \ |    |  | |___ |___ 
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


#region Settings: Interface options
Write-Host "`r`n`r`nCHANGING INTERFACE OPTIONS" -ForegroundColor "Green"

'    Aero Shake (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'DisallowShaking' `
                  -Value 1 `
                  -Type 'DWord'

'    Wi-Fi Sense (off)'
If ($myOS.BuildNumber -le 10586) {    # Apply only for version 1507 or 1511 (Threshold 1 or 2)
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config\' `
                      -Name 'AutoConnectAllowedOEM' `
                      -Value 0 `
                      -Type 'DWord'
} else {    # Apply only for version 1607 (Redstone 1) or newer
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting\' `
                        -Name 'Value' `
                        -Value 0 `
                        -Type 'DWord'
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots\' `
                        -Name 'Value' `
                        -Value 0 `
                        -Type 'DWord'
}

'    Fast Startup (off)'
Set-RegistryValue -Path 'HKLM:SYSTEM\CurrentControlSet\Control\Session Manager\Power\' `
                  -Name 'HiberbootEnabled' `
                  -Value 0 `
                  -Type 'DWord'

'    Sticky Keys (off)'
Set-RegistryValue -Path 'HKCU:Control Panel\Accessibility\StickyKeys\' `
                  -Name 'Flags' `
                  -Value 506

'    Make desktop menus snappier (20ms)'
Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop\' `
                  -Name 'MenuShowDelay' `
                  -Value 20  # Mininum: 0ms; Maximum: 4000ms; Default: 400ms

'    User Account Control: Full'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\' `
                  -Name 'ConsentPromptBehaviorAdmin' `
                  -Value 2 `
                  -Type 'DWord'

'    OneDrive -> Run at startup (off)'
if ((Get-ItemProperty -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Run\' -Name 'OneDrive' -ErrorAction SilentlyContinue) -ne $null) {
    Remove-ItemProperty -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Run\' -Name 'OneDrive' -Force
}

'    UI -> Use Windows 7/8 UAC prompt (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\TestHooks\' `
                  -Name 'XamlCredUIAvailable' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Windows 10 Anniversary Update style
                        1 = Windows 7/8 style
                  #>

'    UI -> Use Windows 7 volume control (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC\' `
                  -Name 'EnableMtcUvc' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Windows 7 style
                        1 = Windows 10 style
                  #>

### Doesn't work
<#'    UI -> Use Windows 8 network control (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network\' `
                  -Name 'ReplaceVan' `
                  -Value 2 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Default style
                        1 = Windows 8 style
                        2 = Windows 10 style
                  #>

### Doesn't work
<#'    UI -> Use Windows 7 clock & calendar control (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'UseWin32TrayClockExperience' `
                  -Value 0 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Windows 10 style
                        1 = Windows 7 style
                  #>

### Doesn't work
<#'    UI -> Use Windows 7 battery control (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'UseWin32BatteryFlyout' `
                  -Value 0 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Windows 10 style
                        1 = Windows 7 style
                  #>

### Doesn't work
<#'    UI -> Use Windows 8 notification center (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\' `
                  -Name 'UseActionCenterExperience' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Windows 8 style
                        1 = Windows 10 style
                  #>

### Doesn't always work
<#'    UI -> Show "This PC" shortcut on desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"\' `
                  -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\' `
                  -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' `
                  -Value 0 `
                  -Type 'DWord'

'    UI -> Show "User Files" shortcut on desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"\' `
                  -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"\' `
                  -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' `
                  -Value 0 `
                  -Type 'DWord'

'    UI -> Show "Control Panel" shortcut on desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"\' `
                  -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"\' `
                  -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' `
                  -Value 0 `
                  -Type 'DWord'

'    UI -> Show "Network" shortcut on desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"\' `
                  -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"\' `
                  -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' `
                  -Value 0 `
                  -Type 'DWord'

'    UI -> Show "Recycle Bin" shortcut on desktop'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"\' `
                  -Name '{645FF040-5081-101B-9F08-00AA002F954E}' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"\' `
                  -Name '{645FF040-5081-101B-9F08-00AA002F954E}' `
                  -Value 0 `
                  -Type 'DWord'#>
                  
'    UI -> Sign-in screen -> Disable the Password Reveal button (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\CredUI\' `
                  -Name 'DisablePasswordReveal' `
                  -Value 0 `
                  -Type 'DWord'
                  
'    UI -> Sign-in screen -> Disable the Power button (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\CredUI\' `
                  -Name 'DisablePasswordReveal' `
                  -Value 0 `
                  -Type 'DWord'
                  
'    UI -> Lock screen -> Disable the Network button (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\System\' `
                  -Name 'DontDisplayNetworkSelectionUI' `
                  -Value 0 `
                  -Type 'DWord'

'    Always show "Open command window here" on right click for folders and background'
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue | Out-Null
Remove-ItemProperty -Path "HKCR:\Directory\shell\cmd" -Name "Extended" -ErrorAction SilentlyContinue | Out-Null
Remove-ItemProperty -Path "HKCR:\Directory\Background\shell\cmd" -Name "Extended" -ErrorAction SilentlyContinue | Out-Null

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
