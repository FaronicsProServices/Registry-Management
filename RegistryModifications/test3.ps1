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
    $profileProps = Get-ItemProperty -Path "$ProfileListPath\$SID" -ErrorAction SilentlyContinue

    if ($null -eq $profileProps.ProfileImagePath) {
        continue
    }

    $profilePath = $profileProps.ProfileImagePath

    # Skip special system accounts
    if ($excludedProfiles -contains $profilePath) {
        continue
    }

    # Set RefCount and State to 0 for user profiles
    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name RefCount -Value 0
    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name State -Value 0
}

Write-Host "Main profile paths updated and RefCount/State reset for user profiles. Please restart your computer to apply changes."
