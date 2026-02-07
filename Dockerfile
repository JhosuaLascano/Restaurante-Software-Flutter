
# Usar una imagen base oficial de Python (ligera y segura)
FROM python:3.11-slim

# Evitar que Python escriba archivos .pyc y asegurar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Directorio de trabajo en el contenedor
WORKDIR /app

# Instalar dependencias del sistema necesarias para PostgreSQL y otros paquetes
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar el archivo de requerimientos e instalar dependencias de Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código del proyecto
COPY . /app/

# Exponer el puerto donde correrá Gunicorn
EXPOSE 8000

# Comando por defecto para arrancar la aplicación (ajustar 'restaurante.wsgi' si tu proyecto se llama diferente)
CMD ["gunicorn", "restaurante.wsgi:application", "--bind", "0.0.0.0:8000"]
