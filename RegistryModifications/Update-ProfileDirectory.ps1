# Set main profile directory
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name ProfilesDirectory -Value "C:\Users"

# Enumerate all profile SIDs under ProfileList
$ProfileListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profiles = Get-ChildItem -Path $ProfileListPath

foreach ($profile in $profiles) {
    $SID = $profile.PSChildName
    $ProfileImagePath = (Get-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath).ProfileImagePath

    # Check for Default and Public profiles
    if ($ProfileImagePath -like "*\Default") {
        Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value "C:\Users\Default"
        continue
    }
    if ($ProfileImagePath -like "*\Public") {
        Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value "C:\Users\Public"
        continue
    }

    # Try to get username from the ProfileImagePath (usually last folder name)
    $username = Split-Path $ProfileImagePath -Leaf

    # Standardize path: C:\Users\username
    $newPath = "C:\Users\$username"

    # Update the registry with the new profile path
    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value $newPath
}


Write-Host "Changes applied. Please restart your device to ensure changes take effect."
