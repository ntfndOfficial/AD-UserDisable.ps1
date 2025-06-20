param (
    [Parameter(Mandatory = $true)]
    [string]$Name
)

# Boşlukları wildcard (*) ile değiştir
$wildcardName = $Name -replace '\s+', '*'

# AD modülü
Import-Module ActiveDirectory

# Kullanıcıları al
$users = Get-ADUser -Filter "Name -like '*$wildcardName*'" -Properties SAMAccountName | Select-Object SAMAccountName

# Sonuç kontrolü
if ($users.Count -eq 0) {
    Write-Host "`nNo users found matching: $Name" -ForegroundColor Yellow
    exit
}

# Numaralandırarak listele
Write-Host "`nFound $($users.Count) account(s):`n" -ForegroundColor Cyan
$i = 1
foreach ($user in $users) {
    Write-Host ("{0,2}) {1}" -f $i, $user.SamAccountName)
    $i++
}

# ID seçimi
$inputIDs = Read-Host -Prompt "`nEnter ID(s) you wanna disable (comma-separated)"
if (-not $inputIDs) {
    Write-Host "`nNo IDs entered. Exiting." -ForegroundColor Yellow
    exit
}

# Seçilen kullanıcıları filtrele
$selectedIndexes = $inputIDs -split ',' | ForEach-Object { ($_ -as [int]) - 1 } # 0-based index
$selectedUsers = for ($j = 0; $j -lt $users.Count; $j++) {
    if ($selectedIndexes -contains $j) {
        $users[$j]
    }
}

# Son kontrol
if ($selectedUsers.Count -eq 0) {
    Write-Host "`nNo valid users selected." -ForegroundColor Yellow
    exit
}

Write-Host "`nSelected users to disable:`n" -ForegroundColor Cyan
$k = 1
foreach ($user in $selectedUsers) {
    Write-Host ("{0,2}) {1}" -f $k, $user.SamAccountName)
    $k++
}

# Onay
$response = Read-Host -Prompt "`nDo you wanna disable these accounts? (Y/N)"

if ($response -ne 'Y' -and $response -ne 'y') {
    Write-Host "`nAborted by user." -ForegroundColor Yellow
    exit
}

# Disable işlemi
foreach ($user in $selectedUsers) {
    Disable-ADAccount -Identity $user.SamAccountName
    Write-Host "Disabled: $($user.SamAccountName)" -ForegroundColor Green
}
