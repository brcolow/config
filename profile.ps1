. 'C:\Users\brcolow\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline
}
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function Complete

function crypt {
    set-location C:\code\cryptodash
}

function dep {
   mvn versions:display-dependency-updates
}

function apt {
    bash apt-cyg $args
}

function cent {
	set-location C:\code\centurion
}

function cygup {
	set-location C:\cygwin64
	$webclient = New-Object System.Net.WebClient
	$url = "https://www.cygwin.com/setup-x86_64.exe"
	$file = "C:\cygwin64\setup-x86_64.exe"
	$webclient.DownloadFile($url,$file)
	Start-Process -FilePath "C:\cygwin64\setup-x86_64.exe" -ArgumentList "--no-desktop --no-shortcuts --no-startmenu --quiet-mode"
	clear
}