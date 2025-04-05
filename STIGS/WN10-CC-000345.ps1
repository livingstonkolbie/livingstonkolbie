<#
.SYNOPSIS
    This script creates the WinRM Service registry path if it doesn't exist, sets the AllowBasic value to 0 to disable insecure basic authentication for Windows Remote Management, and verifies the configuration was applied correctly.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000345

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000345.ps1 
#>

# Script to disable Basic Authentication for WinRM Service

# Define registry path and values
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$valueName = "AllowBasic"
$valueData = 0
$valueType = "DWORD"

# Check if the registry path exists, if not create it
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
    Write-Output "Successfully configured $valueName = $valueData in $registryPath"
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the change
$verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Output "Verification successful: $valueName is set to $valueData"
} 
else {
    Write-Warning "Verification failed: $valueName is NOT set to $valueData"
}
