import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/domain/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/postor_logo_widget.dart';
import 'screens/punto_de_venta_screen.dart';
import 'screens/gestion_mesas_screen.dart';
import 'screens/gestion_menu_screen.dart';
import 'screens/gestion_inventario_screen.dart';
import 'screens/reportes_ventas_screen.dart';
import 'screens/gestion_usuarios_screen.dart';
import 'screens/gestion_mesas_caja_screen.dart';

class GerenteDashboardScreen extends StatefulWidget {
  const GerenteDashboardScreen({super.key});

  @override
  State<GerenteDashboardScreen> createState() => _GerenteDashboardScreenState();
}

class _GerenteDashboardScreenState extends State<GerenteDashboardScreen> {
  // 0: Inicio, 1: Punto de Venta (Platos Cafetería), 2: Mesas (Configuración del Gerente),
  // 3: Órdenes, 4: Menú (Platos y Precios), 5: Promociones,
  // 6: Inventario, 7: Reportes Ventas, 8: Personal & Roles, 9: Caja
  int _selectedIndex = 0;

  // Lista de órdenes para la tabla del dashboard
  final List<Map<String, dynamic>> _ordenesRecientes = [
    {
      'id': '#0128',
      'tipo': 'Mesa 04',
      'esMesa': true,
      'estado': 'En preparación',
      'estadoTipo': 'preparacion',
      'total': '\$18,50',
    },
    {
      'id': '#0127',
      'tipo': 'Para llevar',
      'esMesa': false,
      'estado': 'Pendiente',
      'estadoTipo': 'pendiente',
      'total': '\$12,00',
    },
    {
      'id': '#0126',
      'tipo': 'Mesa 02',
      'esMesa': true,
      'estado': 'Completado',
      'estadoTipo': 'completado',
      'total': '\$24,00',
    },
  ];

  String _getBreadcrumbTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'Punto de Venta';
      case 2:
        return 'Mesas';
      case 3:
        return 'Órdenes';
      case 4:
        return 'Menú';
      case 5:
        return 'Promociones';
      case 6:
        return 'Inventario';
      case 7:
        return 'Reportes de Ventas';
      case 8:
        return 'Personal & Roles';
      case 9:
        return 'Control de Caja';
      case 0:
      default:
        return 'Inicio';
    }
  }

  Widget _buildCurrentView(String username) {
    switch (_selectedIndex) {
      case 1:
        return const PuntoDeVentaScreen();
      case 2:
        return const GestionMesasScreen();
      case 3:
        return _buildOrdenesView();
      case 4:
        return const GestionMenuScreen();
      case 5:
        return _buildPromocionesView();
      case 6:
        return const GestionInventarioScreen();
      case 7:
        return const ReportesVentasScreen();
      case 8:
        return const GestionUsuariosScreen();
      case 9:
        return const GestionMesasCajaScreen();
      case 0:
      default:
        return _buildHomeDashboard(username);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username ?? 'admin';
    final isDesktop = MediaQuery.of(context).size.width > 960;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: !isDesktop
          ? Drawer(
              backgroundColor: AppColors.sidebarBg,
              child: SafeArea(child: _buildSidebarContent(username)),
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SIDEBAR LATERAL FIJO (Desktop / Tablet)
          if (isDesktop)
            Container(
              width: 260,
              decoration: const BoxDecoration(
                color: AppColors.sidebarBg,
                border: Border(
                  right: BorderSide(color: AppColors.borderLight, width: 1.2),
                ),
              ),
              child: SafeArea(
                child: _buildSidebarContent(username),
              ),
            ),

          // CONTENIDO PRINCIPAL
          Expanded(
            child: Column(
              children: [
                // TOP NAVBAR / HEADER
                _buildTopNavbar(isDesktop, username),

                // AREA SCROLLABLE DE CONTENIDO
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1240),
                        child: _buildCurrentView(username),
                      ),
                    ),
                  ),
                ),

                // FOOTER INFERIOR
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BARRA SUPERIOR (TOP NAVBAR) ---
  Widget _buildTopNavbar(bool isDesktop, String username) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),

          // BREADCRUMBS: Administración / [Módulo]
          Row(
            children: [
              const Icon(Icons.home_outlined, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 8),
              const Text(
                'Administración',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('/', style: TextStyle(color: AppColors.textSubtle, fontSize: 13)),
              ),
              Text(
                _getBreadcrumbTitle(),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Spacer(),

          // NOTIFICACIONES CON INDICADOR ROJO
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textDark, size: 22),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No tienes notificaciones pendientes'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
          Container(
            height: 24,
            width: 1,
            color: AppColors.borderLight,
          ),
          const SizedBox(width: 16),

          // PERFIL DE USUARIO
          PopupMenuButton<String>(
            tooltip: 'Opciones de perfil',
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'logout') {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18, color: AppColors.textDark),
                    const SizedBox(width: 10),
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: AppColors.logoutText),
                    SizedBox(width: 10),
                    Text('Cerrar sesión', style: TextStyle(color: AppColors.logoutText, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFF332018),
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : 'A',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CONTENIDO DEL SIDEBAR ---
  Widget _buildSidebarContent(String username) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // 1. LOGO DE POSTOR CAFETERIA
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: PostorLogoWidget(height: 120),
        ),
        const SizedBox(height: 14),

        // 2. TARJETA DE PERFIL
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF2C1914),
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : 'A',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'SUPER_ADMIN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. TÍTULO DE SECCIÓN: PRINCIPAL
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PRINCIPAL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.textSubtle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 4. ITEMS DE NAVEGACIÓN
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildSidebarItem(0, Icons.home_rounded, 'Inicio'),
              _buildSidebarItem(1, Icons.shopping_cart_outlined, 'Punto de Venta'),
              _buildSidebarItem(2, Icons.table_restaurant_outlined, 'Mesas'),
              _buildSidebarItem(3, Icons.receipt_long_outlined, 'Órdenes', badgeText: '8'),
              _buildSidebarItem(4, Icons.inventory_2_outlined, 'Menú'),
              _buildSidebarItem(5, Icons.star_outline_rounded, 'Promociones'),

              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  'GESTIÓN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textSubtle,
                  ),
                ),
              ),
              _buildSidebarItem(6, Icons.warehouse_outlined, 'Inventario'),
              _buildSidebarItem(7, Icons.analytics_outlined, 'Reportes Ventas'),
              _buildSidebarItem(8, Icons.people_outline_rounded, 'Personal & Roles'),
              _buildSidebarItem(9, Icons.point_of_sale_rounded, 'Control Caja'),
            ],
          ),
        ),

        // 5. WIDGET INFERIOR: IMPRESORA DESCONECTADA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.printerAlertBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEFE4D4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.print_outlined, size: 20, color: Color(0xFF6B5848)),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.printerOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impresora desconectada',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A382A),
                        ),
                      ),
                      Text(
                        'Verifique la conexión',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8C7B6E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 6. BOTÓN CERRAR SESIÓN
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.logoutBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.logoutBorder),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 18, color: AppColors.logoutText),
                  SizedBox(width: 8),
                  Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.logoutText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 7. FOOTER VERSIÓN
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Postor Cafetería v1.0.0',
            style: TextStyle(fontSize: 11, color: AppColors.textSubtle),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String label, {String? badgeText}) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBurgundy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textMedium,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textMedium,
                  ),
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- VISTA PRINCIPAL: DASHBOARD COMPLETO ---
  Widget _buildHomeDashboard(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. CABECERA: BIENVENIDA Y FECHA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido, $username!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Todo listo para un día lleno de sabor.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 8),
                  Text(
                    'Martes, 22 de septiembre',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. HERO BANNER: "Tradición en cada plato."
        _buildHeroBanner(),

        const SizedBox(height: 24),

        // 3. GRILLA DE 4 KPIs
        _buildKpiSection(),

        const SizedBox(height: 24),

        // 4. SECCIÓN INFERIOR: ÓRDENES RECIENTES + ACCESOS RÁPIDOS
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 850;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildOrdenesRecientesCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildAccesosRapidosCard()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildOrdenesRecientesCard(),
                  const SizedBox(height: 24),
                  _buildAccesosRapidosCard(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  // --- HERO BANNER ---
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      height: 215,
      decoration: BoxDecoration(
        color: AppColors.primaryBurgundyDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/banner_hero_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A1822), Color(0xFF2C0F15)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                );
              },
            ),
          ),

          // Contenido de texto y botones a la izquierda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tradición en cada plato',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gestiona tus pedidos y atiende mejor a tus clientes.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFEDE4D8),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Botón "+ Nueva venta" (lleva a Punto de Venta)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFAF7F2),
                        foregroundColor: AppColors.textDark,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1; // Punto de Venta
                        });
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 18, color: AppColors.textDark),
                          SizedBox(width: 8),
                          Text(
                            'Nueva venta',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Botón "Ver órdenes"
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF8F636A), width: 1.2),
                        backgroundColor: Colors.black.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 3; // Órdenes
                        });
                      },
                      child: const Text(
                        'Ver órdenes',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECCIÓN DE KPIs (4 TARJETAS) ---
  Widget _buildKpiSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 550 ? 2 : 1);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildKpiCard(
              title: 'Ventas de hoy',
              value: '\$248,50',
              icon: Icons.paid_outlined,
            ),
            _buildKpiCard(
              title: 'Órdenes activas',
              value: '8',
              icon: Icons.article_outlined,
            ),
            _buildKpiCard(
              title: 'Pedidos completados',
              value: '24',
              icon: Icons.check_circle_outline_rounded,
            ),
            _buildKpiCard(
              title: 'Ticket promedio',
              value: '\$10,35',
              icon: Icons.bar_chart_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.goldLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.goldDark, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TARJETA: ÓRDENES RECIENTES ---
  Widget _buildOrdenesRecientesCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              const Row(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 20, color: AppColors.textDark),
                  SizedBox(width: 10),
                  Text(
                    'Órdenes recientes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 3; // Ver todas las órdenes
                  });
                },
                child: const Row(
                  children: [
                    Text(
                      'Ver todas',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldDark,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.goldDark),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Orden', style: TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text('Tipo', style: TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text('Estado', style: TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w600))),
                SizedBox(width: 40),
              ],
            ),
          ),

          ..._ordenesRecientes.map((orden) => _buildOrdenRow(orden)),
        ],
      ),
    );
  }

  Widget _buildOrdenRow(Map<String, dynamic> orden) {
    Color bgStatus;
    Color textStatus;
    IconData iconStatus;

    if (orden['estadoTipo'] == 'preparacion') {
      bgStatus = AppColors.statusYellowBg;
      textStatus = AppColors.statusYellowText;
      iconStatus = Icons.soup_kitchen_outlined;
    } else if (orden['estadoTipo'] == 'pendiente') {
      bgStatus = AppColors.statusOrangeBg;
      textStatus = AppColors.statusOrangeText;
      iconStatus = Icons.access_time_rounded;
    } else {
      bgStatus = AppColors.statusGreenBg;
      textStatus = AppColors.statusGreenText;
      iconStatus = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle, width: 0.8)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              orden['id'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  orden['esMesa'] ? Icons.table_restaurant_outlined : Icons.shopping_bag_outlined,
                  size: 16,
                  color: AppColors.textMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  orden['tipo'],
                  style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgStatus,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(iconStatus, size: 13, color: textStatus),
                    const SizedBox(width: 5),
                    Text(
                      orden['estado'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              orden['total'],
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.more_horiz, size: 18, color: AppColors.textSubtle),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Acciones para la orden ${orden['id']}')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TARJETA: ACCESOS RÁPIDOS ---
  Widget _buildAccesosRapidosCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt_rounded, size: 20, color: AppColors.goldAccent),
              SizedBox(width: 8),
              Text(
                'Accesos rápidos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAccesoRapidoItem(
            title: 'Punto de Venta',
            subtitle: 'Catálogo de platos y registrar venta',
            icon: Icons.shopping_cart_outlined,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          const SizedBox(height: 12),
          _buildAccesoRapidoItem(
            title: 'Gestión de Mesas',
            subtitle: 'Configurar salones y mesas',
            icon: Icons.table_restaurant_outlined,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          const SizedBox(height: 12),
          _buildAccesoRapidoItem(
            title: 'Gestionar menú',
            subtitle: 'Platos, bebidas y precios',
            icon: Icons.inventory_2_outlined,
            onTap: () => setState(() => _selectedIndex = 4),
          ),
          const SizedBox(height: 12),
          _buildAccesoRapidoItem(
            title: 'Promociones',
            subtitle: 'Ofertas para tus clientes',
            icon: Icons.star_outline_rounded,
            onTap: () => setState(() => _selectedIndex = 5),
          ),
        ],
      ),
    );
  }

  Widget _buildAccesoRapidoItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.goldLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF5A3820), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSubtle),
          ],
        ),
      ),
    );
  }

  // --- VISTA SECUNDARIA: ÓRDENES ---
  Widget _buildOrdenesView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Todas las Órdenes del Día',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBurgundy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva Venta / Orden'),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._ordenesRecientes.map((o) => _buildOrdenRow(o)),
        ],
      ),
    );
  }

  // --- VISTA SECUNDARIA: PROMOCIONES ---
  Widget _buildPromocionesView() {
    final promos = [
      {'titulo': 'Combo Café + Postre', 'descuento': '20% OFF', 'desc': 'Válido de 4:00 PM a 7:00 PM', 'activo': true},
      {'titulo': '2x1 en Cappuccino', 'descuento': '2x1', 'desc': 'Todos los martes y jueves', 'activo': true},
      {'titulo': 'Desayuno Tradicional', 'descuento': '15% OFF', 'desc': 'Hasta las 11:00 AM', 'activo': false},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promociones Activas - Postor Cafetería',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          ...promos.map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                color: (p['activo'] as bool) ? const Color(0xFFFFFBF6) : Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: (p['activo'] as bool) ? AppColors.goldAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      p['descuento'] as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['titulo'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(p['desc'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                  Switch(
                    value: p['activo'] as bool,
                    activeTrackColor: AppColors.primaryBurgundy,
                    onChanged: (val) {
                      setState(() {
                        p['activo'] = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FOOTER INFERIOR ---
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Postor Cafetería · Sabor que tradición',
            style: TextStyle(fontSize: 12, color: AppColors.textSubtle),
          ),
          Text(
            'Vista de ejemplo',
            style: TextStyle(fontSize: 12, color: AppColors.textSubtle),
          ),
        ],
      ),
    );
  }
}
