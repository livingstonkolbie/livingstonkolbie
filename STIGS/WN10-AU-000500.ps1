<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Kolbie Livingston
    LinkedIn        : linkedin.com/in/kolbielivingston/
    GitHub          : github.com/livingstonkolbie
    Date Created    : 2025-03-26
    Last Modified   : 2025-03-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# Create the registry path if it doesn't exist
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" -Force
}

# Set the MaxSize value to 0x8000 (32768 decimal)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" -Name "MaxSize" -Value 0x8000 -Type DWord
