# Creates a new registry property named 'PowerShellPath' with a string value set to the path of PowerShell ($PSHome).
# The new property is added to both 'HKLM:\SYSTEM\CurrentControlSet\Control' and 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' registry paths.

New-ItemProperty -Name PowerShellPath -PropertyType String -Value $PSHome -Path HKLM:\SYSTEM\CurrentControlSet\Control, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion

