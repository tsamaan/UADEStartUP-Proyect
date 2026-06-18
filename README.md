# UADE StartUP

Repositorio de infraestructura y documentacion de **UADE StartUP**, una plataforma para mostrar proyectos de equipos expositores, permitir votacion publica en tiempo real y registrar evaluaciones de jurados por edicion.

Este repositorio no contiene el frontend ni el backend como codigo principal. Su objetivo es dejar documentado el producto, coordinar decisiones tecnicas y levantar un entorno local completo con Docker.

## Repositorios

La aplicacion esta pensada como tres repositorios separados:

- **Frontend:** aplicacion web en Next.js para invitados, jurados, expositores y administradores.
- **Backend:** API en Node.js con Express, Prisma y PostgreSQL.
- **Infra/documentacion:** este repositorio, usado para Docker local, documentacion y decisiones del proyecto.

Estructura recomendada:

```txt
proyectosTeo/
  UADEStartUP-Proyect/   # infra + docs
  UADEStartUP-Backend/   # backend Express
  UADEStartUP-Frontend/  # frontend Next.js
```

## Producto

UADE StartUP se organiza por **ediciones**. Por ejemplo, una edicion puede ser `Edicion 2026`, y a futuro se podran consultar ediciones anteriores como versiones historicas del evento.

Los usuarios publicos pueden entrar por QR y ver los proyectos sin iniciar sesion. Para votar, la decision actual es usar login institucional con cuenta UADE/Microsoft, de forma que se reduzca el riesgo de votos duplicados y se pueda limitar la participacion a correos del dominio UADE.

Roles principales:

- **Invitado:** ve proyectos y ranking publico. Para votar debe autenticarse con cuenta institucional.
- **Expositor:** pertenece a un equipo y carga la informacion del proyecto.
- **Jurado:** evalua todos los proyectos de una edicion con puntaje de 1 a 5.
- **Admin:** gestiona ediciones, usuarios, equipos, proyectos, publicaciones y resultados privados.

## Decisiones tecnicas

- **Frontend:** Next.js.
- **Backend:** Node.js + Express + TypeScript.
- **Base de datos:** PostgreSQL.
- **ORM:** Prisma.
- **Archivos:** MinIO compatible con S3, autohosteado.
- **Autenticacion prevista para votacion:** Microsoft OAuth / Entra ID, restringido a cuentas UADE o dominio institucional.
- **Tiempo real:** el ranking publico debe actualizarse en vivo durante la votacion.
- **Deploy productivo:** aplicaciones separadas en CapRover.
- **Entorno local:** Docker Compose desde este repo.

## Multimedia

Los equipos expositores deben poder cargar contenido visual del proyecto:

- Logo del proyecto.
- Imagenes de presentacion o capturas.
- Video del pitch, demo o presentacion.
- Links externos opcionales, como demo, repositorio o video publicado.

Para archivos subidos desde la app se usara MinIO. La API deberia exponer un flujo seguro de carga, idealmente con URLs prefirmadas, validacion de tipo de archivo, tamano maximo y asociacion del archivo al proyecto correspondiente.

## Entorno Local Con Docker

Este repo esta pensado para levantar el entorno local completo desde cualquier PC de desarrollo.

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
.\scripts\dev-up.ps1 -WithFrontend
.\scripts\dev-up.ps1 -WithApp
```

Cuando se usa `.\scripts\dev-up.ps1 -WithBackend`, el script verifica `BACKEND_PATH` en `.env`. Si el repo backend no existe en esa ruta, lo clona automaticamente desde `BACKEND_REPO_URL` antes de iniciar el servicio.

Lo mismo aplica para `.\scripts\dev-up.ps1 -WithFrontend`: verifica `FRONTEND_PATH` y, si falta, clona desde `FRONTEND_REPO_URL`. Para levantar backend y frontend juntos, usar `.\scripts\dev-up.ps1 -WithApp`.

Servicios locales:

- Frontend: http://localhost:3001
- Backend: http://localhost:3000
- Healthcheck: http://localhost:3000/health
- PostgreSQL: localhost:5432
- MinIO API: http://localhost:9000
- MinIO Console: http://localhost:9001

Para bajar el entorno:

```powershell
.\scripts\dev-down.ps1
```

Para resetear datos locales:

```powershell
.\scripts\dev-reset.ps1
```

## Documentacion

- [Entorno local Docker](docs/entorno-local-docker.html)
- [Primer documento tecnico](docs/primer-documento-tecnico.html)
- [Plan para aprobacion](docs/plan-para-aprobacion.html)
- [Modelo entidad-relacion](docs/modelo-entidad-relacion.html)
- [Contratos de API](docs/contratos-api.html)
- [TODO backend](docs/todo-backend.html)
- [TODO frontend](docs/todo-frontend.html)

## Estado Actual

El backend ya tiene base tecnica, PostgreSQL, Prisma, ediciones, autenticacion inicial por email/password para desarrollo, roles, equipos y flujo de proyectos hasta publicacion.

El frontend ya existe como repo separado en Next.js y puede levantarse desde este repo de infra con Docker Compose.

Proximos bloques importantes:

- Autenticacion institucional Microsoft/UADE para usuarios que votan.
- Carga de archivos en MinIO.
- Votacion publica con regla de un voto por usuario y proyecto/equipo.
- Ranking publico en tiempo real.
- Evaluacion de jurados y resultados privados para administradores.
