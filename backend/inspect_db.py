
import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

with connection.cursor() as cursor:
    cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'inventario_receta'")
    columns = [col[0] for col in cursor.fetchall()]
    print(f"COLUMNS IN inventario_receta: {columns}")
