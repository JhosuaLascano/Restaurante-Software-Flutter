#!/bin/sh

# Salir inmediatamente si un comando falla
set -e

echo " Esperando a que PostgreSQL esté listo..."

# Esperar a que la base de datos responda en el puerto 5432
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 0.5
done

echo "Base de Datos PostgreSQL lista!"

echo " Ejecutando migraciones de la base de datos..."
python manage.py migrate --noinput

echo " Iniciando servidor de desarrollo Django en 0.0.0.0:8000..."
python manage.py runserver 0.0.0.0:8000
