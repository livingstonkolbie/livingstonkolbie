<#
.SYNOPSIS
    This script ensures the user is prompted for a password on resume from sleep (on battery).

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000145

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000145.ps1 
#>

# Script to configure the Power Settings registry key
# This script sets the DCSettingIndex value for the specified Power Setting GUID

# Check if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Define the registry path and values
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"
$Name = "DCSettingIndex"
$Value = 1
$Type = "DWord"

# Create the registry path if it doesn't exist
if (!(Test-Path $RegistryPath)) {
    try {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create registry path: $_"
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -Type $Type -Force
    Write-Host "Successfully set $Name to $Value in $RegistryPath" -ForegroundColor Green
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the registry value was set correctly
$VerifyValue = Get-ItemProperty -Path $RegistryPath -Name $Name -ErrorAction SilentlyContinue
if ($VerifyValue.$Name -eq $Value) {
    Write-Host "Verified registry value $Name is set to $Value" -ForegroundColor Green
}
else {
    Write-Warning "Registry value verification failed. Current value: $($VerifyValue.$Name)"
}
