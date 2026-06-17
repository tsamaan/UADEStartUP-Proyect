# UADE StartUP

Repositorio de infraestructura y documentacion de UADE StartUP.

La aplicacion se va a dividir en repositorios separados:

- Frontend: interfaz web en Next.js para invitados, jurados, expositores y administradores.
- Backend: API en Node.js con Express, autenticacion, reglas de negocio y persistencia.
- Infra/documentacion: este repositorio, usado para levantar ambientes, coordinar decisiones tecnicas y guardar documentacion del producto.

## Entorno local con Docker

Este repo esta pensado para levantar el entorno local completo desde una PC de desarrollo.

Estructura recomendada de carpetas:

```txt
proyectosTeo/
  UADEStartUP-Proyect/   # infra + docs
  UADEStartUP-Backend/   # backend Express
```

Primer uso:

```powershell
Copy-Item .env.example .env
docker compose up -d postgres minio minio-init
docker compose --profile app up backend
```

Atajo equivalente con scripts:

```powershell
.\scripts\dev-up.ps1
.\scripts\dev-up.ps1 -WithBackend
```

Servicios locales:

- Backend: http://localhost:3000
- Healthcheck: http://localhost:3000/health
- PostgreSQL: localhost:5432
- MinIO API: http://localhost:9000
- MinIO Console: http://localhost:9001

Mas detalle:

- [Entorno local Docker](docs/entorno-local-docker.html)

Documento inicial:

- [Primer documento tecnico](docs/primer-documento-tecnico.html)
- [Plan para aprobacion](docs/plan-para-aprobacion.html)
- [Modelo entidad-relacion](docs/modelo-entidad-relacion.html)
- [Contratos de API](docs/contratos-api.html)
- [TODO backend](docs/todo-backend.html)
- [TODO frontend](docs/todo-frontend.html)
