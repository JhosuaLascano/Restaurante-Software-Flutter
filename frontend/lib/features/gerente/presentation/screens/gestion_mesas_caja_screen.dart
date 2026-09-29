import 'package:flutter/material.dart';

class GestionMesasCajaScreen extends StatefulWidget {
  const GestionMesasCajaScreen({super.key});

  @override
  State<GestionMesasCajaScreen> createState() => _GestionMesasCajaScreenState();
}

class _GestionMesasCajaScreenState extends State<GestionMesasCajaScreen> {
  int _tabIndex = 0;

  final List<Map<String, dynamic>> _mesas = [
    {'numero': 1, 'capacidad': 4, 'estado': 'disponible'},
    {'numero': 2, 'capacidad': 2, 'estado': 'ocupada', 'mesero': 'Carlos P.', 'total': 48.50},
    {'numero': 3, 'capacidad': 6, 'estado': 'disponible'},
    {'numero': 4, 'capacidad': 4, 'estado': 'ocupada', 'mesero': 'María L.', 'total': 112.00},
    {'numero': 5, 'capacidad': 2, 'estado': 'reservada'},
    {'numero': 6, 'capacidad': 8, 'estado': 'disponible'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CONTROLES DE PESTAÑAS (MESAS / CAJA)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión Operativa: Mesas & Caja',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                ),
                Text(
                  'Monitoreo en tiempo real de salones y control de flujo de caja',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, Icons.table_restaurant, 'Mesas Salón'),
                  _buildTabButton(1, Icons.point_of_sale, 'Control de Caja'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (_tabIndex == 0) _buildMesasGrid() else _buildCajaView(),
      ],
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = _tabIndex == index;
    return InkWell(
      onTap: () => setState(() => _tabIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF52222A) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- VISTA DE MESAS ---
  Widget _buildMesasGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mesas.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            final m = _mesas[index];
            final estado = m['estado'] as String;

            Color bg = const Color(0xFFECFDF5);
            Color border = const Color(0xFF10B981);
            String label = 'Disponible';

            if (estado == 'ocupada') {
              bg = const Color(0xFFFFF0EC);
              border = const Color(0xFF52222A);
              label = 'Ocupada';
            } else if (estado == 'reservada') {
              bg = const Color(0xFFEFF6FF);
              border = const Color(0xFF3B82F6);
              label = 'Reservada';
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mesa ${m['numero']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: border),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          label,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Text('Capacidad: ${m['capacidad']} Personas', style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
                  if (estado == 'ocupada') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mesero: ${m['mesero']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('\$${(m['total'] as double).toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: border)),
                      ],
                    ),
                  ] else ...[
                    const Text('Sin pedido activo', style: TextStyle(fontSize: 12, color: Color(0xFFA3AED0))),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- VISTA DE CAJA ---
  Widget _buildCajaView() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estado de Caja Principal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
              ),
              Chip(
                backgroundColor: Color(0xFFECFDF5),
                label: Text('CAJA ABIERTA', style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildCajaStat('Monto Apertura', '\$100.00', Icons.lock_open, const Color(0xFF6B7280))),
              Expanded(child: _buildCajaStat('Ingresos Efectivo', '\$194.50', Icons.money, const Color(0xFF10B981))),
              Expanded(child: _buildCajaStat('Ventas Tarjeta', '\$310.00', Icons.credit_card, const Color(0xFF3B82F6))),
              Expanded(child: _buildCajaStat('Total en Caja', '\$604.50', Icons.account_balance_wallet, const Color(0xFF52222A))),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: () {},
                icon: const Icon(Icons.print),
                label: const Text('Imprimir Arqueo'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: const Text('Cerrar Caja de Hoy', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCajaStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFA3AED0))),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
