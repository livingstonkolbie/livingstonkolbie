<#
.SYNOPSIS
    This PowerShell script checks for administrative privileges, creates the WinRM Service registry path if it doesn't exist, sets the DisableRunAs value to 1 to prevent the WinRM service from using the RunAs credential, and verifies the configuration was applied correctly.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000355

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000355.ps1 
#>

# Script to implement STIG control for Windows 10
# Registry Hive: HKEY_LOCAL_MACHINE
# Registry Path: \SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\
# Value Name: DisableRunAs
# Value Type: REG_DWORD
# Value: 1

# Check if script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Error "This script requires administrative privileges. Please run as administrator."
    exit 1
}

# Registry path where the setting needs to be applied
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"

# Create the registry path if it doesn't exist
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
    Set-ItemProperty -Path $registryPath -Name "DisableRunAs" -Value 1 -Type DWord -Force
    Write-Output "Successfully set DisableRunAs value to 1"
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the setting
$verifyValue = Get-ItemProperty -Path $registryPath -Name "DisableRunAs" -ErrorAction SilentlyContinue

if ($verifyValue -and $verifyValue.DisableRunAs -eq 1) {
    Write-Output "Verification successful: DisableRunAs is set to 1"
}
else {
    Write-Error "Verification failed: DisableRunAs is not set correctly"
    exit 1
}

Write-Output "STIG implementation completed successfully"
