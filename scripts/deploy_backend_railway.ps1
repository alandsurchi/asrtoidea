param(
    [string]$Service = "asrtoidea",
    [string]$Environment = "production"
)

$ErrorActionPreference = "Stop"

$backendDir = Join-Path $PSScriptRoot "..\backend"

Write-Host "Deploying backend from: $backendDir"
Write-Host "Service: $Service"
Write-Host "Environment: $Environment"

Push-Location $backendDir
try {
    railway up --service $Service --environment $Environment --ci
    if ($LASTEXITCODE -ne 0) {
        throw "Railway deploy failed with exit code $LASTEXITCODE"
    }

    railway service status
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to read Railway service status after deploy"
    }
}
finally {
    Pop-Location
}
