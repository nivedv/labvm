# Set file and folder path for SSMS installer .exe
$folderpath="c:\windows\temp"
$filepath="$folderpath\SSMS-Setup-ENU.exe"

#Install Chrome Browser
$chromepath ="$folderpath\chrome_installer.exe"
If (Test-Path  $chromepath)
{
    Write-Host "Downloading Chrome.."
    $LocalTempDir = $env:TEMP; 
    $ChromeInstaller = "ChromeInstaller.exe"; 
    (new-object System.Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir$ChromeInstaller"); & "$LocalTempDir$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
}

 
#If SSMS not present, download
if (!(Test-Path $filepath)){
write-host "Downloading SQL Server SSMS..."
$URL = "https://aka.ms/ssmsfullsetup"
$clnt = New-Object System.Net.WebClient
$clnt.DownloadFile($url,$filepath)
Write-Host "SSMS installer download complete" -ForegroundColor Green
 
}
else {
 
write-host "Located the SQL SSMS Installer binaries, moving on to install..."
}
 
# start the SSMS installer
write-host "Beginning SSMS install..." -nonewline
$Parms = " /Install /Quiet /Norestart /Logs log.txt"
$Prms = $Parms.Split(" ")
& "$filepath" $Prms | Out-Null
Write-Host "SSMS installation complete" -ForegroundColor Green