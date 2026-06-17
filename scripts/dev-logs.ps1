param(
  [string]$Service = ""
)

$ErrorActionPreference = "Stop"

if ($Service) {
  docker compose logs -f $Service
} else {
  docker compose logs -f
}
