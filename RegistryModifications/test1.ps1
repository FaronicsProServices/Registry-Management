# Set the main profile directory and update Default/Public values
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "ProfilesDirectory" -Value "C:\Users"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Default" -Value "C:\Users\Default"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Public" -Value "C:\Users\Public"

Write-Host "Main profile paths updated. No SID profile keys were changed."
