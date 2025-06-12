<#
    .SYNOPSIS 
    Windows Software packaging wrapper

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-RunAsDomainUser.ps1 -install
    Uninstall: C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-RunAsDomainUser.ps1 -uninstall
    
    .ENVIRONMENT
    PowerShell 5.0
    
    .AUTHOR
    Niklas Rast
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true, ParameterSetName = 'install')]
	[switch]$install,
	[Parameter(Mandatory = $true, ParameterSetName = 'uninstall')]
	[switch]$uninstall
)

$ErrorActionPreference = "SilentlyContinue"
$logFile = ('{0}\{1}.log' -f "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

if ($install)
{
    Start-Transcript -path $logFile -Append
        try
        {         
            #Add File or Folder
            New-Item -Path "C:\ProgramData\RunAsDomainUser" -ItemType Directory -Force
            Copy-Item -Path "$PSScriptRoot\ShellRunas.exe" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\domain.txt" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\app.txt" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\runasdomainuser.ps1" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force

            Copy-Item -Path "$PSScriptRoot\runasdomainuser-exe\bin\Release\net9.0\runasdomainuser-exe.exe" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\runasdomainuser-exe\bin\Release\net9.0\runasdomainuser-exe.dll" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\runasdomainuser-exe\bin\Release\net9.0\runasdomainuser-exe.pdb" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Copy-Item -Path "$PSScriptRoot\runasdomainuser-exe\bin\Release\net9.0\runasdomainuser-exe.runtimeconfig.json" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force

            Copy-Item -Path "$PSScriptRoot\icon.ico" -Destination "C:\ProgramData\RunAsDomainUser" -Recurse -Force

            # Create a shortcut in the All Users Start Menu
            $shortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Run As Domain User.lnk"
            $targetPath = "C:\ProgramData\RunAsDomainUser\runasdomainuser-exe.exe"
            $iconLocation = "C:\ProgramData\RunAsDomainUser\icon.ico"
            $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $targetPath
            $shortcut.IconLocation = $iconLocation
            $shortcut.Save()
 
            exit 0        
        } 
        catch
        {
            $PSCmdlet.WriteError($_)
            exit 1
        }
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile -Append
        try
        {
            #Remove File or Folder
            Remove-Item -Path "C:\ProgramData\RunAsDomainUser" -Recurse -Force
            Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Run As Domain User.lnk" -Force

            exit 0    
        }
        catch
        {
            $PSCmdlet.WriteError($_)
            exit 1
        }
    Stop-Transcript
}
