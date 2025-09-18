# Set main profile directory
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name ProfilesDirectory -Value "C:\Users"

# Update Default and Public values under the main ProfileList key
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Default" -Value "C:\Users\Default"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" -Name "Public" -Value "C:\Users\Public"

# Paths for Default profile and Users directory
$defaultProfilePath = "C:\Users\Default"
$usersBasePath = "C:\Users"

# Enumerate all profile SIDs under ProfileList
$ProfileListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profiles = Get-ChildItem -Path $ProfileListPath

foreach ($profile in $profiles) {
    $SID = $profile.PSChildName
    $ProfileImagePath = (Get-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath).ProfileImagePath

    # Check for Default and Public profiles in SID keys
    if ($ProfileImagePath -like "*\Default") {
        Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value "$usersBasePath\Default"
        continue
    }
    if ($ProfileImagePath -like "*\Public") {
        Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value "$usersBasePath\Public"
        continue
    }

    # Get username from the ProfileImagePath (last folder name)
    $username = Split-Path $ProfileImagePath -Leaf

    # Standardize path: C:\Users\username
    $newPath = Join-Path $usersBasePath $username

    # Check if the user profile folder exists, create it from Default if missing
    if (-not (Test-Path -Path $newPath)) {
        Write-Host "Profile folder for $username does not exist. Creating from Default profile."
        Copy-Item -Path $defaultProfilePath -Destination $newPath -Recurse -Force
    }

    # Update the registry with the new profile path
    Set-ItemProperty -Path "$ProfileListPath\$SID" -Name ProfileImagePath -Value $newPath
}

Write-Host "Changes applied. Please restart your device to ensure changes take effect."
