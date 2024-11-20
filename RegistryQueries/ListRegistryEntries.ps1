# Retrieves the properties of the registry key at the specified path 'RegistryPath'.
# Replace 'RegistryPath' with the actual path to the registry key you want to view.
# Example: To view the properties of the 'Control' key in the system registry, use:
# Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control
Get-ItemProperty -Path Registry::RegistryPath
