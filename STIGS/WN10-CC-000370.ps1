<#
.SYNOPSIS
    This script disables the ability to use Windows Hello PIN for domain account authentication by creating the required registry path if needed, setting the AllowDomainPINLogon value to 0, and verifying the change was successfully applied.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000370.ps1 
#>

# PowerShell script to implement Windows 10 STIG setting
# Sets AllowDomainPINLogon to 0 in HKLM:\Software\Policies\Microsoft\Windows\System

# Create the registry path if it doesn't exist
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Output "Created registry path: $registryPath"
}

# Set the registry value
$valueName = "AllowDomainPINLogon"
$valueData = 0
$valueType = "DWORD"

Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
Write-Output "Successfully set $valueName to $valueData in $registryPath"

# Verify the setting was applied correctly
$verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Output "Verification successful: $valueName is set to $valueData"
} else {
    Write-Error "Verification failed: $valueName is not set to expected value"
}
