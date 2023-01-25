# PowerShell script to add a set of paths
# Must run under  set-executionpolicy RemoteSigned or powershell will say not found
# In a powershell admin window, allow running unsigned P/S scripts:
#    set-executionpolicy Unrestricted
# Update $pathsArray for your needs
# Author: Ian Darwin based on some pieces found on a web search - no powershell expert am I.

$COURSE_NUM = 518Z
$JAVA_VER   = 17.0.4.8
$MAVEN_VER  = 3.8.7

$Today = (Get-Date).DateTime
Write-Host "SetPaths run on" $Today

$pathsArray = 
	"C:\Program Files\Eclipse Adoptium\jdk-${JAVA_VER}-hotspot\bin",
	"C:\Users\$env:USERNAME\apache-maven-$MAVEN_VER\bin",
	"C:\Users\$env:USERNAME\bin",
	"C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\tools\bin",
	"C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\emulator",
	"C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\platform-tools",
	"C:\Users\$env:USERNAME\flutter\bin",
	"C:\Users\$env:USERNAME\flutter\scripts",
	"C:\Program Files (x86)\GnuWin32\bin",
	"C:\Program Files\Git\usr\bin"

function Add-To-Path{
param(
	[string]$Dir
)

	if (!(Test-Path $Dir)) {
		Write-warning "Supplied directory $Dir was not found!"
	}
	$PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine")
	if ($PATH -notlike "*$Dir*" ) {
		[Environment]::SetEnvironmentVariable("PATH", "$PATH;$Dir", "Machine")
		Write-Host "Added $Dir"
	} else {
		Write-warning "$Dir already in path"
	}
}


foreach ($path in $pathsArray)
{
	Add-To-Path $path
}
