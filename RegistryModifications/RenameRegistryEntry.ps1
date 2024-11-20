# Renames the 'PowerShellPath' property to 'PSHome' under the registry path 'HKLM:\SYSTEM\CurrentControlSet\Control'.
# The '-passthru' parameter returns the updated property, allowing further manipulation or display.
Rename-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name PowerShellPath -NewName PSHome -passthru
