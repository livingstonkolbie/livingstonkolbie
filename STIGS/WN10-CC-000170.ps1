<#
.SYNOPSIS
    The script creates or modifies the MSAOptional registry value under the Windows System Policies path to force Microsoft accounts to be optional for Windows 10 users, enhancing security by allowing local account usage without requiring Microsoft account integration.RetryClaude can make mistakes. Please double-check responses.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000170

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000170.ps1 
#>

# Script to set MSAOptional registry value for Windows 10 STIG compliance

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "MSAOptional"
$value = 1

# Check if the registry path exists, create it if it doesn't
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Output "Registry path created: $registryPath"
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $value -Type DWord -Force
    Write-Output "Successfully set $valueName to $value at $registryPath"
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the setting was applied correctly
$verifyValue = (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue).$valueName
if ($verifyValue -eq $value) {
    Write-Output "Verification successful: $valueName is set to $verifyValue"
} else {
    Write-Warning "Verification failed: $valueName is set to $verifyValue, expected $value"
}
