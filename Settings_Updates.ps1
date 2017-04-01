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
   _  _ ___  ___  ____ ___ ____ ____ 
   |  | |__] |  \ |__|  |  |___ [__  
   |__| |    |__/ |  |  |  |___ ___] 
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


#region Settings: Updates
Write-Host "`r`n`r`nCHANGING UPDATE SETTINGS" -ForegroundColor "Green"

If ($myOS.Caption -notlike '*Home') {    # This does not work on Home editions
'    Update & Security -> Windows Update -> Advanced options -> Choose how updates are installed: "Notify for download and notify for install"'
'        └-> Local Computer Policy -> Computer Configuration -> Administrative Templates -> Windows Components -> Windows Update -> Configure Automatic Updates'
    $AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\"

    Set-RegistryValue -Path $AutoUpdatePath `
                      -Name 'NoAutoUpdate' `
                      -Value 0 `
                      -Type 'DWord'
                      # OPTIONS:
                      # 0 - Change setting in Windows Update app (default)
                      # 1 - Never check for updates (not recommended)
    Set-RegistryValue -Path $AutoUpdatePath `
                      -Name 'AUOptions' `
                      -Value 2 `
                      -Type 'DWord'
                         # OPTIONS:
                         # 2 - Notify for download and notify for install
                         # 3 - Auto download and notify for install (default)
                         # 4 - Auto download and schedule the install
                         # 5 - Allow local admin to choose setting - does not work for stand-alone computers

    Set-RegistryValue -Path $AutoUpdatePath `
                      -Name 'ScheduledInstallDay' `
                      -Value 0 `
                      -Type 'DWord'
    Set-RegistryValue -Path $AutoUpdatePath `
                      -Name 'ScheduledInstallTime' `
                      -Value 3 `
                      -Type 'DWord'

    Set-RegistryValue -Path $AutoUpdatePath `
                      -Name 'NoAutoRebootWithLoggedOnUsers' `
                      -Value 1 `
                      -Type 'DWord'
} else {
    '    Update & Security -> Windows Update -> Advanced options -> Choose how updates are installed: "Notify to schedule restart"'
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\' `
                      -Name 'UxOption' `
                      -Value 1 `
                      -Type 'DWord'
}

'    Update & Security -> Windows Update -> Advanced options -> Give me updates for other Microsoft products when I update Windows: Yes'
Write-Host '        └-> NOTE: This setting might reset to the default (no). If so, change it manually.' -ForegroundColor "Yellow"
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\Pending\7971f918-a847-4430-9279-4a52d1efe18d\' `
                  -Name 'RegisterWithAU' `
                  -Value 1 `
                  -Type 'DWord'

'    Update & Security -> Windows Update -> Advanced options -> Defer upgrades: Yes'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\' `
                  -Name 'DeferUpgrade' `
                  -Value 1 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 14393) {    # Apply only for version 1607 (Redstone 1) or newer
'    Update & Security -> Windows Update -> Advanced options -> Use my sign-in info to automatically finish setting up my device after an update: No'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\' `
                  -Name 'ARSOUserConsent' `
                  -Value 0 `
                  -Type 'DWord'
}

'    Update & Security -> Windows Update -> Advanced options -> Choose how updates are delivered -> Updates from more than one place (off)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\' `
                  -Name 'DODownloadMode' `
                  -Value 0 `
                  -Type 'DWord'
                  # Value = 1  ->  On: Enable the following setting

<#'    Update & Security -> Windows Update -> Advanced options -> Choose how updates are delivered -> Updates from more than one place -> Get updates from and send updates to ...'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\' `
                  -Name 'DODownloadMode' `
                  -Value 1 `    # 1 = "PCs on my local network" / 3 = "PCs on my local network, and PCs on the Internet"
                  -Type 'DWord'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\' `
                  -Name 'SystemSettingsDownloadMode' `
                  -Value 3 `    # 3 = "PCs on my local network" / 1 = "PCs on my local network, and PCs on the Internet"
                  -Type 'DWord'#>


<#    ERROR: "Requested registry access is not allowed."

'    Update & Security -> Windows Defender -> Real-time protection (on)'
Try {
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows Defender\Real-Time Protection\' `
                      -Name 'DisableRealtimeMonitoring' `
                      -Value 0 `
                      -Type 'DWord' `
                      -OnError 'Stop'
}
Catch [System.Security.SecurityException] {
    Write-Host "        └-> An error occurred:" $error[0].Exception.Message -ForegroundColor "Red"
}

'    Update & Security -> Windows Defender -> Cloud-based protection (off)'
Try {
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows Defender\Spynet\' `
                      -Name 'SpyNetReporting' `
                      -Value 0 `
                      -Type 'DWord' `
                      -OnError 'Stop'
}
Catch [System.Security.SecurityException] {
    Write-Host "        └-> An error occurred:" $error[0].Exception.Message -ForegroundColor "Red"
}

'    Update & Security -> Windows Defender -> Automatic sample submission (off)'
Try {
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows Defender\Spynet\' `
                      -Name 'SubmitSamplesConsent' `
                      -Value 0 `
                      -Type 'DWord' `
                      -OnError 'Stop'
}
Catch [System.Security.SecurityException] {
    Write-Host "        └-> An error occurred:" $error[0].Exception.Message -ForegroundColor "Red"
}

'    Update & Security -> Windows Defender -> Enhanced notifications (off)'
Try {
    Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows Defender\Reporting\' `
                      -Name 'DisableEnhancedNotifications' `
                      -Value 1 `
                      -Type 'DWord' `
                      -OnError 'Stop'
}
Catch [System.Security.SecurityException] {
    Write-Host "        └-> An error occurred:" $error[0].Exception.Message -ForegroundColor "Red"
}#>


'    Update & Security -> For developers -> Use developer features: "Developer mode"'
<# OPTIONS:
    AllowDevelopmentWithoutDevLicense = 0, AllowAllTrustedApps = 0  ->  Windows Store apps - Only install apps from the Windows Store
    AllowDevelopmentWithoutDevLicense = 0, AllowAllTrustedApps = 1  ->  Sideload apps - Unstall apps from other sources that you trust
    AllowDevelopmentWithoutDevLicense = 1, AllowAllTrustedApps = 1  ->  Development mode - Install any signed app and use advanced development features #>
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock\' `
                  -Name 'AllowDevelopmentWithoutDevLicense' `
                  -Value 1 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock\' `
                  -Name 'AllowAllTrustedApps' `
                  -Value 1 `
                  -Type 'DWord'

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
