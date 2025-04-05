<#
.SYNOPSIS
    The script creates the CloudContent registry key path if it doesn't exist, sets the DisableThirdPartySuggestions DWORD value to 1, and verifies the configuration was successfully applied to prevent third-party content suggestions in Windows 10.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000390

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000390.ps1 
#>

$regPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$valueName = "DisableThirdPartySuggestions"
$value = 1

# Check if the registry path exists
if (!(Test-Path $regPath)) {
    # Create the registry path if it doesn't exist
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $valueName -Value $value -Type DWord
Write-Host "Set $valueName to $value in $regPath"

# Verify the setting was applied correctly
$currentValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue
if ($currentValue.$valueName -eq $value) {
    Write-Host "Verification successful: $valueName is set to $value"
} else {
    Write-Warning "Verification failed: $valueName is set to $($currentValue.$valueName)"
}
