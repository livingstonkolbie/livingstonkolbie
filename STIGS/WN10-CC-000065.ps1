<#
.SYNOPSIS
    The script disables automatic connections to non-enterprise open WiFi networks by setting the AutoConnectAllowedOEM registry value to 0 in the Windows Connection Manager service configuration.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000065

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000065.ps1 
#>

# STIG WiFi Network Manager Configuration Script
# Purpose: Sets AutoConnectAllowedOEM registry value to 0 to disable automatic connection to open WiFi networks
# Usage: Run as Administrator

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$valueName = "AutoConnectAllowedOEM"
$valueData = 0
$valueType = "DWORD"

# Check if the registry path exists
if (-not (Test-Path -Path $registryPath)) {
    try {
        # Create the registry path if it doesn't exist
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry path created: $registryPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error creating registry path: $_" -ForegroundColor Red
        exit 1
    }
}

try {
    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    
    # Verify the setting was applied correctly
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    
    if ($verifyValue.$valueName -eq $valueData) {
        Write-Host "STIG control successfully implemented." -ForegroundColor Green
        Write-Host "Registry value '$valueName' set to $valueData at path '$registryPath'." -ForegroundColor Green
    }
    else {
        Write-Host "Verification failed. Value is set to $($verifyValue.$valueName) instead of $valueData." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error setting registry value: $_" -ForegroundColor Red
    exit 1
}
