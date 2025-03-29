<#
.SYNOPSIS
    This PowerShell script creates the Windows Ink Workspace registry path if it doesn't exist, sets the AllowWindowsInkWorkspace value to 1 to configure the feature as required by the STIG, and performs verification to ensure the setting was applied successfully.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000385

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000385.ps1 
#>

# Script to configure Windows Ink Workspace settings per STIG requirements
# Check if running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Define the registry path and value
$registryPath = "HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace"
$valueName = "AllowWindowsInkWorkspace"
$valueData = 1
$valueType = "DWord"

try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Registry path created: $registryPath"
    }

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Output "Successfully configured Windows Ink Workspace setting."
    Write-Output "Registry value '$valueName' set to '$valueData' in '$registryPath'"
} catch {
    Write-Error "Failed to set the registry value: $_"
    exit 1
}

# Verify the setting was applied correctly
$verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
if ($verifyValue.$valueName -eq $valueData) {
    Write-Output "Verification successful: The registry setting has been applied correctly."
} else {
    Write-Error "Verification failed: The registry setting was not applied correctly."
    exit 1
}
