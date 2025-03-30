<#
.SYNOPSIS
    The script creates and sets the ProcessCreationIncludeCmdLine_Enabled registry value to 1 enabling command-line parameter logging in process creation events for enhanced security auditing.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000066

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000066.ps1 
#>

# PowerShell Script to Enable Command Line Process Auditing
# This script implements STIG control for command line auditing in process creation events

# Check if running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Registry path and value to set
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
$valueName = "ProcessCreationIncludeCmdLine_Enabled"
$valueData = 1
$valueType = "DWord"

try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Created registry path: $registryPath"
    }

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    Write-Output "Successfully set $valueName to $valueData"
    
    # Verify the setting was applied correctly
    $verifyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    if ($verifyValue.$valueName -eq $valueData) {
        Write-Output "Verification successful: $valueName is set to $valueData"
    } else {
        Write-Warning "Verification failed: $valueName is not set to the expected value"
    }
    
    Write-Output "Command line auditing has been enabled. A system restart may be required for changes to take effect."
    
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
