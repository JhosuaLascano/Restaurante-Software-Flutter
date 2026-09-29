import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PuntoDeVentaScreen extends StatefulWidget {
  const PuntoDeVentaScreen({super.key});

  @override
  State<PuntoDeVentaScreen> createState() => _PuntoDeVentaScreenState();
}

class _PuntoDeVentaScreenState extends State<PuntoDeVentaScreen> {
  String _categoriaSeleccionada = 'Todos';
  String _filtroBusqueda = '';
  String _tipoEntrega = 'Mesa';
  String? _mesaSeleccionada = 'Mesa 01';

  // Catálogo de platos, postres y cafés de Postor Cafetería
  final List<Map<String, dynamic>> _catalogoProductos = [
    {
      'id': 1,
      'nombre': 'Cappuccino Tradicional',
      'categoria': 'Cafetería',
      'precio': 4.50,
      'icono': Icons.coffee_rounded,
      'foto': 'https://images.unsplash.com/photo-1572442388796-11668ba67e53?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Espresso doble con cremosa espuma de leche y canela.',
    },
    {
      'id': 2,
      'nombre': 'Espresso Doble Especial',
      'categoria': 'Cafetería',
      'precio': 3.50,
      'icono': Icons.local_cafe_rounded,
      'foto': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Café de especialidad con notas achocolatadas.',
    },
    {
      'id': 3,
      'nombre': 'Latte Caramelo & Vainilla',
      'categoria': 'Cafetería',
      'precio': 5.00,
      'icono': Icons.coffee_maker_rounded,
      'foto': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Toque de caramelo artesanal y leche vaporizada.',
    },
    {
      'id': 4,
      'nombre': 'Torta Selva Negra',
      'categoria': 'Postres',
      'precio': 6.50,
      'icono': Icons.cake_rounded,
      'foto': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Bizcochuelo de chocolate belga con crema y cerezas.',
    },
    {
      'id': 5,
      'nombre': 'Cheesecake Frutos Rojos',
      'categoria': 'Postres',
      'precio': 6.00,
      'icono': Icons.bakery_dining_rounded,
      'foto': 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Clásica base crocante con mermelada casera de arándanos.',
    },
    {
      'id': 6,
      'nombre': 'Croissant Mantequilla & Jamón',
      'categoria': 'Desayunos',
      'precio': 5.50,
      'icono': Icons.breakfast_dining_rounded,
      'foto': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Hojaldre artesanal francés con jamón ahumado y queso.',
    },
    {
      'id': 7,
      'nombre': 'Sándwich de Chicharrón',
      'categoria': 'Desayunos',
      'precio': 7.50,
      'icono': Icons.lunch_dining_rounded,
      'foto': 'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Chicharrón crocante tradicional, camote frito y sarza criolla.',
    },
    {
      'id': 8,
      'nombre': 'Frappé Moka & Crema',
      'categoria': 'Bebidas Frías',
      'precio': 5.80,
      'icono': Icons.local_drink_rounded,
      'foto': 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=400&q=80',
      'descripcion': 'Café helado batido con chocolate y crema chantilly.',
    },
    {
      'id': 9,
      'nombre': 'Jugo de Naranja Natural',
      'categoria': 'Bebidas Frías',
      'precio': 3.80,
      'icono': Icons.emoji_food_beverage_rounded,
      'foto': 'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=400&q=80',
      'descripcion': '100% fruta recién exprimida sin conservantes.',
    },
  ];

  // Carrito / Ticket de venta actual
  final List<Map<String, dynamic>> _ticketActual = [];

  final List<String> _categorias = [
    'Todos',
    'Cafetería',
    'Postres',
    'Desayunos',
    'Bebidas Frías',
  ];

  void _agregarAlTicket(Map<String, dynamic> producto) {
    setState(() {
      final index = _ticketActual.indexWhere((item) => item['id'] == producto['id']);
      if (index >= 0) {
        _ticketActual[index]['cantidad']++;
      } else {
        _ticketActual.add({
          'id': producto['id'],
          'nombre': producto['nombre'],
          'precio': producto['precio'],
          'cantidad': 1,
        });
      }
    });
  }

  void _incrementarCantidad(int index) {
    setState(() {
      _ticketActual[index]['cantidad']++;
    });
  }

  void _decrementarCantidad(int index) {
    setState(() {
      if (_ticketActual[index]['cantidad'] > 1) {
        _ticketActual[index]['cantidad']--;
      } else {
        _ticketActual.removeAt(index);
      }
    });
  }

  void _eliminarDelTicket(int index) {
    setState(() {
      _ticketActual.removeAt(index);
    });
  }

  void _limpiarTicket() {
    setState(() {
      _ticketActual.clear();
    });
  }

  double get _subtotal {
    return _ticketActual.fold(0.0, (acc, item) => acc + (item['precio'] * item['cantidad']));
  }

  void _finalizarVenta() {
    if (_ticketActual.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega platos o cafés al ticket antes de cobrar'),
          backgroundColor: AppColors.statusOrangeText,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.statusGreenText),
            SizedBox(width: 10),
            Text('Confirmar Venta'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: $_tipoEntrega ${_tipoEntrega == 'Mesa' ? '($_mesaSeleccionada)' : ''}'),
            const SizedBox(height: 8),
            Text('Items: ${_ticketActual.length} platos/bebidas'),
            const SizedBox(height: 8),
            Text(
              'Total a Cobrar: \$${_subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBurgundy),
            ),
          ],
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
              Navigator.pop(context);
              setState(() {
                _ticketActual.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Venta realizada con éxito! Comprobante emitido.'),
                  backgroundColor: AppColors.statusGreenText,
                ),
              );
            },
            child: const Text('Confirmar y Cobrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar productos
    final productosFiltrados = _catalogoProductos.where((p) {
      final coincideCategoria = _categoriaSeleccionada == 'Todos' || p['categoria'] == _categoriaSeleccionada;
      final coincideBusqueda = p['nombre'].toString().toLowerCase().contains(_filtroBusqueda.toLowerCase());
      return coincideCategoria && coincideBusqueda;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 920;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PANEL IZQUIERDO: CATÁLOGO DE PLATOS Y CAFÉS
            Expanded(
              flex: isDesktop ? 6 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CABECERA DEL CATÁLOGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Punto de Venta - Cafetería',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Selecciona platos, postres y bebidas para registrar una orden',
                            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      // BUSCADOR RÁPIDO
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _filtroBusqueda = val),
                          decoration: const InputDecoration(
                            hintText: 'Buscar plato o café...',
                            hintStyle: TextStyle(fontSize: 12, color: AppColors.textSubtle),
                            prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textSubtle),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // FILTRO DE CATEGORÍAS (PILLS)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categorias.map((cat) {
                        final isSel = _categoriaSeleccionada == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => setState(() => _categoriaSeleccionada = cat),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryBurgundy : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSel ? AppColors.primaryBurgundy : AppColors.borderLight,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                  color: isSel ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // GRILLA DE PLATOS Y BEBIDAS
                  _buildProductsGrid(productosFiltrados),
                ],
              ),
            ),

            if (isDesktop) const SizedBox(width: 24),

            // PANEL DERECHO: TICKET DE VENTA (EN ESCRITORIO O INFERIOR)
            if (isDesktop)
              SizedBox(
                width: 360,
                child: _buildTicketPanel(),
              ),
          ],
        );
      },
    );
  }

  // --- GRILLA DE PRODUCTOS DE LA CAFETERÍA ---
  Widget _buildProductsGrid(List<Map<String, dynamic>> productos) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 480 ? 2 : 1);

        if (productos.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            child: const Text('No se encontraron platos en esta categoría', style: TextStyle(color: AppColors.textSubtle)),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final p = productos[index];
            return _buildProductCard(p);
          },
        );
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen fotográfica del plato/café con badge de categoría
          Stack(
            children: [
              SizedBox(
                height: 110,
                width: double.infinity,
                child: Image.network(
                  p['foto'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.goldLight,
                    child: Icon(p['icono'] as IconData, size: 40, color: AppColors.goldDark),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    p['categoria'],
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // Información del producto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['nombre'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        p['descripcion'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),

                  // Precio y Botón Agregar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(p['precio'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBurgundy,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBurgundy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _agregarAlTicket(p),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14),
                            SizedBox(width: 4),
                            Text('Agregar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PANEL LATERAL DEL TICKET / PEDIDO ACTUAL ---
  Widget _buildTicketPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
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
          // Encabezado Ticket
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_outlined, color: AppColors.primaryBurgundy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Ticket de Venta',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                ],
              ),
              if (_ticketActual.isNotEmpty)
                InkWell(
                  onTap: _limpiarTicket,
                  child: const Text('Limpiar', style: TextStyle(fontSize: 12, color: AppColors.logoutText, fontWeight: FontWeight.bold)),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // TIPO DE SERVICIO (Mesa o Para Llevar)
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('En Mesa', style: TextStyle(fontSize: 12))),
                  selected: _tipoEntrega == 'Mesa',
                  selectedColor: AppColors.primaryBurgundy,
                  labelStyle: TextStyle(color: _tipoEntrega == 'Mesa' ? Colors.white : AppColors.textDark),
                  onSelected: (val) => setState(() => _tipoEntrega = 'Mesa'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Para Llevar', style: TextStyle(fontSize: 12))),
                  selected: _tipoEntrega == 'Para llevar',
                  selectedColor: AppColors.primaryBurgundy,
                  labelStyle: TextStyle(color: _tipoEntrega == 'Para llevar' ? Colors.white : AppColors.textDark),
                  onSelected: (val) => setState(() => _tipoEntrega = 'Para llevar'),
                ),
              ),
            ],
          ),

          if (_tipoEntrega == 'Mesa') ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _mesaSeleccionada,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                labelText: 'Mesa asignada',
              ),
              items: ['Mesa 01', 'Mesa 02', 'Mesa 03', 'Mesa 04', 'Mesa 05', 'Barra 01']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13))))
                  .toList(),
              onChanged: (val) => setState(() => _mesaSeleccionada = val),
            ),
          ],

          const Divider(height: 24),

          // ITEMS AGREGADOS AL TICKET
          if (_ticketActual.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 40, color: AppColors.textSubtle),
                  SizedBox(height: 8),
                  Text('No hay platos agregados', style: TextStyle(color: AppColors.textSubtle, fontSize: 13)),
                  Text('Selecciona del menú a la izquierda', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ticketActual.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final item = _ticketActual[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['nombre'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('\$${(item['precio'] as double).toStringAsFixed(2)} c/u', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    // Controles + / -
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.textMuted),
                          onPressed: () => _decrementarCantidad(index),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text('${item['cantidad']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primaryBurgundy),
                          onPressed: () => _incrementarCantidad(index),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${((item['precio'] as double) * (item['cantidad'] as int)).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                      onPressed: () => _eliminarDelTicket(index),
                    ),
                  ],
                );
              },
            ),

          const Divider(height: 24),

          // RESUMEN FINANCIERO Y BOTÓN COBRAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total a Pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text(
                '\$${_subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryBurgundy),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurgundy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
              ),
              icon: const Icon(Icons.payment_rounded, size: 20),
              label: const Text('Cobrar y Emitir Ticket', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: _finalizarVenta,
            ),
          ),
        ],
      ),
    );
  }
}
