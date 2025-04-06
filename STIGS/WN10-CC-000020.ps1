<#
.SYNOPSIS
    This script sets the IPv6 source routing security parameter to completely disable IP source routing by creating or modifying the DisableIpSourceRouting registry value under the Tcpip6 Parameters key.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-06
    Last Modified   : 2025-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000020

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000020.ps1 
#>

# Script to configure IPv6 source routing settings
# STIG ID: Windows 10 IPv6 Source Routing Disable

# Check if running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator"
    Exit 1
}

# Registry path and values
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
$name = "DisableIpSourceRouting"
$value = 2

# Create the registry path if it doesn't exist
if (!(Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry path $registryPath"
    }
    catch {
        Write-Error "Failed to create registry path: $_"
        Exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord -Force
    Write-Host "Successfully configured DisableIpSourceRouting to value $value"
}
catch {
    Write-Error "Failed to set registry value: $_"
    Exit 1
}

# Verify the change
$verifyValue = (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue).$name
if ($verifyValue -eq $value) {
    Write-Host "Verification successful: DisableIpSourceRouting = $verifyValue" -ForegroundColor Green
}
else {
    Write-Warning "Verification failed: DisableIpSourceRouting = $verifyValue (expected $value)"
}
