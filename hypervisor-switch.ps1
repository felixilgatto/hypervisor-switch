# Check if the script is being run as an administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.Forms.MessageBox]::Show('This script must be run as an administrator. Please restart it with elevated privileges.', 'Administrator Required', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

# Define a function to show a message box and get user input
function Show-RestartPrompt {
    Add-Type -AssemblyName 'System.Windows.Forms'
    $result = [System.Windows.Forms.MessageBox]::Show('Do you want to restart now?', 'Restart Prompt', 'YesNo', 'Question')

    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Restart-Computer
    }
    else {
        Write-Host "Restart canceled."
    }
}

function Get-HypervisorLaunchType {
    # Get the current hypervisor launch type configuration using bcdedit command
    $config = bcdedit /enum | Where-Object { $_.StartsWith("hypervisorlaunchtype") }
    Write-Debug "Hypervisor Launch Type: $config"

    # Extract the value (either "auto" or "off") from the configuration string
    $state = $($config -Split " ")[-1]
    Write-Debug "Hypervisor Launch Type: $state"

    Switch ($state) {
        "auto" { Return $true }
        "off" { Return $false }	
        Default { Throw "Unknown Hypervisor Launch Type: $state" }
    }
    
}

function Set-HypervisorLaunchType {
    param (
        [bool]$state
    )

    if ($state) {
        Write-Debug "Hypervisor Launch Type: auto"
        bcdedit /set hypervisorlaunchtype auto
    }
    else {
        Write-Debug "Hypervisor Launch Type: auto"
        bcdedit /set hypervisorlaunchtype off
    }
}

-Not (Get-HypervisorLaunchType) | Set-HypervisorLaunchType

Show-RestartPrompt