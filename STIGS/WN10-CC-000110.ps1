<#
.SYNOPSIS
    This script prevents the client computer from printing over HTTP which allows the computer to print to printers on the intranet as well as the Internet.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000110.ps1 
#>

# Script to implement STIG requirement for disabling HTTP Printing
# Target: Windows 10
# Registry Hive: HKEY_LOCAL_MACHINE
# Registry Path: \SOFTWARE\Policies\Microsoft\Windows NT\Printers\
# Value Name: DisableHTTPPrinting
# Value Type: REG_DWORD
# Value: 1

# Check if running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"

# Ensure the registry path exists
if (-not (Test-Path -Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Created registry path: $registryPath"
    }
    catch {
        Write-Error "Failed to create registry path: $_"
        exit 1
    }
}

# Set the registry value
try {
    New-ItemProperty -Path $registryPath -Name "DisableHTTPPrinting" -Value 1 -PropertyType DWORD -Force | Out-Null
    Write-Output "Successfully set DisableHTTPPrinting to 1"
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the setting was applied correctly
$verifyValue = Get-ItemProperty -Path $registryPath -Name "DisableHTTPPrinting" -ErrorAction SilentlyContinue

if ($verifyValue -and $verifyValue.DisableHTTPPrinting -eq 1) {
    Write-Output "Verification successful: DisableHTTPPrinting is set to 1"
} else {
    Write-Warning "Verification failed: DisableHTTPPrinting was not set correctly"
}

Write-Output "STIG implementation complete"
