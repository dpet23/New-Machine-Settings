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
   ____ _ _    ____    ____ _  _ ___  _    ____ ____ ____ ____ 
   |___ | |    |___    |___  \/  |__] |    |  | |__/ |___ |__/ 
   |    | |___ |___    |___ _/\_ |    |___ |__| |  \ |___ |  \ 
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


#region Settings: File Explorer

Write-Host "`r`n`r`nCHANGING FILE EXPLORER OPTIONS" -ForegroundColor "Green"
Write-Host '    └-> NOTE: You will need to restart Windows Explorer (or the whole computer) to see the changes.' -ForegroundColor "Yellow"
Write-Host '    └-> NOTE: This script will place 2 "desktop.ini" files on the desktop (unknown reason). They can be deleted.' -ForegroundColor "Yellow"

'    Enable CTRL+ALT+DEL at logon'
Set-RegistryValue -Path 'HKLM:Software\Microsoft\Windows NT\CurrentVersion\Winlogon\' `
                  -Name 'DisableCAD' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: open to "This PC"'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'LaunchTo' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: use check boxes to select items (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'AutoCheckSelect' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: show hidden files, folders and drives (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'Hidden' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: hide extensions for known file types (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'HideFileExt' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: show status bar (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowStatusBar' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: use sharing wizard (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'SharingWizardOn' `
                  -Value 1 `
                  -Type 'DWord'


'    File Explorer: always show icons, never thumbnails (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'IconsOnly' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: always show menus (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'AlwaysShowMenus' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: display file icon on thumbnails (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowTypeOverlay' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: show pop-up description of folder and desktop items (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowInfoTip' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: display file size information in folder tips (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'FolderContentsInfoTip' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: display the full path in the title bar (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\' `
                  -Name 'FullPath' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: hide empty drives (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'HideDrivesWithNoMedia' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: hide folder merge conflicts (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'HideMergeConflicts' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: hide protected OS files (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowSuperHidden' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: launch folder windows in a separate process (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'SeparateProcess' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: restore previous folder windows at logon (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'PersistBrowsers' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: show drive letters (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\' `
                  -Name 'ShowDriveLettersFirst' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: show encrypted/compressed NTFS files in colour (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowEncryptCompressedColor' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: show preview handlers in preview pane (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowPreviewHandlers' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: show sync provider notifications (on)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'ShowSyncProviderNotifications' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: when typing into list view - select the typed item in the view'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'TypeAhead' `
                  -Value 1 `
                  -Type 'DWord'

'    File Explorer: Navigation Pane -> expand to open folder (off)'
Set-RegistryValue -Path 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'NavPaneExpandToCurrentFolder' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: Navigation Pane -> show all folders (off)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\' `
                  -Name 'NavPaneShowAllFolders' `
                  -Value 0 `
                  -Type 'DWord'

'    File Explorer: Navigation Pane -> show libraries (on)'
Set-RegistryValue -Path 'HKCU:SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\' `
                  -Name 'System.IsPinnedToNameSpaceTree' `
                  -Value 1 `
                  -Type 'DWord'

#endregion


############################################################


Write-Host ""
Reset-Execution-Policy
Stop-Transcript
Pop-Location
