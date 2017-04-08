############################################################
# (c) Daniel Petrescu
############################################################
# The software is provided "as is", without warranty of any kind, express or implied, including but
# not limited to the warranty of fitness for a particular purpose. In no event shall the authors or
# copyright holders be liable for any claim, damages or other liability, whether in an action of
# contract or otherwise, arising from, out of, or in connection with the software or the use or
# other dealings in the software.
############################################################


#region Script Init

### Get variables
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptpath
Push-Location $scriptDir
. '.\Variables.ps1'

### Copy the output to a log file
$ScriptName = ([io.fileinfo]$MyInvocation.MyCommand.Name).basename
$OutputFileLocation = "$($PSScriptRoot)\logs\$($ScriptName)_output_$($TheDateOutput).txt"
''
Start-Transcript -path $OutputFileLocation -append
''

### Print headers
$scriptLogo = @"
   ___  ____ _ _  _ ____ ____ _   _ 
   |__] |__/ | |  | |__| |     \_/  
   |    |  \ |  \/  |  | |___   |   
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


#region Settings: Privacy
Write-Host "`r`n`r`nCHANGING PRIVACY SETTINGS" -ForegroundColor "Green"

'    Privacy -> General -> Let apps use my advertising id for experiences across apps (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo\' `
                  -Name 'Enabled' `
                  -Value 0 `
                  -Type 'DWord'

If ($myOS.BuildNumber -le 14393) {    # Apply only for version 1607 (Redstone 1) or older
'    Privacy -> General -> SmartScreen Filter to check web content that Windows Store apps use (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\' `
                  -Name 'EnableWebContentEvaluation' `
                  -Value 1 `
                  -Type 'DWord'
}

'    Privacy -> General -> Send Microsoft info about how I write to help us improve typing and writing in the future (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Input\TIPC\' `
                  -Name 'Enabled' `
                  -Value 0

'    Privacy -> General -> Let websites provide locally relevant content by accessing my language list (off)'
if ((Get-ItemProperty -Path 'HKCU:SOFTWARE\Microsoft\Internet Explorer\International\' -Name 'AcceptLanguage' -ErrorAction SilentlyContinue) -ne $null) {
    Remove-ItemProperty -Path 'HKCU:SOFTWARE\Microsoft\Internet Explorer\International\' -Name 'AcceptLanguage' -Force
}
Set-RegistryValue -Path 'HKCU:Control Panel\International\User Profile\' `
                  -Name 'HttpAcceptLanguageOptOut' `
                  -Value 1

If ($myOS.BuildNumber -eq 14393) {    # Apply only for version 1607 (Redstone 1)
'    Privacy -> General -> Let apps on my other devices open apps and continue experiences on this device (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass\' `
                  -Name 'UserAuthPolicy' `
                  -Value 0
}

If ($myOS.BuildNumber -eq 14393) {    # Apply only for version 1607 (Redstone 1)
'    Privacy -> General -> Let apps on my other devices use Bluetooth to open apps and continue experiences on this device (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass\' `
                  -Name 'BluetoothPolicy' `
                  -Value 0
}

If ($myOS.BuildNumber -ge 15063) {    # Apply only for version 1703 (Redstone 2) or newer
'    Privacy -> General -> Let Windows track app launches to improve Start and search results (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Start_TrackProgs' `
                  -Value 0
}

'    Privacy -> Location -> Location (for this account) (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}\' `
                  -Name 'Value' `
                  -Value 'Deny'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5\' `
                  -Name 'Value' `
                  -Value 'Deny'
Set-RegistryValue -Path 'HKCU:SSOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}\' `
                  -Name 'SensorPermissionState ' `
                  -Value 0 `
                  -Type 'DWord'
<#'    Privacy -> Location -> Location for this device (for all accounts) (off)   [automatically resets]'
Set-RegistryValue -Path 'HKLM:Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}\' `
                  -Name 'SensorPermissionState' `
                  -Value 0 `
                  -Type 'DWord'#>

'    Privacy -> Camera -> Let apps use my camera (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Microphone -> Let apps use my microphone (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}\' `
                  -Name 'Value' `
                  -Value 'Deny'

If ($myOS.BuildNumber -ge 14393) {    # Apply only for version 1607 (Redstone 1) or newer
'    Privacy -> Notifications -> Let apps access my notifications (off)'
Write-Host '        └-> NOTE: This setting might reset to the default (on). If so, change it manually.' -ForegroundColor "Yellow"
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}\' `
                  -Name 'Value' `
                  -Value 'Deny'
}

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Privacy -> Speech, inking & typing -> Disable Cortana'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search\' `
                  -Name 'CortanaEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

'    Privacy -> Speech, inking & typing -> Get to know my typing (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Personalization\Settings\' `
                  -Name 'AcceptedPrivacyPolicy' `
                  -Value 0 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language\' `
                -Name 'Enabled' `
                -Value 0 `
                -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\InputPersonalization\' `
                  -Name 'RestrictImplicitTextCollection' `
                  -Value 1 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\InputPersonalization\' `
                -Name 'RestrictImplicitInkCollection' `
                -Value 1 `
                -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore\' `
                  -Name 'HarvestContacts' `
                  -Value 0 `
                  -Type 'DWord'

'    Privacy -> Account info -> Let apps access my name, picture and other account info (off)'
Write-Host '        └-> NOTE: This setting might reset to the default (on). If so, change it manually.' -ForegroundColor "Yellow"
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Contacts -> Let apps access my contacts (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Calendar -> Let apps access my calendar (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}\' `
                  -Name 'Value' `
                  -Value 'Deny'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Privacy -> Call history -> Let apps access my call history (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}\' `
                  -Name 'Value' `
                  -Value 'Deny'
}

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Privacy -> Email -> Let apps access and send email (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}\' `
                  -Name 'Value' `
                  -Value 'Deny'
}

If ($myOS.BuildNumber -ge 15063) {    # Apply only for version 1703 (Redstone 2) or newer
'    Privacy -> Tasks (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}\' `
                  -Name 'Value' `
                  -Value 'Deny'
}

'    Privacy -> Messaging -> Let apps read or send text/SMS/MMS messages (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Radios -> Let apps control radios (off)'
Write-Host '        └-> NOTE: This setting might reset to the default (on). If so, change it manually.' -ForegroundColor "Yellow"
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Other devices -> Sync with devices (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled\' `
                  -Name 'Value' `
                  -Value 'Deny'

'    Privacy -> Feedback & diagnostics -> Windows should ask for my feedback: "Never"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Siuf\Rules\' `
                  -Name 'NumberOfSIUFInPeriod' `
                  -Value 0 `
                  -Type 'DWord'

'    Privacy -> Feedback & diagnostics -> Send your device data to Microsoft: "Security"'
If ($myOS.BuildNumber -lt 14393) {    # Apply only for version 1511 (Threshold 2) or older
    Write-Host '        └-> NOTE: "Update & Security -> Windows Update -> Advanced options -> Get Insider Builds" will be disabled. To enable, set this to "Enhanced" or "Full".' -ForegroundColor "Yellow"
} else {
    Write-Host '        └-> NOTE: "Update & Security -> Windows Insider Program -> Get started" will be disabled. To enable, set this to "Enhanced" or "Full".' -ForegroundColor "Yellow"
}
Write-Host '        └-> Local Computer Policy -> Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds.'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\' `
                  -Name 'AllowTelemetry' `
                  -Value 0 `
                  -Type 'DWord'
<#Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\DataCollection\' `
                  -Name 'AllowTelemetry' `
                  -Value 0 `
                  -Type 'DWord'#>
<#Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\GPO-List\0\' `
                  -Name 'Version' `
                  -Value 10001 `
                  -Type 'DWord'#>
<#Set-RegistryValue -Path 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection\' `
                  -Name 'AllowTelemetry' `
                  -Value 0 `
                  -Type 'DWord'#>
                    <# OPTIONS:
                            0 = "Security" - Malicious Software Removal Tool, Windows Defender [applies to Enterprise, Education, IoT and Server devices only]
                            1 = "Basic" - Security + OS version, functioning of Windows, device capabilities
                            2 = "Enhanced" - Basic + how you use Windows, which feature you use the most, the most frequently used apps by the users, diagnostic information
                            3 = "Full" - Enhanced + system files, memory snapshots, part of the document you were working on when the app crashed, etc.
                    #>

If ($myOS.BuildNumber -ge 15063) {    # Apply only for version 1703 (Redstone 2) or newer
'    Privacy -> Feedback & diagnostics -> Let Microsoft provide tips using diagnostic data (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy\' `
                  -Name 'TailoredExperiencesWithDiagnosticDataEnabled' `
                  -Value 0 `
                  -Type 'DWord'
}

If ($myOS.BuildNumber -ge 15063) {    # Apply only for version 1703 (Redstone 2) or newer
'    Privacy -> Background Apps -> Let apps run in the background (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\' `
                  -Name 'GlobalUserDisabled' `
                  -Value 1 `
                  -Type 'DWord'
}

If ($myOS.BuildNumber -ge 15063) {    # Apply only for version 1703 (Redstone 2) or newer
'    Privacy -> App Diagnostics -> Let apps access diagnostic information (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}\' `
                  -Name 'Value' `
                  -Value 'Deny'
}

If ($myOS.Caption -notlike '*Home') {    # This does not work on Home editions
'    Privacy -> Turn off Microsoft consumer experience'
'        └-> Local Computer Policy -> Computer Configuration -> Administrative Templates -> Windows Components -> Cloud Content'
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows\CloudContent\' `
                      -Name 'DisableWindowsConsumerFeatures' `
                      -Value 1 `
                      -Type 'DWord'
}

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
