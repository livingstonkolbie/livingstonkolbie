<#
.SYNOPSIS
    This PowerShell script prevents unencrypted remote access to the system that can allow sensitive information to be compromised.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-31
    Last Modified   : 2025-03-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000350

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000350.ps1 
#>

# WinRM Service Security Configuration Script
# Purpose: Implements STIG control to disable unencrypted WinRM traffic
# Registry Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\
# Value Name: AllowUnencryptedTraffic
# Value Type: REG_DWORD
# Value: 0

# Check if script is running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires administrative privileges. Please run as administrator."
    exit 1
}

# Define registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$valueName = "AllowUnencryptedTraffic"
$valueData = 0
$valueType = "DWord"

# Create the registry path if it doesn't exist
if (!(Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Registry path created: $registryPath"
    }
    catch {
        Write-Error "Failed to create registry path: $_"
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Output "Registry value set successfully:"
    Write-Output "Path: $registryPath"
    Write-Output "Name: $valueName"
    Write-Output "Value: $valueData (Unencrypted WinRM traffic is disabled)"
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the setting was applied correctly
try {
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    if ($verifyValue.$valueName -eq $valueData) {
        Write-Output "Verification successful: WinRM Service is now configured to disallow unencrypted traffic."
    }
    else {
        Write-Warning "Verification failed: The registry value does not match the expected value."
    }
}
catch {
    Write-Error "Failed to verify registry value: $_"
}

# Restart the WinRM service to apply changes
try {
    Restart-Service -Name WinRM -Force
    Write-Output "WinRM service restarted successfully."
}
catch {
    Write-Warning "Failed to restart WinRM service: $_"
    Write-Output "The registry change has been made, but you may need to restart the WinRM service manually or restart the computer for changes to take effect."
}

Write-Output "STIG implementation complete."
