# Get the current hypervisor launch type configuration using bcdedit command
$config = bcdedit /enum | Where-Object { $_.StartsWith("hypervisorlaunchtype") }

# Extract the value (either "auto" or "off") from the configuration string
$value = $($config -Split " ")[-1]

# Check the current value and toggle the hypervisor launch type accordingly
if ($value -eq "auto") {
    # If current value is "auto", set it to "off"
    bcdedit /set hypervisorlaunchtype off
} else {
    # If current value is "off", set it to "auto"
    bcdedit /set hypervisorlaunchtype auto
}

# Restart the computer to apply the changes to the hypervisor launch type
Restart-Computer