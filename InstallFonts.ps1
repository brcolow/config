$FONTS = 0x14;

$FromPath = "c:\fonts";

$ObjShell = New-Object -ComObject Shell.Application;
$ObjFolder = $ObjShell.Namespace($FONTS);

$CopyOptions = 4 + 16;
$CopyFlag = [String]::Format("{0:x}", $CopyOptions);

foreach($File in $(Get-ChildItem -Path $FromPath)){
    If ((Test-Path "c:\windows\fonts\$($File.name)") -eq $False)
    { }
    Else
    {
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $ObjFolder.CopyHere($File.fullname, $CopyOptions);

        New-ItemProperty -Name $File.fullname -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $File 
    }
}
