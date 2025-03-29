<#
.SYNOPSIS
    This PowerShell script creates or modifies the "EccCurves" registry key in Windows 10's cryptography configuration, setting it to use the NistP384 and NistP256 elliptic curves for SSL/TLS connections, which affects the system's cryptographic security posture.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000052

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\Configure-EccCurves.ps1
#>

# Registry path and value configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
$valueName = "EccCurves"
$valueData = @("NistP384", "NistP256")

# Create the registry path if it doesn't exist
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Created registry path: $registryPath"
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type MultiString
Write-Host "Successfully set $valueName to $($valueData -join ' ') at $registryPath"

# Verify the change
$verifyValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
Write-Host "Verification: $valueName is now set to $($verifyValue -join ' ')"
