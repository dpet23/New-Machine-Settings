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
   ____ ____ ____ _ ____ _  _    ____ _  _ ___     _    ____ _  _ ____ _  _ ____ ____ ____ 
   |__/ |___ | __ | |  | |\ |    |__| |\ | |  \    |    |__| |\ | | __ |  | |__| | __ |___ 
   |  \ |___ |__] | |__| | \|    |  | | \| |__/    |___ |  | | \| |__] |__| |  | |__] |___ 
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


#region Settings: Region & Language
Write-Host "`r`n`r`nCHANGING REGION & LANGUAGE OPTIONS" -ForegroundColor "Green"

'    Time & Language -> Date & time -> Set time automatically (on)'
Set-RegistryValue -Path 'HKLM:SYSTEM\ControlSet001\Services\W32Time\' `
                  -Name 'Start' `
                  -Value 3 `
                  -Type 'DWord'
Set-RegistryValue -Path 'HKLM:SYSTEM\ControlSet001\Services\W32Time\Parameters' `
                -Name 'Type' `
                -Value NTP

'    Time & Language -> Date & time -> Set time zone automatically (off)'
Set-RegistryValue -Path 'HKLM:SYSTEM\ControlSet001\Services\tzautoupdate\' `
                  -Name 'Start' `
                  -Value 4 `
                  -Type 'DWord'

'    Time & Language -> Date & time -> Adjust for daylight saving time automatically (on)'
Set-RegistryValue -Path 'HKLM:SYSTEM\ControlSet001\Control\TimeZoneInformation\' `
                -Name 'DynamicDaylightTimeDisabled' `
                -Value 0 `
                -Type 'DWord'

# Run this only if "Time & Language -> Region & language -> Country" is not "Australia"
If($(Get-ItemPropertyValue -Path 'HKCU:Control Panel\International\Geo\' -Name 'Nation') -ne 12)
{
    '    Time & Language -> Region & language -> Country: "Australia"'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\Geo\' `
                    -Name 'Nation' `
                    -Value 12

    <#'    Time & Language -> Region & language -> Languages: en-AU'
    --> Not sure which registry settings need to be changed... #>

        '    Time & Language -> Date & time -> Formats -> First day of week: "Monday"'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\' `
                      -Name 'iFirstDayOfWeek' `
                      -Value 0

    '    Time & Language -> Date & time -> Formats -> Short time: "h:mm tt"'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\' `
                      -Name 'sShortTime' `
                      -Value "h:mm tt"

    '    Time & Language -> Date & time -> Formats -> Long time: "h:mm:ss tt"'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\' `
                      -Name 'sLongTime' `
                      -Value "h:mm:ss tt"

    '    Time & Language -> Date & time -> Formats -> Short date: "d/MM/yyyy""'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\' `
                      -Name 'sShortDate' `
                      -Value "d/MM/yyyy"

    '    Time & Language -> Date & time -> Formats -> Long date: "dddd, d MMMM, yyyy"'
    Set-RegistryValue -Path 'HKCU:Control Panel\International\' `
                      -Name 'sLongDate' `
                      -Value "dddd, d MMMM yyyy"
}


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
