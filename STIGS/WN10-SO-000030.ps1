<#
.SYNOPSIS
    This script sets the SCENoApplyLegacyAuditPolicy registry value to 1 in the Windows LSA configuration, which prevents legacy audit policies from overriding advanced audit policy settings.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000030

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-SO-000030.ps1 
#>

# PowerShell script to set SCENoApplyLegacyAuditPolicy registry value
# This script enforces the STIG requirement to prevent legacy audit policies from overriding advanced audit policies

# Ensure we're running with administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an Administrator!"
    Exit 1
}

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$name = "SCENoApplyLegacyAuditPolicy"
$value = 1

# Check if the registry path exists, if not create it
If (-NOT (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

# Verify the setting was applied correctly
$currentValue = (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue).$name
If ($currentValue -eq $value) {
    Write-Output "SUCCESS: Registry value $name set to $value in $registryPath"
} Else {
    Write-Output "ERROR: Failed to set registry value $name to $value in $registryPath. Current value is $currentValue"
}
