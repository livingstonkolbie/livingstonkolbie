<#
.SYNOPSIS
    The script creates and sets the registry key to a value of 1, which prevents Windows from automatically downloading device drivers over the internet during printer installation, thereby reducing potential attack surface.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000100

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000100.ps1 
#>

# Script to implement STIG control for disabling Web PnP Download
# Creates the registry key: HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\DisableWebPnPDownload with value 1

# Check if running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Define registry path and values
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$registryName = "DisableWebPnPDownload"
$registryValue = 1

# Create the registry path if it doesn't exist
if (-not (Test-Path -Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Created registry path: $registryPath"
    } catch {
        Write-Error "Failed to create registry path: $_"
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force
    Write-Output "Successfully set $registryName to $registryValue"
    
    # Verify the setting was applied correctly
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
    
    if ($verifyValue.$registryName -eq $registryValue) {
        Write-Output "Verification successful - STIG control has been implemented correctly."
    } else {
        Write-Warning "Verification failed - Registry value does not match expected value."
    }
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}
