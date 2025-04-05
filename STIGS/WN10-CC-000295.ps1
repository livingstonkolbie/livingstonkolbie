<#
.SYNOPSIS
    The script creates the Internet Explorer Feeds registry path if it doesn't exist, sets the DisableEnclosureDownload value to 1 to prevent automatic downloading of enclosures (attachments) from RSS feeds, and verifies the setting was applied correctly.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000295

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000295.ps1 
#>

# Script to implement STIG control for Internet Explorer Feeds
# Registry Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds
# Value Name: DisableEnclosureDownload
# Value Type: REG_DWORD
# Value: 1

# Check if running with administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Error "This script requires administrator privileges. Please run PowerShell as an administrator and try again."
    exit 1
}

# Create the registry path if it doesn't exist
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"
if (-not (Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Created registry path: $registryPath"
    }
    catch {
        Write-Error "Failed to create registry path: $registryPath. Error: $_"
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name "DisableEnclosureDownload" -Value 1 -Type DWord -Force
    Write-Output "Successfully set DisableEnclosureDownload to 1"
}
catch {
    Write-Error "Failed to set registry value. Error: $_"
    exit 1
}

# Verify the setting was applied correctly
try {
    $verifyValue = Get-ItemProperty -Path $registryPath -Name "DisableEnclosureDownload" -ErrorAction Stop
    if ($verifyValue.DisableEnclosureDownload -eq 1) {
        Write-Output "Verification successful: DisableEnclosureDownload is set to 1"
    }
    else {
        Write-Warning "Verification failed: DisableEnclosureDownload is not set to 1"
    }
}
catch {
    Write-Error "Failed to verify registry value. Error: $_"
}
