import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GestionMesasScreen extends StatefulWidget {
  const GestionMesasScreen({super.key});

  @override
  State<GestionMesasScreen> createState() => _GestionMesasScreenState();
}

class _GestionMesasScreenState extends State<GestionMesasScreen> {
  String _filtroSalon = 'Todos';

  // Lista dinámica de mesas gestionadas por el gerente
  final List<Map<String, dynamic>> _mesas = [
    {'id': 1, 'numero': 'Mesa 01', 'salon': 'Salón Principal', 'capacidad': 4, 'estado': 'disponible'},
    {'id': 2, 'numero': 'Mesa 02', 'salon': 'Salón Principal', 'capacidad': 2, 'estado': 'ocupada', 'comensales': 2, 'mozo': 'Carlos R.'},
    {'id': 3, 'numero': 'Mesa 03', 'salon': 'Salón Principal', 'capacidad': 6, 'estado': 'disponible'},
    {'id': 4, 'numero': 'Mesa 04', 'salon': 'Terraza', 'capacidad': 4, 'estado': 'ocupada', 'comensales': 3, 'mozo': 'Lucía M.'},
    {'id': 5, 'numero': 'Mesa 05', 'salon': 'Terraza', 'capacidad': 2, 'estado': 'reservada', 'cliente': 'Familia Pérez'},
    {'id': 6, 'numero': 'Mesa 06', 'salon': 'Terraza', 'capacidad': 8, 'estado': 'disponible'},
    {'id': 7, 'numero': 'Barra 01', 'salon': 'Barra Cafetería', 'capacidad': 1, 'estado': 'disponible'},
    {'id': 8, 'numero': 'Barra 02', 'salon': 'Barra Cafetería', 'capacidad': 1, 'estado': 'ocupada', 'comensales': 1, 'mozo': 'Carlos R.'},
  ];

  final List<String> _salones = ['Todos', 'Salón Principal', 'Terraza', 'Barra Cafetería'];

  void _mostrarDialogoCrearMesa({Map<String, dynamic>? mesaExistente}) {
    final numeroController = TextEditingController(text: mesaExistente != null ? mesaExistente['numero'] : '');
    final capacidadController = TextEditingController(text: mesaExistente != null ? mesaExistente['capacidad'].toString() : '4');
    String salonSeleccionado = mesaExistente != null ? mesaExistente['salon'] : 'Salón Principal';
    String estadoInicial = mesaExistente != null ? mesaExistente['estado'] : 'disponible';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.table_restaurant_rounded, color: AppColors.primaryBurgundy),
              const SizedBox(width: 10),
              Text(mesaExistente == null ? 'Configurar Nueva Mesa' : 'Editar Mesa'),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: numeroController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre / Número de Mesa',
                      hintText: 'Ej. Mesa 07 o Barra 03',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: salonSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Salón / Ubicación',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Salón Principal', 'Terraza', 'Barra Cafetería', 'Zona VIP']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setDialogState(() => salonSeleccionado = val!),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: capacidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad de Personas',
                      hintText: 'Ej. 4',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: estadoInicial,
                    decoration: const InputDecoration(
                      labelText: 'Estado Inicial',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'disponible', child: Text('Disponible')),
                      DropdownMenuItem(value: 'ocupada', child: Text('Ocupada')),
                      DropdownMenuItem(value: 'reservada', child: Text('Reservada')),
                      DropdownMenuItem(value: 'mantenimiento', child: Text('En Mantenimiento')),
                    ],
                    onChanged: (val) => setDialogState(() => estadoInicial = val!),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurgundy,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (numeroController.text.trim().isNotEmpty) {
                  setState(() {
                    if (mesaExistente == null) {
                      _mesas.add({
                        'id': DateTime.now().millisecondsSinceEpoch,
                        'numero': numeroController.text.trim(),
                        'salon': salonSeleccionado,
                        'capacidad': int.tryParse(capacidadController.text) ?? 4,
                        'estado': estadoInicial,
                      });
                    } else {
                      mesaExistente['numero'] = numeroController.text.trim();
                      mesaExistente['salon'] = salonSeleccionado;
                      mesaExistente['capacidad'] = int.tryParse(capacidadController.text) ?? 4;
                      mesaExistente['estado'] = estadoInicial;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(mesaExistente == null ? 'Mesa creada correctamente' : 'Mesa actualizada'),
                      backgroundColor: AppColors.statusGreenText,
                    ),
                  );
                }
              },
              child: Text(mesaExistente == null ? 'Crear Mesa' : 'Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarMesa(int index) {
    setState(() {
      _mesas.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesa eliminada'), backgroundColor: AppColors.logoutText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mesasFiltradas = _mesas.where((m) {
      if (_filtroSalon == 'Todos') return true;
      return m['salon'] == _filtroSalon;
    }).toList();

    final totalMesas = _mesas.length;
    final disponibles = _mesas.where((m) => m['estado'] == 'disponible').length;
    final ocupadas = _mesas.where((m) => m['estado'] == 'ocupada').length;
    final reservadas = _mesas.where((m) => m['estado'] == 'reservada').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CABECERA Y BOTÓN AGREGAR MESA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestión de Mesas y Salones',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  'Configura los salones, crea nuevas mesas y monitorea su disponibilidad',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurgundy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Agregar Mesa', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _mostrarDialogoCrearMesa(),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // METRICAS RÁPIDAS DE ESTADO DE MESAS
        Row(
          children: [
            Expanded(child: _buildMesaStatCard('Total Mesas', '$totalMesas', Icons.table_restaurant, const Color(0xFF6B7280), const Color(0xFFF3F4F6))),
            const SizedBox(width: 14),
            Expanded(child: _buildMesaStatCard('Disponibles', '$disponibles', Icons.check_circle_outline, AppColors.statusGreenText, AppColors.statusGreenBg)),
            const SizedBox(width: 14),
            Expanded(child: _buildMesaStatCard('Ocupadas', '$ocupadas', Icons.people_alt_outlined, AppColors.primaryBurgundy, const Color(0xFFFEECEC))),
            const SizedBox(width: 14),
            Expanded(child: _buildMesaStatCard('Reservadas', '$reservadas', Icons.event_seat_outlined, AppColors.statusOrangeText, AppColors.statusOrangeBg)),
          ],
        ),

        const SizedBox(height: 22),

        // FILTROS POR SALÓN
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _salones.map((salon) {
              final isSel = _filtroSalon == salon;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(salon, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.w500)),
                  selected: isSel,
                  selectedColor: AppColors.primaryBurgundy,
                  labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textDark),
                  onSelected: (val) => setState(() => _filtroSalon = salon),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // GRILLA DE MESAS
        LayoutBuilder(
          builder: (context, constraints) {
            final crossCount = constraints.maxWidth > 950 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mesasFiltradas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (context, index) {
                final mesa = mesasFiltradas[index];
                return _buildMesaCard(mesa, index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMesaStatCard(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMesaCard(Map<String, dynamic> mesa, int index) {
    final estado = mesa['estado'] as String;

    Color badgeBg;
    Color badgeColor;
    String estadoTexto;

    if (estado == 'ocupada') {
      badgeBg = const Color(0xFFFDECEC);
      badgeColor = AppColors.primaryBurgundy;
      estadoTexto = 'Ocupada';
    } else if (estado == 'reservada') {
      badgeBg = AppColors.statusOrangeBg;
      badgeColor = AppColors.statusOrangeText;
      estadoTexto = 'Reservada';
    } else if (estado == 'mantenimiento') {
      badgeBg = const Color(0xFFF3F4F6);
      badgeColor = Colors.grey;
      estadoTexto = 'Mantenimiento';
    } else {
      badgeBg = AppColors.statusGreenBg;
      badgeColor = AppColors.statusGreenText;
      estadoTexto = 'Disponible';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header de la Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mesa['numero'],
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  estadoTexto,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
                ),
              ),
            ],
          ),

          // Detalles de salón y capacidad
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSubtle),
                  const SizedBox(width: 4),
                  Text(mesa['salon'], style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 14, color: AppColors.textSubtle),
                  const SizedBox(width: 4),
                  Text('Capacidad: ${mesa['capacidad']} personas', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),

          // Botones de acción rápida: Editar / Cambiar Estado / Eliminar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cambiar estado rápido
              PopupMenuButton<String>(
                tooltip: 'Cambiar estado',
                onSelected: (val) {
                  setState(() {
                    mesa['estado'] = val;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Row(
                    children: [
                      Text('Estado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textDark),
                    ],
                  ),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'disponible', child: Text('Marcar Disponible')),
                  PopupMenuItem(value: 'ocupada', child: Text('Marcar Ocupada')),
                  PopupMenuItem(value: 'reservada', child: Text('Marcar Reservada')),
                  PopupMenuItem(value: 'mantenimiento', child: Text('En Mantenimiento')),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryBurgundy),
                    onPressed: () => _mostrarDialogoCrearMesa(mesaExistente: mesa),
                    tooltip: 'Editar mesa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.logoutText),
                    onPressed: () => _eliminarMesa(index),
                    tooltip: 'Eliminar mesa',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
