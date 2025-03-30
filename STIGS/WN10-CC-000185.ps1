<#
.SYNOPSIS
    This script configuring a setting that prevents autorun commands from executing.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000185

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000185.ps1 
#>

# Script to implement STIG control for disabling AutoRun
# Registry Hive: HKEY_LOCAL_MACHINE
# Registry Path: \SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\
# Value Name: NoAutorun
# Value Type: REG_DWORD
# Value: 1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoAutorun"
$value = 1

# Check if the registry path exists, if not create it
if (!(Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry path created: $registryPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error creating registry path: $_" -ForegroundColor Red
        exit 1
    }
}

# Check if the registry value exists
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    # If the value exists, update it if needed
    if ($null -ne $currentValue) {
        if ($currentValue.$valueName -ne $value) {
            Set-ItemProperty -Path $registryPath -Name $valueName -Value $value -Type DWord
            Write-Host "Registry value updated: $valueName = $value" -ForegroundColor Green
        }
        else {
            Write-Host "Registry value already set correctly: $valueName = $value" -ForegroundColor Yellow
        }
    }
    # If the value doesn't exist, create it
    else {
        New-ItemProperty -Path $registryPath -Name $valueName -Value $value -PropertyType DWord | Out-Null
        Write-Host "Registry value created: $valueName = $value" -ForegroundColor Green
    }
    
    # Verify the setting was applied correctly
    $verifyValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
    if ($verifyValue -eq $value) {
        Write-Host "STIG implementation successful: AutoRun has been disabled." -ForegroundColor Green
    }
    else {
        Write-Host "STIG implementation verification failed." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error setting registry value: $_" -ForegroundColor Red
    exit 1
}
