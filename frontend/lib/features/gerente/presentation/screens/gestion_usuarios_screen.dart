import 'package:flutter/material.dart';

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  final List<Map<String, dynamic>> _usuarios = [
    {
      'id': 1,
      'username': 'Admin',
      'email': 'admin@gmail.com',
      'rol': 'admin',
      'rol_display': 'Administrador',
      'online': true,
      'cedula': '0401190822',
    },
    {
      'id': 2,
      'username': 'gerente1',
      'email': 'gerente@restaurante.com',
      'rol': 'gerente',
      'rol_display': 'Gerente',
      'online': true,
      'cedula': '1234567890',
    },
    {
      'id': 3,
      'username': 'carlos_mesero',
      'email': 'carlos@restaurante.com',
      'rol': 'mesero',
      'rol_display': 'Mesero',
      'online': false,
      'cedula': '0987654321',
    },
    {
      'id': 4,
      'username': 'juan_cocina',
      'email': 'cocina@restaurante.com',
      'rol': 'cocina',
      'rol_display': 'Cocinero',
      'online': true,
      'cedula': '0401987654',
    },
  ];

  void _mostrarDialogoNuevoUsuario() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final cedulaController = TextEditingController();
    String rolSeleccionado = 'mesero';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.person_add, color: Color(0xFF7C3AED)),
                  SizedBox(width: 10),
                  Text('Nuevo Usuario'),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(labelText: 'Nombre de Usuario', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: cedulaController,
                        decoration: const InputDecoration(labelText: 'Cédula / Identificación', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: rolSeleccionado,
                        decoration: const InputDecoration(labelText: 'Rol del Sistema', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                          DropdownMenuItem(value: 'gerente', child: Text('Gerente')),
                          DropdownMenuItem(value: 'mesero', child: Text('Mesero')),
                          DropdownMenuItem(value: 'cocina', child: Text('Cocinero')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => rolSeleccionado = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white),
                  onPressed: () {
                    if (usernameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                      final rolMap = {
                        'admin': 'Administrador',
                        'gerente': 'Gerente',
                        'mesero': 'Mesero',
                        'cocina': 'Cocinero',
                      };
                      setState(() {
                        _usuarios.add({
                          'id': _usuarios.length + 1,
                          'username': usernameController.text,
                          'email': emailController.text,
                          'rol': rolSeleccionado,
                          'rol_display': rolMap[rolSeleccionado] ?? rolSeleccionado,
                          'online': true,
                          'cedula': cedulaController.text,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Crear Usuario'),
                ),
              ],
            );
          },
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
                  'Gestión de Usuarios & Personal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                ),
                Text(
                  'Administra cuentas de acceso, roles y estados de sesión',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _mostrarDialogoNuevoUsuario,
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('+ Nuevo Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // TABLA DE USUARIOS
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
                  DataColumn(label: Text('USUARIO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('CÉDULA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ROL', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                  DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA3AED0)))),
                ],
                rows: _usuarios.map((u) {
                  final isOnline = u['online'] as bool;
                  final rol = u['rol'] as String;

                  Color rolBg = const Color(0xFFFFF3E0);
                  Color rolFg = const Color(0xFFEF6C00);

                  if (rol == 'admin') {
                    rolBg = const Color(0xFFFEE2E2);
                    rolFg = const Color(0xFFDC2626);
                  } else if (rol == 'gerente') {
                    rolBg = const Color(0xFFEFF6FF);
                    rolFg = const Color(0xFF2563EB);
                  }

                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: rolFg.withValues(alpha: 0.2),
                              child: Text(
                                (u['username'] as String)[0].toUpperCase(),
                                style: TextStyle(color: rolFg, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              u['username'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(u['email'])),
                      DataCell(Text(u['cedula'] ?? 'N/A')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: rolBg, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            u['rol_display'],
                            style: TextStyle(color: rolFg, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: isOnline ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: isOnline ? const Color(0xFF047857) : const Color(0xFF6B7280),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                                  _usuarios.removeWhere((item) => item['id'] == u['id']);
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
