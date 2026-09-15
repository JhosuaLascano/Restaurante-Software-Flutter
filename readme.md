# Restaurante Software - Monorepo (Django API + Flutter)

Este repositorio utiliza una arquitectura **Monorepo** que separa el Backend (Django REST API) del Frontend Móvil (Flutter), con un entorno completamente automatizado en **Docker**.

---

## 📁 Estructura del Proyecto

```text
Restaurante-Software/
├── backend/                  # API REST en Django + PostgreSQL
│   ├── app/                  # Aplicaciones del dominio (pedidos, caja, inventario, etc.)
│   ├── restaurante/          # Configuración principal de Django (settings, urls, wsgi)
│   ├── manage.py
│   ├── requirements.txt
│   ├── Dockerfile            # Construcción de imagen de Python 3.11
│   └── entrypoint.sh         # Script de arranque (espera BD + migraciones automáticas)
├── frontend/                 # Proyecto Móvil en Flutter (Clean Architecture)
│   ├── lib/
│   │   ├── core/             # Servicios API, temas y utilidades globales
│   │   ├── features/         # Módulos de la app (auth, pedidos, inventario, etc.)
│   │   └── main.dart
│   └── pubspec.yaml
├── docker-compose.yml        # Orquestación de la API y la Base de Datos PostgreSQL
└── README.md
```

---

## 🚀 Guía de Inicio Rápido (Para Desarrolladores)

### Prerrequisitos
- **Docker Desktop** instalado y activo.

### 1. Levantar el proyecto con un solo comando
Clona el repositorio e inicia los servicios:

```bash
docker compose up --build
```

Esto realizará de forma automática:
1. Contrucción del contenedor del backend en Python 3.11.
2. Inicialización del servidor **PostgreSQL 15** en el puerto `5432`.
3. Verificación de disponibilidad de la Base de Datos.
4. Ejecución automática de todas las migraciones pendientes (`python manage.py migrate`).
5. Inicio del servidor del Backend Django en `http://localhost:8000`.

---

## 🔗 Endpoints de la API REST

| Servicio | URL | Descripción |
| :--- | :--- | :--- |
| **API Docs (Swagger UI)** | `http://localhost:8000/api/v1/docs/` | Documentación interactiva OpenAPI |
| **JWT Token (Login)** | `POST http://localhost:8000/api/v1/token/` | Obtener Access & Refresh Token |
| **JWT Refresh Token** | `POST http://localhost:8000/api/v1/token/refresh/` | Renovar Access Token |
| **Panel de Admin** | `http://localhost:8000/admin/` | Panel administrativo de Django |

---

## 🔑 Crear Superusuario Administrador

Para acceder al panel de Django Admin o probar endpoints restringidos:

```bash
docker compose exec web python manage.py createsuperuser
```