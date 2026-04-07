param(
  [switch]$SkipBuild = $false
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Push-Location $repoRoot

try {
  if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host 'Vercel CLI not found. Installing globally...'
    npm install -g vercel | Out-Host
  }

  Write-Host 'Checking Vercel authentication...'
  vercel whoami | Out-Host

  if (-not $SkipBuild) {
    Write-Host 'Building Flutter web (release)...'
    flutter build web --release | Out-Host
  }

  $deployPath = Resolve-Path (Join-Path $repoRoot 'build\web')
  Write-Host "Deploying $deployPath to Vercel production..."
  vercel $deployPath --prod --yes | Out-Host

  Write-Host 'Done. If this is your first deployment, use the stable alias URL shown by Vercel output.'
}
finally {
  Pop-Location
}
