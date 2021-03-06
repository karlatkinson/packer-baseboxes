$ProgressPreference="SilentlyContinue"
$ErrorActionPreference = "Stop"

for ([byte]$c = [char]'A'; $c -le [char]'Z'; $c++)  
{  
	$variablePath = [char]$c + ':\variables.ps1'

	if (test-path $variablePath) {
		. $variablePath
		break
	}
}

$username = "vagrant"
if ($UnAttendWindowsUsername) {
	$username = $UnAttendWindowsUsername
}

$version = '3.1.1-1'
$rsync_file_name = "rsync-$version.tar"
$rsync_tar_file_name = "$rsync_file_name.xz"

if ($httpIp){
	if (!$httpPort){
    	$httpPort = "80"
    }
    $download_url = "http://$($httpIp):$($httpPort)/$rsync_tar_file_name"
} else {
    $download_url = "http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/rsync/$rsync_tar_file_name"
}

(New-Object System.Net.WebClient).DownloadFile($download_url, "c:\windows\temp\$rsync_tar_file_name")
&"c:\7-zip\7z.exe" x "c:\windows\temp\$rsync_tar_file_name" -oc:\windows\temp -aoa | Out-Host
&"c:\7-zip\7z.exe" x "c:\windows\temp\$rsync_file_name" -oc:\windows\temp\rsync -aoa | Out-Host

Copy-Item c:\windows\temp\rsync\usr\bin\rsync.exe "C:\Program Files\OpenSSH\bin\rsync.exe" -Force

Write-Host "make symlink for c:/$username share"
&cmd /c mklink /D "C:\Program Files\OpenSSH\$username" "C:\$username"