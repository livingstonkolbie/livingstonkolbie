<#
.SYNOPSIS
    This script will disable IP source routing by setting the DisableIPSourceRouting parameter in the TCP/IP configuration.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-29
    Last Modified   : 2025-03-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000025

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:> .\Set-DisableIPSourceRouting.ps1
#>

# PowerShell script to disable IP source routing
# Target: Windows 10

# Check if running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "This script requires administrative privileges. Please run PowerShell as Administrator."
    exit
}

# Registry path and value to set
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$valueName = "DisableIPSourceRouting"
$valueData = 2
$valueType = "DWord"

try {
    # Check if the registry key exists
    if (-not (Test-Path $registryPath)) {
        # Create the registry key if it doesn't exist
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry key created: $registryPath"
    }

    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType -Force
    
    # Verify the change
    $currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
    
    if ($currentValue -eq $valueData) {
        Write-Host "Successfully set $valueName to $valueData in $registryPath" -ForegroundColor Green
    } else {
        Write-Host "Failed to set registry value correctly. Current value is: $currentValue" -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

Write-Host "Script execution completed."
