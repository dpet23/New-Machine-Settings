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
    ___  ____ ____ _ _ _ ____ ____ ____ ____ 
.   |__] |__/ |  | | | | [__  |___ |__/ [__  
.   |__] |  \ |__| |_|_| ___] |___ |  \ ___] 
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


#region Settings: Edge
Write-Host "`r`n`r`nCHANGING MICROSOFT EDGE SETTINGS" -ForegroundColor "Green"

'    Edge -> Settings -> Choose a theme: "Light"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'Theme' `
                  -Value 0 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Light
                        1 = Dark
                  #>

'    Edge -> Settings -> Open new tabs with: "A blank page"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\' `
                  -Name 'NewTabPageDisplayOption' `
                  -Value 2 `
                  -Type 'DWord'

'    Edge -> Settings -> Favorites -> Show the favorites bar (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\LinksBar\' `
                  -Name 'Enabled' `
                  -Value 1 `
                  -Type 'DWord'

If ($myOS.BuildNumber -ge 10586) {    # Apply only for version 1511 (Threshold 2) or newer
'    Edge -> Settings -> Favorites -> Show only icons on the favorites bar (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'FaviconOnlyOnFavBar' `
                  -Value 0 `
                  -Type 'DWord'
}

'    Edge -> Settings -> Reading -> Reading view style: "Default"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ReadingMode\' `
                  -Name 'Style' `
                  -Value 0 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Default
                        1 = Light
                        2 = Medium
                        3 = Dark
                  #>

'    Edge -> Settings -> Reading -> Reading view font size: "Medium"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ReadingMode\' `
                  -Name 'FontSize' `
                  -Value 1 `
                  -Type 'DWord'
                  <# OPTIONS:
                        0 = Small
                        1 = Medium
                        2 = Large
                        3 = Extra Large
                  #>

'    Edge -> Settings -> Advanced settings -> Show the home button (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'HomeButtonEnabled' `
                  -Value 1 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Block pop-ups (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\New Windows\' `
                  -Name 'PopupMgr' `
                  -Value 'yes'

'    Edge -> Settings -> Advanced settings -> Use Adobe Flash Player (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Addons\' `
                  -Name 'FlashPlayerEnabled' `
                  -Value 1 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Offer to save passwords (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'FormSuggest Passwords' `
                  -Value 'no'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Save form entries (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'Use FormSuggest' `
                  -Value 'no'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Send "Do NotTrack" requests (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'DoNotTrack' `
                  -Value 1 `
                  -Type 'DWord'

Write-Host "    TO DO ==> Edge -> Settings -> Advanced settings -> Privacy and services -> Have Cortana assist me in Microsoft Edge (off)" -ForegroundColor "Gray"
Write-Host "    TO DO ==> Edge -> Settings -> Advanced settings -> Privacy and services -> Search in the address bar with: `"Google`"" -ForegroundColor "Gray"

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Show search and site suggestions as I type (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes\' `
                  -Name 'ShowSearchSuggestionsGlobal' `
                  -Value 1 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Cookies: "Block only third-party cookies"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main\' `
                  -Name 'Cookies' `
                  -Value 1 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Let sites save protected media licenses on my device (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy\' `
                  -Name 'EnableEncryptedMediaExtensions' `
                  -Value 0 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Use page prediction (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead\' `
                  -Name 'FPEnabled' `
                  -Value 0 `
                  -Type 'DWord'

'    Edge -> Settings -> Advanced settings -> Privacy and services -> Use SmartScreen Filter (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter\' `
                  -Name 'EnabledV9' `
                  -Value 1 `
                  -Type 'DWord'
                  
                  
'    Edge -> about:flags (on)'
Set-RegistryValue -Path 'HKLM:SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main\' `
                  -Name 'PreventAccessToAboutFlagsInMicrosoftEdge' `
                  -Value 0 `
                  -Type 'DWord'
                  
'    Edge -> about:flags -> Show "View source" and "Inspect element" in the context menu (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\F12\' `
                  -Name 'ShowPageContextMenuEntryPoints' `
                  -Value 1 `
                  -Type 'DWord'

#endregion


####################


#region Settings: IE
Write-Host "`r`n`r`nCHANGING INTERNET EXPLORER SETTINGS" -ForegroundColor "Green"

'    Block Advertising in IE'
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety'))
{
    $null = New-Item -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety' -ItemType Directory
}
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE'))
{
    $null = New-Item -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -ItemType Directory
}
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists\'))
{
    $null = New-Item -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists\' -ItemType Directory
}
$null = New-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -Name 'FilteringMode' -PropertyType DWORD -Value 0 -Force
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists\{7C998372-3B89-46E6-9546-1945C711CD0C}'))
{
    $null = New-Item -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists\{7C998372-3B89-46E6-9546-1945C711CD0C}' -ItemType Directory
}
$null = New-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -Name 'Enabled' -PropertyType DWORD -Value 1 -Force
$null = New-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -Name 'Name' -PropertyType String -Value 'EasyList' -Force
$null = New-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -Name 'Path' -PropertyType String -Value '%AppDataDir%\Local\Microsoft\Internet Explorer\Tracking Protection\{7C998372-3B89-46E6-9546-1945C711CD0C}.tpl' -Force
$null = New-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE' -Name 'Url' -PropertyType String -Value 'http://easylist-msie.adblockplus.org/easylist.tpl' -Force

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
