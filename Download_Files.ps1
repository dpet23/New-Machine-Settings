$urls = @(
    # Great Vibes font
    "https://github.com/google/fonts/blob/master/ofl/greatvibes/GreatVibes-Regular.ttf"

    # Sysinternals suite + Process Hacker
    "https://download.sysinternals.com/files/SysinternalsSuite.zip",
    "https://github.com/processhacker2/processhacker2/releases/download/v2.39/processhacker-2.39-bin.zip"
)

$OutPath = "$env:userprofile\Downloads\"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
ForEach ( $item in $urls) {
    $file = $OutPath +  ($item).split('/')[-1]
    Write-Host ""
    Write-Host "$item"
    Write-Host "    --> $file"
    Invoke-WebRequest -Uri $item -Outfile $file
}
Write-Host ""
