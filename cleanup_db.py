
import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

columns_to_drop = [
    'es_subreceta',
    'unidad_rendimiento',
    'cantidad_rendimiento',
    'costo_total',
    'margen_error'
]

with connection.cursor() as cursor:
    for col in columns_to_drop:
        print(f"Dropping column '{col}' from 'inventario_receta'...")
        cursor.execute(f"ALTER TABLE inventario_receta DROP COLUMN IF EXISTS {col}")
    print("Done cleaning up table.")
