param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $Force) {
  $answer = Read-Host "This will stop containers and delete Docker volumes. Type RESET to continue"
  if ($answer -ne "RESET") {
    Write-Host "Reset cancelled"
    exit 0
  }
}

docker compose down -v
