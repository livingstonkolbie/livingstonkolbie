<#
.SYNOPSIS
    The PowerShell script sets the LocalAccountTokenFilterPolicy registry value to 0, which ensures that local administrator accounts have their privileged tokens filtered to prevent elevated privileges from being used over the network on domain systems.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-27
    Last Modified   : 2025-03-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000037

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:> .\STIG-ID-WN10-CC-000037.ps1
#>

# Check if running with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as Administrator!"
    exit
}

# Path to the registry key
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Name of the registry value
$registryName = "LocalAccountTokenFilterPolicy"

# Value to set (dword:00000000 = 0)
$registryValue = 0

# Check if registry path exists, if not create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set registry value
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the value was set
$verificationValue = (Get-ItemProperty -Path $registryPath -Name $registryName).$registryName
Write-Host "Registry value has been set. Current value: $verificationValue"
