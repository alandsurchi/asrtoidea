param(
  [string]$BaseUrl = 'https://asrtoidea-production.up.railway.app/api/v1',
  [string]$Password = 'Passw0rd!123'
)

$ErrorActionPreference = 'Stop'

function Invoke-Api {
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
    [string]$Method,

    [Parameter(Mandatory = $true)]
    [string]$Url,

    [hashtable]$Headers,
    $Body
  )

  $params = @{
    Method = $Method
    Uri = $Url
    ContentType = 'application/json'
  }

  if ($Headers) {
    $params.Headers = $Headers
  }

  if ($null -ne $Body) {
    $params.Body = ($Body | ConvertTo-Json -Depth 8)
  }

  return Invoke-RestMethod @params
}

try {
  $stamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
  $acctAEmail = "verifyA+$stamp@testmail.com"
  $acctBEmail = "verifyB+$stamp@testmail.com"

  Write-Host "[1/7] Registering two accounts..."
  $regA = Invoke-Api -Method POST -Url "$BaseUrl/auth/register" -Body @{
    name = 'Verify Account A'
    email = $acctAEmail
    password = $Password
  }
  $regB = Invoke-Api -Method POST -Url "$BaseUrl/auth/register" -Body @{
    name = 'Verify Account B'
    email = $acctBEmail
    password = $Password
  }

  Write-Host "[2/7] Logging in both accounts..."
  $loginA = Invoke-Api -Method POST -Url "$BaseUrl/auth/login" -Body @{
    email = $acctAEmail
    password = $Password
  }
  $loginB = Invoke-Api -Method POST -Url "$BaseUrl/auth/login" -Body @{
    email = $acctBEmail
    password = $Password
  }

  $tokenA = $loginA.data.token
  $tokenB = $loginB.data.token
  if ([string]::IsNullOrWhiteSpace($tokenA) -or [string]::IsNullOrWhiteSpace($tokenB)) {
    throw 'Login did not return valid tokens for one or both accounts.'
  }

  $headersA = @{ Authorization = "Bearer $tokenA" }
  $headersB = @{ Authorization = "Bearer $tokenB" }

  Write-Host "[3/7] Creating private ideas (one per account)..."
  $ideaATitle = "Verify Idea A $stamp"
  $ideaBTitle = "Verify Idea B $stamp"

  $null = Invoke-Api -Method POST -Url "$BaseUrl/ideas" -Headers $headersA -Body @{
    title = $ideaATitle
    description = 'Private idea from account A'
    category = 'General'
    priority = 'Medium'
    status = 'Generated'
    backgroundImage = 'assets/images/img_rectangle_29_250x400.png'
    teamMembers = @()
    additionalMembersCount = '0'
  }

  $null = Invoke-Api -Method POST -Url "$BaseUrl/ideas" -Headers $headersB -Body @{
    title = $ideaBTitle
    description = 'Private idea from account B'
    category = 'General'
    priority = 'Medium'
    status = 'Generated'
    backgroundImage = 'assets/images/img_rectangle_29_250x400.png'
    teamMembers = @()
    additionalMembersCount = '0'
  }

  Write-Host "[4/7] Creating Explore projects (one per account)..."
  $projectATitle = "Verify Project A $stamp"
  $projectBTitle = "Verify Project B $stamp"

  $null = Invoke-Api -Method POST -Url "$BaseUrl/projects" -Headers $headersA -Body @{
    title = $projectATitle
    description = 'Explore post from account A'
    backgroundImage = 'assets/images/img_rectangle_29_250x400.png'
    primaryChip = 'General'
    priorityChip = 'Medium'
    avatarImages = @()
    teamCount = 0
    statusText = 'Generated'
    statusIcon = ''
    actionIcon = ''
  }

  $null = Invoke-Api -Method POST -Url "$BaseUrl/projects" -Headers $headersB -Body @{
    title = $projectBTitle
    description = 'Explore post from account B'
    backgroundImage = 'assets/images/img_rectangle_29_250x400.png'
    primaryChip = 'General'
    priorityChip = 'Medium'
    avatarImages = @()
    teamCount = 0
    statusText = 'Generated'
    statusIcon = ''
    actionIcon = ''
  }

  Write-Host "[5/7] Verifying profile updates are account-specific..."
  $nickA = "verify_nick_a_$stamp"
  $jobA = 'QA Verifier'
  $profileUpdateA = Invoke-Api -Method PUT -Url "$BaseUrl/auth/profile" -Headers $headersA -Body @{
    nickName = $nickA
    job = $jobA
  }

  $profileA = Invoke-Api -Method GET -Url "$BaseUrl/auth/profile" -Headers $headersA
  $profileB = Invoke-Api -Method GET -Url "$BaseUrl/auth/profile" -Headers $headersB

  Write-Host "[6/7] Verifying idea isolation by account..."
  $ideasA = Invoke-Api -Method GET -Url "$BaseUrl/ideas" -Headers $headersA
  $ideasB = Invoke-Api -Method GET -Url "$BaseUrl/ideas" -Headers $headersB

  $aSeesBIdea = @($ideasA.data | Where-Object { $_.title -eq $ideaBTitle }).Count -gt 0
  $bSeesAIdea = @($ideasB.data | Where-Object { $_.title -eq $ideaATitle }).Count -gt 0
  $ideasIsolated = (-not $aSeesBIdea) -and (-not $bSeesAIdea)

  Write-Host "[7/7] Verifying Explore global feed behavior..."
  $projectsA = Invoke-Api -Method GET -Url "$BaseUrl/projects" -Headers $headersA
  $projectsB = Invoke-Api -Method GET -Url "$BaseUrl/projects" -Headers $headersB

  $aSeesBProject = @($projectsA.data | Where-Object { $_.title -eq $projectBTitle }).Count -gt 0
  $bSeesAProject = @($projectsB.data | Where-Object { $_.title -eq $projectATitle }).Count -gt 0
  $exploreIsGlobal = $aSeesBProject -and $bSeesAProject

  $profileWorks = ($profileA.data.nickName -eq $nickA) -and ($profileA.data.job -eq $jobA) -and ($profileB.data.nickName -ne $nickA)

  Write-Host ''
  Write-Host '===== Railway Verification Summary ====='
  Write-Host "Account A email: $acctAEmail"
  Write-Host "Account B email: $acctBEmail"
  Write-Host "Profile account-specific update: $profileWorks"
  Write-Host "Ideas isolated per account: $ideasIsolated"
  Write-Host "Explore is global feed: $exploreIsGlobal"
  Write-Host "A sees B project: $aSeesBProject"
  Write-Host "B sees A project: $bSeesAProject"
  Write-Host "A projects count: $(@($projectsA.data).Count)"
  Write-Host "B projects count: $(@($projectsB.data).Count)"

  if ($profileWorks -and $ideasIsolated -and $exploreIsGlobal) {
    Write-Host 'RESULT: PASS' -ForegroundColor Green
    exit 0
  }

  Write-Host 'RESULT: PARTIAL/FAIL' -ForegroundColor Yellow
  if (-not $exploreIsGlobal) {
    Write-Host '- Explore feed is still per-account. Deploy latest backend changes to Railway.' -ForegroundColor Yellow
  }
  if (-not $profileWorks) {
    Write-Host '- Profile updates are not correctly isolated/persisted per account.' -ForegroundColor Yellow
  }
  if (-not $ideasIsolated) {
    Write-Host '- Ideas endpoint is leaking data across accounts.' -ForegroundColor Yellow
  }

  exit 2
}
catch {
  Write-Host "Verification failed: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}
