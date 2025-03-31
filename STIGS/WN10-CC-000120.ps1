<#
.SYNOPSIS
    This PowerShell script prevents users from seeing and interacting with the network selection user interface on the Windows 10 login screen.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-31
    Last Modified   : 2025-03-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000120

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000120.ps1 
#>

# Script to implement STIG control for disabling network selection UI
# This script must be run with administrative privileges

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$valueName = "DontDisplayNetworkSelectionUI"
$valueData = 1
$valueType = "DWord"

# Check if the registry path exists, if not create it
if (!(Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry path created: $registryPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create registry path: $registryPath" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Host "Successfully set registry value:" -ForegroundColor Green
    Write-Host "Path: $registryPath" -ForegroundColor Green
    Write-Host "Name: $valueName" -ForegroundColor Green
    Write-Host "Value: $valueData" -ForegroundColor Green
    Write-Host "Type: $valueType" -ForegroundColor Green
}
catch {
    Write-Host "Failed to set registry value!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

# Verify the registry value was set correctly
try {
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    if ($verifyValue.$valueName -eq $valueData) {
        Write-Host "Verification successful! Registry value is set correctly." -ForegroundColor Green
    }
    else {
        Write-Host "Verification failed! Registry value is not set correctly." -ForegroundColor Red
        Write-Host "Current value: $($verifyValue.$valueName)" -ForegroundColor Red
    }
}
catch {
    Write-Host "Failed to verify registry value!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
}
