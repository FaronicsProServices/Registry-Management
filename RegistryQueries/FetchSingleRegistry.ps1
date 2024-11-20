# Retrieves the value of the 'CurrentUser' property from the registry key 'HKLM:\SYSTEM\CurrentControlSet\Control'.
# This property may represent settings related to the currently active user session in the system.
# Registry path needs to specified and can be changed.
Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name CurrentUser
