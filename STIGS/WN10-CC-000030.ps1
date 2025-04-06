<#
.SYNOPSIS
    The script modifies the Windows registry to disable ICMP redirects by setting the EnableICMPRedirect value to 0 in the TCP/IP parameters, which prevents potential man-in-the-middle attacks that could exploit network routing changes.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-06
    Last Modified   : 2025-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000030

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000030.ps1 
#>

# PowerShell script to disable ICMP redirects on Windows 10
# Implementation for STIG requirement

# Set registry path and value name
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$valueName = "EnableICMPRedirect"
$valueData = 0
$valueType = "DWord"

# Check if the registry path exists
if (!(Test-Path $registryPath)) {
    # Create the registry path if it doesn't exist
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Registry path created: $registryPath"
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($currentValue -eq $null) {
    # Create the registry value if it doesn't exist
    New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType $valueType -Force | Out-Null
    Write-Host "Registry value created: $valueName = $valueData (Type: $valueType)"
} else {
    # Update the registry value if it already exists
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force | Out-Null
    Write-Host "Registry value updated: $valueName = $valueData (Type: $valueType)"
}

# Verify the change
$verifiedValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
if ($verifiedValue -eq $valueData) {
    Write-Host "Verification successful: $valueName is set to $verifiedValue"
} else {
    Write-Host "Verification failed: $valueName is set to $verifiedValue, but should be $valueData" -ForegroundColor Red
}
