@@:: This prolog allows a PowerShell script to be embedded in a .CMD file.
@@:: Any non-PowerShell content must be preceeded by "@@"
@@setlocal
@@set POWERSHELL_BAT_ARGS=%*
@@if defined POWERSHELL_BAT_ARGS set POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%
@@PowerShell -noprofile -Command Invoke-Expression $('$args=@(^&{$args} %POWERSHELL_BAT_ARGS%);'+[String]::Join(';',$((Get-Content '%~f0') -notmatch '^^@@'))) & pause & goto :EOF
Set-ExecutionPolicy Bypass -Scope Process -Force
If ( -Not (Test-Path $(get-command choco).PATH) ) { 
"chocolatey windows package manager not found, Installing ..."
 iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
If ( -Not (Test-Path $(get-command 7z).PATH) ) { 
"7z command not found, Installing ..."
 choco install 7zip.install -y
}
If ( -Not (Test-Path $(get-command 7z).PATH) ) { 
"pp markdown preprocessor not found, downloading archive from  https://cdsoft.fr/pp/pp-win.7z ..."
 Invoke-WebRequest -Uri "https://cdsoft.fr/pp/pp-win.7z" -OutFile "c:\temp\pp-win.7z"
 &7z x "c:\temp\pp-win.7z" `-o`"$($env:ChocolateyInstall)\bin`"
 "removing intermediate archive"
 If ( (Test-Path "c:\temp\pp-win.7z") ){
 	remove-item "c:\temp\pp-win.7z"
 }
 
}
If ( -Not (Test-Path $(get-command pandoc).PATH) ) { 
"pandoc command not found, Installing ..."
 choco install pandoc -y
}
