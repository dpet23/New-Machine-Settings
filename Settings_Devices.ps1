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
   ___  ____ _  _ _ ____ ____ ____ 
   |  \ |___ |  | | |    |___ [__  
   |__/ |___  \/  | |___ |___ ___] 
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


#region Settings: Devices options
Write-Host "`r`n`r`nCHANGING DEVICES OPTIONS" -ForegroundColor "Green"

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Devices -> Printers & scanners -> Let Windows manage my default printer (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\' `
                  -Name 'LegacyDefaultPrinterMode' `
                  -Value 1 `
                  -Type 'DWord'
}

'    Devices -> Printers & scanners -> Download over metered connections (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup\' `
                  -Name 'CostedNetworkPolicy' `
                  -Value 0 `
                  -Type 'DWord'

<#'    Devices -> Bluetooth (on)'
Set-RegistryValue -Path 'HKLM:SYSTEM\ControlSet001\Services\bthserv\Parameters\BluetoothControlPanelTasks\' `
                  -Name 'State' `
                  -Value 1 `
                  -Type 'DWord'#>

'    Devices -> Mouse & touchpad -> Scroll inactive windows when I hover over them (on)'
Set-RegistryValue -Path 'HKCU:Control Panel\Desktop\' `
                  -Name 'MouseWheelRouting' `
                  -Value 2 `
                  -Type 'DWord'

'    Devices -> Typing -> Autocorrect misspelled words (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\TabletTip\1.7\' `
                  -Name 'EnableAutocorrection' `
                  -Value 1 `
                  -Type 'DWord'

'    Devices -> Typing -> Highlight misspelled words (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\TabletTip\1.7\' `
                  -Name 'EnableSpellchecking' `
                  -Value 1 `
                  -Type 'DWord'

'    Devices -> Autoplay (off)'
Set-RegistryValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' `
                  -Name 'DisableAutoplay' `
                  -Value 1 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Devices -> USB -> Notify me if there are issue connecting to USB devices (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Shell\USB\' `
                  -Name 'NotifyOnUsbErrors' `
                  -Value 1 `
                  -Type 'DWord'
}

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
