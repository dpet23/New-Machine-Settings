############################################################
# (c) Daniel Petrescu
############################################################
# The software is provided "as is", without warranty of any kind, express or implied, including but
# not limited to the warranty of fitness for a particular purpose. In no event shall the authors or
# copyright holders be liable for any claim, damages or other liability, whether in an action of
# contract or otherwise, arising from, out of, or in connection with the software or the use or
# other dealings in the software.
############################################################


#region Variables

### Set error action
$ErrorActionPreference = 'Continue'

<# VALUES:
     Continue (default): Displays the error message and continues executing.
     Stop:               Displays the error message and stops executing.
     Inquire:            Displays the error message and asks you whether you want to continue.
     Suspend:            Automatically suspends a workflow job to allow for further investigation. After investigation, the workflow can be resumed.
     SilentlyContinue:   The error message is not displayed and execution continues without interruption. #>



### Set logo
$logo = @"
_  _ ____ _ _ _    ____ ____ ___ ___ _ _  _ ____ ____  
|\ | |___ | | |    [__  |___  |   |  | |\ | | __ [__  .
| \| |___ |_|_|    ___] |___  |   |  | | \| |__] ___] .
"@



### Set description
$desc = @"
DESCRIPTION:
    This script changes the settings of Windows 10 by updating the registry values.
"@



### Set LEGEND
$txt1 = "COLOUR LEGEND:"
$txt2 = "    Grey:   information"
$txt3 = "    Green:  headers"
$txt4 = "    White:  text"
$txt5 = "    Red:    errors"
$txt6 = "    Yellow: warnings"



### Copy the output to a log file
$TheDate = Get-Date
$TheDateYear = $TheDate.Year
$TheDateMonth = $TheDate.Month
If($TheDateMonth -lt 10) {
    $TheDateMonth = "0$($TheDateMonth)"
}
$TheDateDay = $TheDate.Day
If($TheDateDay -lt 10) {
    $TheDateDay = "0$($TheDateDay)"
}
$TheDateHour = $TheDate.Hour
If($TheDateHour -lt 10) {
    $TheDateHour = "0$($TheDateHour)"
}
$TheDateMinute = $TheDate.Minute
If($TheDateMinute -lt 10) {
    $TheDateMinute = "0$($TheDateMinute)"
}
$TheDateSecond = $TheDate.Second
If($TheDateSecond -lt 10) {
    $TheDateSecond = "0$($TheDateSecond)"
}
$TheDateOutput = "$($TheDateYear)$($TheDateMonth)$($TheDateDay)$($TheDateHour)$($TheDateMinute)$($TheDateSecond)"

#endregion


############################################################


#region Functions


### A function to pause the execution of the script
Function Pause ($message)
{
    if (-Not $psISE)     # If running Powershell command line
    {
        Write-Host "$message" -ForegroundColor "Yellow"
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}


### A function to print the headers
Function Print-Headers ($function)
{
    Write-Host "------------------------" -ForegroundColor "Gray"
    Write-Host $logo
    Write-Host ""
    Write-Host $function
    Write-Host "`r`n------------------------" -ForegroundColor "Gray"
    Write-Host $desc -ForegroundColor "Gray"
    Write-Host "------------------------" -ForegroundColor "Gray"
    Write-Host $txt1 -ForegroundColor "Gray"
    Write-Host $txt2 -ForegroundColor "Gray"
    Write-Host $txt3 -ForegroundColor "Green"
    Write-Host $txt4 -ForegroundColor "White"
    Write-Host $txt5 -ForegroundColor "Red"
    Write-Host $txt6 -ForegroundColor "Yellow"
    Write-Host "------------------------`r`n" -ForegroundColor "Gray"
}


### A function to test whether a registry path and value exist
Function Test-RegistryValue {
    Param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Path,      # Registry path

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Name       # Value name
    )

    If (Test-Path $Path) {
        Return ((Get-ChildItem $Path | Select-String -Pattern $Name) -ne $null)
    }
    Else {
        Return $false
    }
}


### A function to set or create a registry value
Function Set-RegistryValue {
    Param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Path,      # Registry path

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Name,      # Value name

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Value,     # Value to be added

        [parameter(Mandatory=$false)]
        $Type,      # Type of value

        [parameter(Mandatory=$false)]
        $OnError    # ErrorActionPreference
    )

    $useErrorAction = $ErrorActionPreference    # No change
    If ($OnError -ne $null) {
        $useErrorAction = $OnError
    }

    $useType = 'String'    # Default value is String (REG_SZ)
    If ($Type -ne $null) {
        $useType = $Type
    }

    If (Test-Path $Path) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $useType -ErrorAction $useErrorAction
    } Else {
        New-Item -Path $Path -Force | Out-Null
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $useType -ErrorAction $useErrorAction -Force | Out-Null
    }
}


### A function to reset the execution policy to the original value
Function Reset-Execution-Policy {
    if ($resetExecutionPolicy -eq 1)
    {
        Write-Host "`r`nResetting Execution Policy to: $currentExecutionPolicy" -ForegroundColor "Gray"
        Set-ExecutionPolicy -ExecutionPolicy $currentExecutionPolicy
    }

    Write-Host "`r`n===== DONE =====" -ForegroundColor "Black" -BackgroundColor "yellow"
    'Please reboot the computer to finalise the changes.'

    Pause "`r`nPress any key to quit ..."

    ''
}


#endregion


############################################################


#region Validation


### Check OS version
$myOS = (Get-CimInstance Win32_OperatingSystem)
$myOSstring = "Your OS is " + $myOS.Caption + ", build " + $myOS.BuildNumber + "."
If (($myOS.Caption -notlike '*Windows 10*') -and ($myOS.Version -notlike '10.*'))
{
    Write-Warning $("Windows 10 or higher is required. " + $myOSstring)

    Echo "No changes made."
    Pause "`r`nPress any key to quit ..."
    Break
}


### Check for Admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Print-Headers

    Echo "This script needs to be run as Admin."
    Echo "No changes made."

    Pause "`r`nPress any key to quit ..."
    Break
}

#endregion
