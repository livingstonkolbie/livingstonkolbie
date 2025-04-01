<#
.SYNOPSIS
    This PowerShell script creates or modifies the registry value in the Windows CloudContent policy path, setting it to 1 (enabled) to disable consumer features like suggested apps and Windows tips in accordance with security hardening requirements.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-31
    Last Modified   : 2025-03-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000197

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000197.ps1 
#>

# Script to implement STIG control for disabling Windows consumer features
# Check if running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires administrative privileges. Please run as Administrator."
    exit
}

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$valueName = "DisableWindowsConsumerFeatures"
$valueData = 1
$valueType = "DWord"

try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Created registry path: $registryPath"
    }

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Output "Successfully set $valueName to $valueData in $registryPath"
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

Write-Output "STIG implementation completed successfully."
