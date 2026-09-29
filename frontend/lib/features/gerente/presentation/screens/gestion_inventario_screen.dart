import 'package:flutter/material.dart';

class GestionInventarioScreen extends StatefulWidget {
  const GestionInventarioScreen({super.key});

  @override
  State<GestionInventarioScreen> createState() => _GestionInventarioScreenState();
}

class _GestionInventarioScreenState extends State<GestionInventarioScreen> {
  final List<Map<String, dynamic>> _insumos = [
    {
      'id': 1,
      'nombre': 'Carne de Res Lomo',
      'unidad': 'Kg',
      'tipo': 'Insumo',
      'costo': 8.50,
      'stock': 45.0,
      'stock_min': 10.0,
    },
    {
      'id': 2,
      'nombre': 'Cebolla Roja',
      'unidad': 'Kg',
      'tipo': 'Insumo',
      'costo': 1.20,
      'stock': 4.0, // Bajo stock
      'stock_min': 10.0,
    },
    {
      'id': 3,
      'nombre': 'Salsa Madre de Mariscos',
      'unidad': 'Litro',
      'tipo': 'Batch/Receta',
      'costo': 4.50,
      'stock': 12.0,
      'stock_min': 5.0,
    },
    {
      'id': 4,
      'nombre': 'Arroz Superior',
      'unidad': 'Kg',
      'tipo': 'Insumo',
      'costo': 0.90,
      'stock': 100.0,
      'stock_min': 20.0,
    },
  ];

  double get _valorTotalInventario {
    return _insumos.fold(0.0, (sum, i) => sum + ((i['costo'] as double) * (i['stock'] as double)));
  }

  void _mostrarDialogoNuevoInsumo() {
    final nombreController = TextEditingController();
    final unidadController = TextEditingController();
    final costoController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.inventory, color: Color(0xFF059669)),
              SizedBox(width: 10),
              Text('Nuevo Insumo'),
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
                    decoration: const InputDecoration(labelText: 'Nombre del Insumo', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: unidadController,
                    decoration: const InputDecoration(labelText: 'Unidad de Medida (Kg, Litro, Unid)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: costoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Costo Unitario (\$)', border: OutlineInputBorder()),
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
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
              onPressed: () {
                if (nombreController.text.isNotEmpty && costoController.text.isNotEmpty) {
                  setState(() {
                    _insumos.add({
                      'id': _insumos.length + 1,
                      'nombre': nombreController.text,
                      'unidad': unidadController.text.isEmpty ? 'Unid' : unidadController.text,
                      'tipo': 'Insumo',
                      'costo': double.tryParse(costoController.text) ?? 0.0,
                      'stock': double.tryParse(stockController.text) ?? 0.0,
                      'stock_min': 5.0,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar Insumo'),
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
        // HEADER DE SECCIÓN CON BOTONES DE ACCIÓN
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Control de Insumos & Stock',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                ),
                Text(
                  'Gestión de inventario y valuación de almacén',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _mostrarDialogoNuevoInsumo,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('+ Nuevo Insumo', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF059669),
                    side: const BorderSide(color: Color(0xFF059669)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.swap_horiz, size: 20),
                  label: const Text('Movimientos'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // TARJETA DE VALOR TOTAL
        Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monetization_on, color: Color(0xFF00897B), size: 26),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VALOR TOTAL INVENTARIO',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_valorTotalInventario.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // TABLA DE INSUMOS
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
                  DataColumn(label: Text('INSUMO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('UNIDAD', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('TIPO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('COSTO UNIT.', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('STOCK ACTUAL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('VALOR TOTAL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                ],
                rows: _insumos.map((i) {
                  final stock = i['stock'] as double;
                  final stockMin = i['stock_min'] as double;
                  final esBajoStock = stock <= stockMin;
                  final valorTotalItem = stock * (i['costo'] as double);

                  return DataRow(
                    cells: [
                      DataCell(Text(i['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674)))),
                      DataCell(Text(i['unidad'])),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: i['tipo'] == 'Batch/Receta' ? const Color(0xFFEEF2FF) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            i['tipo'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: i['tipo'] == 'Batch/Receta' ? const Color(0xFF4338CA) : const Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text('\$${(i['costo'] as double).toStringAsFixed(2)}')),
                      DataCell(
                        Text(
                          '${stock.toStringAsFixed(0)} ${i['unidad']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: esBajoStock ? const Color(0xFFDC2626) : const Color(0xFF2B3674),
                          ),
                        ),
                      ),
                      DataCell(Text('\$${valorTotalItem.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: esBajoStock ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            esBajoStock ? '⚠️ BAJO STOCK' : 'OK',
                            style: TextStyle(
                              color: esBajoStock ? const Color(0xFFDC2626) : const Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
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
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20),
                              onPressed: () {
                                setState(() {
                                  _insumos.removeWhere((item) => item['id'] == i['id']);
                                });
                              },
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
