<#
.SYNOPSIS
    This script creates the Windows Personalization registry key if it doesn't exist and sets the NoLockScreenSlideshow value to 1, effectively disabling the lock screen slideshow feature as required by the STIG.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-06
    Last Modified   : 2025-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000010

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000010.ps1 
#>

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You need to run this script as an Administrator."
    Exit 1
}

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$valueName = "NoLockScreenSlideshow"
$valueData = 1
$valueType = "DWORD"

try {
    # Create the registry path if it doesn't exist
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Registry path created: $registryPath"
    }

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Output "Successfully configured $valueName = $valueData"
    
    # Verify the setting was applied correctly
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    if ($verifyValue.$valueName -eq $valueData) {
        Write-Output "Verification successful: $valueName is set to $valueData"
    } else {
        Write-Warning "Verification failed: $valueName is not set to $valueData"
    }
} catch {
    Write-Error "An error occurred: $_"
    Exit 1
}
