# Update main profile directory and Default/Public paths
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "ProfilesDirectory" -Value "C:\Users"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Default" -Value "C:\Users\Default"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Public" -Value "C:\Users\Public"

# Define special profiles to exclude
$excludedProfiles = @(
    "C:\Windows\ServiceProfiles\NetworkService",
    "C:\Windows\ServiceProfiles\LocalService",
    "C:\Windows\system32\config\systemprofile"
)

# Enumerate all user profile SIDs under ProfileList
$ProfileListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profiles = Get-ChildItem -Path $ProfileListPath

foreach ($profile in $profiles) {
    $SID = $profile.PSChildName
    $profileKeyPath = "$ProfileListPath\$SID"
    $profileProps = Get-ItemProperty -Path $profileKeyPath -ErrorAction SilentlyContinue

    if ($null -eq $profileProps.ProfileImagePath) {
        continue
    }

    $profilePath = $profileProps.ProfileImagePath

    # Skip special system accounts
    if ($excludedProfiles -contains $profilePath) {
        continue
    }

    # Update ProfileImagePath to C:\Users\username (taken from last folder name in path)
    $username = Split-Path $profilePath -Leaf
    $newProfilePath = "C:\Users\$username"
    Set-ItemProperty -Path $profileKeyPath -Name ProfileImagePath -Value $newProfilePath

    # Set RefCount and State to 0 for user profiles
    Set-ItemProperty -Path $profileKeyPath -Name RefCount -Value 0
    Set-ItemProperty -Path $profileKeyPath -Name State -Value 0
}

Write-Host "Updated profile paths and reset RefCount/State for all user profiles except system profiles. Please restart your device."
