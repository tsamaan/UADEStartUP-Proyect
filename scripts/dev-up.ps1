param(
  [switch]$WithBackend
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example"
}

if ($WithBackend) {
  docker compose --profile app up backend
} else {
  docker compose up -d postgres minio minio-init
}
