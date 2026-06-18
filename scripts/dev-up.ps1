param(
  [switch]$WithBackend
)

$ErrorActionPreference = "Stop"

function Get-EnvValue {
  param(
    [string]$Name,
    [string]$DefaultValue
  )

  if (-not (Test-Path ".env")) {
    return $DefaultValue
  }

  $line = Get-Content ".env" | Where-Object { $_ -match "^\s*$Name\s*=" } | Select-Object -First 1
  if (-not $line) {
    return $DefaultValue
  }

  return ($line -replace "^\s*$Name\s*=\s*", "").Trim('"').Trim("'")
}

function Ensure-BackendRepo {
  $backendPath = Get-EnvValue -Name "BACKEND_PATH" -DefaultValue "../UADEStartUP-Backend"
  $backendRepoUrl = Get-EnvValue -Name "BACKEND_REPO_URL" -DefaultValue "https://github.com/tomasbondUade/UADEStartUP-Backend.git"
  $backendFullPath = (Join-Path (Get-Location) $backendPath)

  if (Test-Path $backendFullPath) {
    Write-Host "Backend repo found at $backendPath"
    return
  }

  $backendParent = Split-Path $backendFullPath -Parent
  if (-not (Test-Path $backendParent)) {
    New-Item -ItemType Directory -Path $backendParent | Out-Null
  }

  Write-Host "Backend repo not found at $backendPath"
  Write-Host "Cloning $backendRepoUrl"
  git clone $backendRepoUrl $backendFullPath
}

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example"
}

if ($WithBackend) {
  Ensure-BackendRepo
  docker compose --profile app up backend
} else {
  docker compose up -d postgres minio minio-init
}
