import 'package:flutter/material.dart';

class ReportesVentasScreen extends StatefulWidget {
  const ReportesVentasScreen({super.key});

  @override
  State<ReportesVentasScreen> createState() => _ReportesVentasScreenState();
}

class _ReportesVentasScreenState extends State<ReportesVentasScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  final List<Map<String, dynamic>> _facturas = [
    {
      'id': 1001,
      'fecha': '16 Sep 2026 - 13:45',
      'mesa': 'Mesa 4',
      'mesero': 'Carlos Pantoja',
      'cliente': 'Juan Pérez',
      'ruc': '1723456789001',
      'total': 48.50,
      'estado': 'Pagado',
    },
    {
      'id': 1002,
      'fecha': '16 Sep 2026 - 14:10',
      'mesa': 'Mesa 2',
      'mesero': 'María López',
      'cliente': 'Empresa ABC S.A.',
      'ruc': '0992345678001',
      'total': 112.00,
      'estado': 'Pagado',
    },
    {
      'id': 1003,
      'fecha': '15 Sep 2026 - 20:30',
      'mesa': 'Mesa 8',
      'mesero': 'Carlos Pantoja',
      'cliente': 'Consumidor Final',
      'ruc': '9999999999999',
      'total': 34.00,
      'estado': 'Pagado',
    },
  ];

  double get _totalIngresos => _facturas.fold(0.0, (sum, f) => sum + (f['total'] as double));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITULO Y FILTROS
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reportes de Ventas',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Visualiza el rendimiento financiero e historial de facturas',
                        style: TextStyle(color: Color(0xFFA3AED0), fontSize: 13),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generando archivo CSV/Excel de ventas...')),
                      );
                    },
                    icon: const Icon(Icons.download, size: 20),
                    label: const Text('Exportar Excel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(14)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setState(() => _fechaInicio = picked);
                      },
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(_fechaInicio == null ? 'Fecha Desde' : '${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(14)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setState(() => _fechaFin = picked);
                      },
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(_fechaFin == null ? 'Fecha Hasta' : '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2937),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt, size: 18),
                    label: const Text('Filtrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // TARJETAS KPIS DE VENTAS
        Row(
          children: [
            Expanded(
              child: _buildKpiBox('INGRESOS TOTALES', '\$${_totalIngresos.toStringAsFixed(2)}', Icons.attach_money, const Color(0xFF52222A), const Color(0xFFFFF0EC)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKpiBox('VENTAS REALIZADAS', '${_facturas.length}', Icons.receipt_long, const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKpiBox('TICKET PROMEDIO', '\$${(_totalIngresos / (_facturas.isEmpty ? 1 : _facturas.length)).toStringAsFixed(2)}', Icons.trending_up, const Color(0xFF10B981), const Color(0xFFECFDF5)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // TABLA DE FACTURAS
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
                  DataColumn(label: Text('# FACTURA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('FECHA EMISIÓN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('MESA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('MESERO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('CLIENTE / RUC', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                ],
                rows: _facturas.map((f) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${f['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674)))),
                      DataCell(Text(f['fecha'])),
                      DataCell(Text(f['mesa'])),
                      DataCell(Text(f['mesero'])),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(f['cliente'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674))),
                            Text(f['ruc'], style: const TextStyle(fontSize: 11, color: Color(0xFFA3AED0))),
                          ],
                        ),
                      ),
                      DataCell(Text('\$${(f['total'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674)))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            f['estado'],
                            style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
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

  Widget _buildKpiBox(String label, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFA3AED0))),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B3674))),
            ],
          ),
        ],
      ),
    );
  }
}
