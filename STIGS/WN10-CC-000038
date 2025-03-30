<#
.SYNOPSIS
    This script disables the WDigest authentication protocol's credential caching feature in Windows 10, preventing plaintext passwords from being stored in memory where they could be vulnerable to credential theft attacks.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000038

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000038.ps1 
#>

# STIG Implementation Script
# This script disables the storage of credentials in memory for Wdigest authentication

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Please restart PowerShell as an Administrator and try again."
    exit 1
}

# Registry path and value details
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest"
$name = "UseLogonCredential"
$value = 0

try {
    # Test if registry path exists
    if (-not (Test-Path $registryPath)) {
        # Create the registry path if it doesn't exist
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry path created: $registryPath"
    }

    # Check current value
    $currentValue = $null
    try {
        $currentValue = Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue
    } catch {
        # Property doesn't exist yet, which is fine
    }

    if ($null -eq $currentValue) {
        # Create the registry value
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
        Write-Host "Registry value created: $name = $value"
    } else {
        # Update the registry value
        Set-ItemProperty -Path $registryPath -Name $name -Value $value -Force | Out-Null
        Write-Host "Registry value updated: $name = $value"
    }

    # Verify the change
    $verifyValue = (Get-ItemProperty -Path $registryPath -Name $name).$name
    if ($verifyValue -eq $value) {
        Write-Host "Successfully implemented STIG control: Wdigest UseLogonCredential set to 0" -ForegroundColor Green
    } else {
        Write-Host "Failed to implement STIG control: Wdigest UseLogonCredential value is $verifyValue, should be $value" -ForegroundColor Red
    }
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
