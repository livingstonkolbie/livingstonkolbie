<#
.SYNOPSIS
    The script disables unencrypted WinRM client traffic by creating the necessary registry path if it doesn't exist, setting the "AllowUnencryptedTraffic" registry value to 0 in the Windows WinRM Client policy, and verifying the change was applied successfully.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000335

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000335.ps1 
#>

# Script to implement STIG control for WinRM Client - Disable Unencrypted Traffic
# Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client
# Value: AllowUnencryptedTraffic = 0

# Define registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$valueName = "AllowUnencryptedTraffic"
$valueData = 0
$valueType = "DWord"

# Check if the registry path exists, if not create it
if (-not (Test-Path -Path $registryPath)) {
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
    Write-Output "Successfully set $valueName to $valueData"
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the registry value was set correctly
$verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Output "Verification successful: $valueName is set to $valueData"
}
else {
    Write-Warning "Verification failed: $valueName is NOT set to expected value!"
    Write-Output "Current value: $($verifyValue.$valueName)"
}

Write-Output "STIG implementation complete for WinRM Client - Disable Unencrypted Traffic"
