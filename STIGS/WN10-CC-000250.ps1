<#
.SYNOPSIS
    This script creates the Microsoft Edge PhishingFilter registry path if it doesn't exist and sets the EnabledV9 value to 1, which enables the phishing filter protection feature in Microsoft Edge for enhanced security against phishing attacks.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000250

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000250.ps1 
#>

# STIG ID Implementation for Microsoft Edge PhishingFilter configuration
# Creates registry path if it doesn't exist and sets the EnabledV9 value to 1

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"
$valueName = "EnabledV9"
$value = 1

# Check if the registry path exists, create it if it doesn't
if (-not (Test-Path $registryPath)) {
    Write-Output "Registry path does not exist. Creating it..."
    New-Item -Path $registryPath -Force | Out-Null
    Write-Output "Registry path created successfully."
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $value -Type DWord -Force
    Write-Output "Successfully set $valueName to $value in $registryPath"
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify the registry setting was applied correctly
$verifyValue = (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue).$valueName
if ($verifyValue -eq $value) {
    Write-Output "Verification successful: $valueName is set to $verifyValue"
} else {
    Write-Error "Verification failed: $valueName is set to $verifyValue instead of $value"
    exit 1
}

Write-Output "STIG implementation complete."
