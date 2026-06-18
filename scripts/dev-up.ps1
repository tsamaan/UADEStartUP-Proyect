param(
  [switch]$WithBackend,
  [switch]$WithFrontend,
  [switch]$WithApp
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

function Ensure-Repo {
  param(
    [string]$Name,
    [string]$PathEnvName,
    [string]$DefaultPath,
    [string]$RepoUrlEnvName,
    [string]$DefaultRepoUrl
  )

  $repoPath = Get-EnvValue -Name $PathEnvName -DefaultValue $DefaultPath
  $repoUrl = Get-EnvValue -Name $RepoUrlEnvName -DefaultValue $DefaultRepoUrl
  $repoFullPath = (Join-Path (Get-Location) $repoPath)

  if (Test-Path $repoFullPath) {
    Write-Host "$Name repo found at $repoPath"
    return
  }

  $repoParent = Split-Path $repoFullPath -Parent
  if (-not (Test-Path $repoParent)) {
    New-Item -ItemType Directory -Path $repoParent | Out-Null
  }

  Write-Host "$Name repo not found at $repoPath"
  Write-Host "Cloning $repoUrl"
  git clone $repoUrl $repoFullPath
}

function Ensure-BackendRepo {
  Ensure-Repo `
    -Name "Backend" `
    -PathEnvName "BACKEND_PATH" `
    -DefaultPath "../UADEStartUP-Backend" `
    -RepoUrlEnvName "BACKEND_REPO_URL" `
    -DefaultRepoUrl "https://github.com/tomasbondUade/UADEStartUP-Backend.git"
}

function Ensure-FrontendRepo {
  Ensure-Repo `
    -Name "Frontend" `
    -PathEnvName "FRONTEND_PATH" `
    -DefaultPath "../UADEStartUP-Frontend" `
    -RepoUrlEnvName "FRONTEND_REPO_URL" `
    -DefaultRepoUrl "https://github.com/tsamaan/UADEStartUP-Frontend.git"
}

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example"
}

if ($WithApp) {
  Ensure-BackendRepo
  Ensure-FrontendRepo
  docker compose --profile app up backend frontend
} elseif ($WithBackend) {
  Ensure-BackendRepo
  docker compose --profile app up backend
} elseif ($WithFrontend) {
  Ensure-FrontendRepo
  docker compose --profile app up frontend
} else {
  docker compose up -d postgres minio minio-init
}
