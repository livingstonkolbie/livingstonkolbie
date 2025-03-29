<#
.SYNOPSIS
    This script creates the Group Policy registry path in HKEY_LOCAL_MACHINE if it doesn't exist, sets the NoGPOListChanges value to 0 as required by the STIG, and verifies the change was applied successfully.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000090

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000090.ps1
#>

# Check if the registry path exists, create it if it doesn't
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Registry path created: $regPath"
}

# Set the registry value
$valueName = "NoGPOListChanges"
$valueData = 0
$valueType = "DWord"

# Set or update the registry value
Set-ItemProperty -Path $regPath -Name $valueName -Value $valueData -Type $valueType -Force
Write-Host "Registry value '$valueName' set to $valueData in $regPath"

# Verify the registry value was set correctly
$verifyValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Host "Verification successful: Registry value is correctly set."
} else {
    Write-Host "Verification failed: Registry value was not set correctly. Current value: $($verifyValue.$valueName)"
}
