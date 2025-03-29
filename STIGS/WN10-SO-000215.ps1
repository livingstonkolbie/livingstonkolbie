<#
.SYNOPSIS
    The script sets the NTLMMinClientSec registry value to 0x20080000 in the Windows 10 LSA configuration, which enforces NTLMv2 session security and requires 128-bit encryption to enhance authentication security.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000215

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-SO-000215.ps1 
#>


# Script to set NTLMMinClientSec registry value
# STIG ID: Windows 10 Security Technical Implementation Guide

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\"
$valueName = "NTLMMinClientSec"
$valueData = 0x20080000

# Check if the registry path exists, if not create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Output "Registry path created: $registryPath"
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord -Force
    Write-Output "Successfully set $valueName to $('{0:X}' -f $valueData) at $registryPath"
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the setting was applied correctly
$verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Output "Verification successful: $valueName is set to $('{0:X}' -f $verifyValue.$valueName)"
} else {
    Write-Warning "Verification failed: $valueName is set to $('{0:X}' -f $verifyValue.$valueName) instead of $('{0:X}' -f $valueData)"
}
