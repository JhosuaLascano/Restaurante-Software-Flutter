
import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

def reset_eventos():
    with connection.cursor() as cursor:
        print("Connected. Checking tables...")
        cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE 'eventos_%';")
        existing = cursor.fetchall()
        print(f"Found tables: {existing}")

        print("Dropping tables with CASCADE...")
        tables = [
            'eventos_costoadicional',
            'eventos_detallemenu', 
            'eventos_evento'
        ]
        for table in tables:
            try:
                # CASCADE is needed for Postgres to remove dependents automatically
                cursor.execute(f"DROP TABLE IF EXISTS {table} CASCADE;")
                print(f"Dropped {table}")
            except Exception as e:
                print(f"Error dropping {table}: {e}")
        
        print("Cleaning migration history...")
        try:
            cursor.execute("DELETE FROM django_migrations WHERE app='eventos';")
            print("Deleted migration history for 'eventos'")
        except Exception as e:
            print(f"Error cleaning migrations: {e}")

if __name__ == '__main__':
    reset_eventos()
