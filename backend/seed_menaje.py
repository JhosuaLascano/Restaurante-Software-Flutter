import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

from eventos.models import CategoriaMenaje, Menaje

def seed():
    # 1. Categories
    cat_mobiliario, _ = CategoriaMenaje.objects.get_or_create(nombre='Mobiliario')
    cat_vajilla, _ = CategoriaMenaje.objects.get_or_create(nombre='Vajilla y Cristalería')
    cat_manteleria, _ = CategoriaMenaje.objects.get_or_create(nombre='Mantelería')
    cat_cubiertos, _ = CategoriaMenaje.objects.get_or_create(nombre='Cubiertos')

    # 2. Items
    items = [
        # Mobiliario
        ('Tablero', cat_mobiliario, 1.50, 50.00),
        ('Silla', cat_mobiliario, 0.50, 20.00),
        
        # Manteleria
        ('Mantel', cat_manteleria, 3.00, 30.00),
        ('Cubremantel', cat_manteleria, 1.25, 15.00),
        ('Servilleta', cat_manteleria, 0.25, 5.00),
        
        # Vajilla
        ('Plato Base', cat_vajilla, 0.50, 10.00),
        ('Plato Fuerte', cat_vajilla, 0.10, 5.00),
        ('Plato Postre', cat_vajilla, 0.10, 5.00),
        ('Plato Pan', cat_vajilla, 0.10, 4.00),
        ('Jarras', cat_vajilla, 0.30, 8.00),
        ('Vasos', cat_vajilla, 0.08, 3.00),
        ('Copa', cat_vajilla, 0.08, 4.00),
        
        # Cubiertos
        ('Cuchara Postre', cat_cubiertos, 0.09, 2.00),
        ('Tenedor Postre', cat_cubiertos, 0.09, 2.00),
        ('Tenedor Trinchero', cat_cubiertos, 0.09, 2.00),
        ('Cuchillo Trinchero', cat_cubiertos, 0.09, 2.00),
    ]

    for name, cat, rent, repo in items:
        # Usar update_or_create para manejar items existentes y nuevos, pasando los campos obligatorios en defaults
        Menaje.objects.update_or_create(
            nombre=name, 
            categoria=cat,
            defaults={
                'costo_alquiler': rent,
                'costo_reposicion': repo
            }
        )
        print(f"Processed {name}")

if __name__ == '__main__':
    seed()
