# Retrieves all child items (subkeys) under the 'HKLM:\' registry path and displays their names.
# This command lists all the top-level registry keys under the 'HKEY_LOCAL_MACHINE' hive.
Get-ChildItem -Path HKLM:\ | Select-Object Name
