param(
  [switch]$SkipBuild = $false,
  [string]$Scope = 'alandsurchi456-gmailcoms-projects',
  [string]$Project = 'web'
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$tempDeployDir = Join-Path $env:TEMP 'ai_idea_generator1_vercel_deploy_src'
Push-Location $repoRoot

try {
  if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host 'Vercel CLI not found. Installing globally...'
    npm install -g vercel | Out-Host
  }

  Write-Host 'Checking Vercel authentication...'
  $whoami = vercel whoami
  $whoami | Out-Host

  if (-not $SkipBuild) {
    Write-Host 'Building Flutter web (release)...'
    flutter build web --release | Out-Host
  }

  if (Test-Path $tempDeployDir) {
    Remove-Item -Recurse -Force $tempDeployDir
  }
  New-Item -ItemType Directory -Path $tempDeployDir | Out-Null

  Write-Host 'Preparing clean source snapshot for deployment...'
  $excludeDirs = @(
    '.git',
    '.dart_tool',
    'build',
    'backend',
    'node_modules',
    'ios',
    'android',
    'windows',
    'linux',
    'macos',
    '.idea',
    '.vscode'
  )
  $excludeArgs = @()
  foreach ($dir in $excludeDirs) {
    $excludeArgs += (Join-Path $repoRoot $dir)
  }

  $robocopyArgs = @(
    $repoRoot,
    $tempDeployDir,
    '/E',
    '/NFL',
    '/NDL',
    '/NJH',
    '/NJS',
    '/NP',
    '/XD'
  ) + $excludeArgs

  & robocopy @robocopyArgs | Out-Host
  if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
  }

  Write-Host "Linking snapshot to Vercel project '$Project' in scope '$Scope'..."
  vercel link --yes --scope $Scope --project $Project --cwd $tempDeployDir | Out-Host

  Write-Host "Deploying snapshot to Vercel production for '$Scope/$Project'..."
  vercel --prod --yes --scope $Scope --cwd $tempDeployDir | Out-Host

  Write-Host 'Done. If this is your first deployment, use the stable alias URL shown by Vercel output.'
}
finally {
  Pop-Location
  if (Test-Path $tempDeployDir) {
    try {
      Remove-Item -Recurse -Force $tempDeployDir -ErrorAction Stop
    }
    catch {
      Write-Warning "Cleanup skipped for '$tempDeployDir' (temporary lock): $($_.Exception.Message)"
    }
  }
}
