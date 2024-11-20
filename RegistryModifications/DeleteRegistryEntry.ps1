# Removes the 'PSHome' property from the registry key 'HKLM:\SYSTEM\CurrentControlSet\Control'.
# This deletes the custom registry entry that was previously added or modified.
Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name PSHome
