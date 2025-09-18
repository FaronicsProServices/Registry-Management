# List of special ProfileImagePath locations to exclude
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

    # Set registry values as highlighted in your screenshot
    # ProfileImagePath is already correct - if you want to standardize, use this:
    # $newProfilePath = "C:\Users\" + (Split-Path $profilePath -Leaf)
    # Set-ItemProperty -Path "$ProfileListPath\$SID" -Name "ProfileImagePath" -Value $newProfilePath

    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name RefCount -Value 0
    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name State -Value 0
}

Write-Host "Applied registry changes for non-system user profiles. Please restart your device if needed."
