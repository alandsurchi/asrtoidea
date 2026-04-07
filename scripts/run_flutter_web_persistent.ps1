param(
  [int]$Port = 7357
)

$ErrorActionPreference = 'Stop'

$owners = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty OwningProcess -Unique

if ($owners) {
  Write-Host "Port $Port is in use. Stopping process(es): $($owners -join ', ')"
  foreach ($ownerPid in $owners) {
    Stop-Process -Id $ownerPid -Force -ErrorAction SilentlyContinue
  }
}

$profilePath = Join-Path $env:USERPROFILE 'AppData\Local\ai_idea_generator_chrome_profile'

flutter run -d chrome --web-port $Port "--web-browser-flag=--user-data-dir=$profilePath"