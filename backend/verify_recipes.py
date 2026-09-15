import os
import django
import sys

# Setup Django Environment
sys.path.append('c:\\ProyectoIngenieriaSoftware\\Restaurante-Software')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurante.settings')
django.setup()

from pedidos.models import Producto
from inventario.models import Insumo, Receta

from decimal import Decimal

def verify_americano():
    print("--- Verificando Receta: Americano ---")
    
    # 1. Crear Insumos (Datos del Excel)
    print("Creando insumos...")
    cafe, _ = Insumo.objects.get_or_create(nombre="Café Grano Test", defaults={'unidad_medida': 'gr', 'costo_unitario': 0.210})
    cafe.costo_unitario = 0.210
    cafe.save()
    
    agua, _ = Insumo.objects.get_or_create(nombre="Agua Test", defaults={'unidad_medida': 'lt', 'costo_unitario': 0.50})
    agua.costo_unitario = 0.50
    agua.save()
    
    azucar, _ = Insumo.objects.get_or_create(nombre="Azucar Test", defaults={'unidad_medida': 'gr', 'costo_unitario': 0.012})
    azucar.costo_unitario = 0.012
    azucar.save()

    # 2. Crear Producto
    print("Creando producto...")
    americano, _ = Producto.objects.get_or_create(nombre="Americano Test", defaults={'precio': 1.00})
    
    # 3. Crear Receta
    print("Asignando ingredientes...")
    # Limpiar receta anterior si existe
    Receta.objects.filter(producto=americano).delete()
    
    # Café: 0.8 unidades (Asumimos Excel dice 0,8 gr)
    Receta.objects.create(producto=americano, insumo=cafe, cantidad_necesaria=0.8)
    
    # Agua: 0.25 unidades (Asumimos Excel dice 0,25 lt)
    Receta.objects.create(producto=americano, insumo=agua, cantidad_necesaria=0.25)
    
    # Azucar: 10 unidades (Asumimos Excel dice 10 gr)
    Receta.objects.create(producto=americano, insumo=azucar, cantidad_necesaria=10)
    
    # 4. Calcular Costo
    costo_total = Decimal(0)
    print("\n--- Detalle de Costos ---")
    for item in Receta.objects.filter(producto=americano):
        costo_item = item.cantidad_necesaria * item.insumo.costo_unitario
        costo_total += costo_item
        print(f"Insumo: {item.insumo.nombre} | Cant: {item.cantidad_necesaria} | Costo U: {item.insumo.costo_unitario} | Total: ${costo_item:.4f}")
    
    print("-------------------------")
    print(f"Costo Total Calculado: ${costo_total:.4f}")
    
    # 5. Comparar con Excel
    excel_cost = Decimal('0.4130')
    diff = abs(costo_total - excel_cost)
    
    if diff < Decimal('0.001'):
        print(f"✅ ÉXITO: El costo coincide con el Excel (${excel_cost})")
    else:
        print(f"❌ FALLO: Diferencia con Excel. Esperado: {excel_cost}, Obtenido: {costo_total}")

def verify_subrecipe():
    print("\n--- Verificando Sub-receta (Salsa) ---")
    
    # 1. Crear Insumos Básicos
    mostaza, _ = Insumo.objects.get_or_create(nombre="Mostaza", defaults={'unidad_medida': 'gr', 'costo_unitario': 0.05})
    mayonesa, _ = Insumo.objects.get_or_create(nombre="Mayonesa", defaults={'unidad_medida': 'gr', 'costo_unitario': 0.04})

    # 2. Crear Insumo "Producido" (La Salsa)
    salsa_amarilla, _ = Insumo.objects.get_or_create(
        nombre="Salsa Amarilla", 
        defaults={
            'unidad_medida': 'gr', 
            'costo_unitario': 0, # Se debería calcular
            'es_subreceta': True
        }
    )
    
    # 3. Crear Receta para la Salsa (Link Insumo -> Insumo)
    Receta.objects.filter(insumo_principal=salsa_amarilla).delete()
    
    Receta.objects.create(insumo_principal=salsa_amarilla, insumo=mostaza, cantidad_necesaria=50) # 50g
    Receta.objects.create(insumo_principal=salsa_amarilla, insumo=mayonesa, cantidad_necesaria=50) # 50g
    
    # 4. Verificar que podemos acceder a la receta desde el Insumo
    print(f"Insumo Producido: {salsa_amarilla.nombre}")
    ingredientes = salsa_amarilla.ingredientes_de_receta.all()
    
    costo_salsa = Decimal(0)
    for ing in ingredientes:
        costo = ing.cantidad_necesaria * ing.insumo.costo_unitario
        costo_salsa += costo
        print(f" - Componente: {ing.insumo.nombre} | Cant: {ing.cantidad_necesaria} | Costo: {costo}")
        
    print(f"Costo Total Batch Salsa (100g): {costo_salsa}")
    
    if ingredientes.count() == 2:
        print("✅ ÉXITO: Sub-receta creada y vinculada correctamente.")
    else:
        print("❌ FALLO: No se encontraron los ingredientes de la sub-receta.")

if __name__ == "__main__":
    verify_americano()
    verify_subrecipe()
