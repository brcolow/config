$config = resolve-path ~/config
$env:Path += ";$config\ps"

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

function plug {
	mvn versions:display-plugin-updates
}

# For this to work, install cyg-apt to cygwin's bin directory:
# lynx -source rawgit.com/svnpenn/sage/master/sage > sage
# cp apt-cyg bin/apt-cyg
# chmod +x apt-cyg
# (or install sage /bin)
# Then one can use it from powershell thusly: "apt install tmux"
function apt {
    bash sage $args
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

function centdeploy {
	bash C:\code\centurion\scripts\deploy.sh
}

function Write-Color-LS {
        param ([string]$color = "white", $file)
        Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $file.length, $file.name) -foregroundcolor $color 
    }

New-CommandWrapper Out-Default -Process {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)

    if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
    {
        if(-not ($notfirst)) 
        {
           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $(pwd)`n" -foregroundcolor "Magenta"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $notfirst=$true
        }

        if ($_ -is [System.IO.DirectoryInfo]) 
        {
            Write-Color-LS "Magenta" $_                
        }
        elseif ($compressed.IsMatch($_.Name))
        {
            Write-Color-LS "DarkGreen" $_
        }
        elseif ($executable.IsMatch($_.Name))
        {
            Write-Color-LS "Red" $_
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            Write-Color-LS "Yellow" $_
        }
        else
        {
            Write-Color-LS "White" $_
        }

    $_ = $null
    }
} -end {
    write-host ""
}
Remove-Item alias:ls
Set-Alias ls LS-Padded

function LS-Padded {
    param ($dir)
    Get-Childitem $dir
    Write-Host
    getDirSize $dir
}

function getDirSize {
    param ($dir)
    $bytes = 0

    Get-Childitem $dir | foreach-object {

        if ($_ -is [System.IO.FileInfo])
        {
            $bytes += $_.Length
        }
    }

    if ($bytes -ge 1KB -and $bytes -lt 1MB)
    {
        Write-Host ("Total Size: " + [Math]::Round(($bytes / 1KB), 2) + " KB")   
    }

    elseif ($bytes -ge 1MB -and $bytes -lt 1GB)
    {
        Write-Host ("Total Size: " + [Math]::Round(($bytes / 1MB), 2) + " MB")
    }

    elseif ($bytes -ge 1GB)
    {
        Write-Host ("Total Size: " + [Math]::Round(($bytes / 1GB), 2) + " GB")
    }    

    else
    {
        Write-Host ("Total Size: " + $bytes + " bytes")
    }
}