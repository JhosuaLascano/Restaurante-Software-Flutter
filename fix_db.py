
import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

with connection.cursor() as cursor:
    print("Dropping column 'nombre' from 'inventario_receta'...")
    cursor.execute("ALTER TABLE inventario_receta DROP COLUMN IF EXISTS nombre")
    print("Done.")
