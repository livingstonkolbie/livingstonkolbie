<#
.SYNOPSIS
    This script modifies the Windows registry to disable the automatic sign-on after a system restart by setting the DisableAutomaticRestartSignOn value to 1 in the System policies, which prevents cached credentials from being automatically used during the restart process.

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000325

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000325.ps1 
#>

# Script to disable automatic restart sign-on
try {
    # Define the registry path and value name
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $valueName = "DisableAutomaticRestartSignOn"
    $value = 1
    
    # Check if the registry path exists, if not create it
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    # Set the registry value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $value -Type DWord
    
    # Verify the change
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName | Select-Object -ExpandProperty $valueName
    
    if ($currentValue -eq $value) {
        Write-Output "SUCCESS: Registry value '$valueName' has been set to $value."
    } else {
        Write-Output "ERROR: Failed to set registry value. Current value is $currentValue."
    }
} catch {
    Write-Output "ERROR: An exception occurred - $($_.Exception.Message)"
}
