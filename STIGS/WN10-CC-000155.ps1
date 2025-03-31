<#
.SYNOPSIS
    This PowerShell script creates the necessary registry path if it doesn't exist and sets the value to 0 in the Terminal Services registry location, effectively disabling Windows Remote Assistance functionality to comply with security requirements.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-31
    Last Modified   : 2025-03-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000155

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000155.ps1 
#>

# Script to implement STIG control for disabling Remote Assistance
# Registry Path: HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services
# Value Name: fAllowToGetHelp
# Value Type: REG_DWORD
# Value: 0

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires administrator privileges. Please run as administrator."
    exit 1
}

# Path to the registry key
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

# Check if registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Output "Registry path created successfully."
    }
    catch {
        Write-Error "Failed to create registry path: $_"
        exit 1
    }
}

# Set the registry value
try {
    Set-ItemProperty -Path $registryPath -Name "fAllowToGetHelp" -Value 0 -Type DWord -Force
    Write-Output "Registry value set successfully: fAllowToGetHelp = 0"
    
    # Verify the change
    $verifyValue = Get-ItemProperty -Path $registryPath -Name "fAllowToGetHelp" -ErrorAction SilentlyContinue
    
    if ($verifyValue.fAllowToGetHelp -eq 0) {
        Write-Output "Verification successful: Remote Assistance has been disabled."
    }
    else {
        Write-Warning "Verification failed: The registry value was not set correctly."
    }
}
catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Output status for logging
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output "[$date] STIG implementation completed for Remote Assistance setting (fAllowToGetHelp = 0)"
