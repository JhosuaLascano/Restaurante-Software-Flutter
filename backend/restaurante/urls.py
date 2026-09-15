"""
URL configuration for restaurante project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView

# Importar Vistas de JWT (Autenticación Móvil)
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

# Importar Vistas de Swagger (Documentación de la API)
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView,
)

urlpatterns = [
    path('', RedirectView.as_view(url='/api/v1/docs/')),
    path('admin/', admin.site.urls),
    
    # --------------------------------------------------
    # RUTAS DE LA API REST (Para Flutter)
    # --------------------------------------------------
    # Autenticación JWT (Login)
    path('api/v1/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/v1/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Documentación Swagger / OpenAPI
    path('api/v1/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/v1/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),

    # --------------------------------------------------
    # RUTAS WEB TRADICIONALES (Existentes)
    # --------------------------------------------------
    path('usuarios/', include('usuarios.urls')),
    path('pedidos/', include('pedidos.urls')), 
    path('clientes/', include('clientes.urls')),
    path('caja/', include('caja.urls')),
    path('eventos/', include('eventos.urls')),
    path('hostal/', include('hostal.urls')),
]

