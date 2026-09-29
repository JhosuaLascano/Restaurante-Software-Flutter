import 'package:flutter/material.dart';

class GestionMenuScreen extends StatefulWidget {
  const GestionMenuScreen({super.key});

  @override
  State<GestionMenuScreen> createState() => _GestionMenuScreenState();
}

class _GestionMenuScreenState extends State<GestionMenuScreen> {
  // Lista de prueba para demostración visual de la UI del Menú
  final List<Map<String, dynamic>> _productos = [
    {
      'id': 1,
      'nombre': 'Lomo Saltado Especial',
      'precio': 14.50,
      'costo': 5.20,
      'stock': 25,
      'disponible': true,
    },
    {
      'id': 2,
      'nombre': 'Ceviche Mixto Tradicional',
      'precio': 16.00,
      'costo': 6.80,
      'stock': 15,
      'disponible': true,
    },
    {
      'id': 3,
      'nombre': 'Seco de Cordero con Frijoles',
      'precio': 18.50,
      'costo': 7.50,
      'stock': 0,
      'disponible': false,
    },
    {
      'id': 4,
      'nombre': 'Arroz con Mariscos',
      'precio': 17.00,
      'costo': 6.00,
      'stock': 18,
      'disponible': true,
    },
  ];

  void _mostrarDialogoNuevoPlato() {
    final nombreController = TextEditingController();
    final precioController = TextEditingController();
    final costoController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Color(0xFF52222A)),
              SizedBox(width: 10),
              Text('Nuevo Plato'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre del Plato', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: precioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio Venta (\$)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: costoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Costo Real (\$)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock Inicial', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF52222A), foregroundColor: Colors.white),
              onPressed: () {
                if (nombreController.text.isNotEmpty && precioController.text.isNotEmpty) {
                  setState(() {
                    _productos.add({
                      'id': _productos.length + 1,
                      'nombre': nombreController.text,
                      'precio': double.tryParse(precioController.text) ?? 0.0,
                      'costo': double.tryParse(costoController.text) ?? 0.0,
                      'stock': int.tryParse(stockController.text) ?? 0,
                      'disponible': true,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar Plato'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER DE SECCIÓN
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión del Menú',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                ),
                Text(
                  'Catálogo de platos y costos de elaboración',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52222A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _mostrarDialogoNuevoPlato,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('+ Nuevo Plato', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // TABLA DE PRODUCTOS
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                columns: const [
                  DataColumn(label: Text('PRODUCTO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('PRECIO VENTA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('COSTO REAL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('STOCK', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                ],
                rows: _productos.map((p) {
                  final disponible = p['disponible'] as bool;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          p['nombre'],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                        ),
                      ),
                      DataCell(
                        Text(
                          '\$${(p['precio'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                        ),
                      ),
                      DataCell(
                        Text(
                          '\$${(p['costo'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ),
                      DataCell(Text('${p['stock']}')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: disponible ? const Color(0xFFECFDF5) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            disponible ? 'Disponible' : 'No Disponible',
                            style: TextStyle(
                              color: disponible ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFF52222A), size: 20),
                              onPressed: () {},
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.restaurant, color: Color(0xFF10B981), size: 20),
                              onPressed: () {},
                              tooltip: 'Receta',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20),
                              onPressed: () {
                                setState(() {
                                  _productos.removeWhere((item) => item['id'] == p['id']);
                                });
                              },
                              tooltip: 'Eliminar',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
