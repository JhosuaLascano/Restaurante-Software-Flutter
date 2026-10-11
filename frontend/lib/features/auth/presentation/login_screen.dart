import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/auth_provider.dart';
import '../../gerente/presentation/gerente_dashboard_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/postor_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      final success = await authProvider.login(username, password);

      if (mounted) {
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GerenteDashboardScreen(),
            ),
          );
        } else {
          // Si el backend no está encendido o falló en desarrollo, permitir acceso demo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Conexión backend fallida (${authProvider.errorMessage ?? "servidor no disponible"}). Ingresando como admin demo...'),
              backgroundColor: AppColors.primaryBurgundy,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GerenteDashboardScreen(),
            ),
          );
        }
      }
    }
  }

  void _loginDirectoDemo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GerenteDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // PANEL IZQUIERDO: IMAGEN Y AMBIENTE GOURMET (Pantallas anchas)
          if (isWideScreen)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner_hero_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        AppColors.primaryBurgundyDark.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRADICIÓN & CAFÉ DE ESPECIALIDAD',
                        style: TextStyle(
                          color: Color(0xFFE5D5C5),
                          fontSize: 13,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Buen comer, mejores historias en cada taza y plato.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontFamily: 'serif',
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // PANEL DERECHO: FORMULARIO DE ACCESO POSTOR CAFETERÍA
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _buildLoginForm(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LOGO POSTOR CAFETERÍA
          const SizedBox(
            width: 280,
            child: PostorLogoWidget(height: 110),
          ),
          const SizedBox(height: 20),

          // TITULO Y SUBTITULO
          const Text(
<<<<<<< HEAD
            'Chucha Orden',
=======
            'Postor Cafetería',
>>>>>>> origin/main
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'serif',
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'SISTEMA DE GESTIÓN Y ADMINISTRACIÓN',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // ALERTA DE ERROR DE LOGIN
          if (authProvider.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFF991B1B), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // CAMPO USUARIO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'USUARIO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMedium,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Ingrese su usuario',
                  hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFFAF7F2),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryBurgundy, width: 1.5),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ingresa tu usuario' : null,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CAMPO CONTRASEÑA
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CONTRASEÑA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 0.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFFAF7F2),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined,
                      color: AppColors.textSubtle,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryBurgundy, width: 1.5),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Ingresa tu contraseña' : null,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CHECKBOX MANTENER SESION
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: AppColors.primaryBurgundy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) {
                    setState(() {
                      _rememberMe = val ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mantener sesión iniciada',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // BOTON INICIAR SESION
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBurgundy,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: authProvider.isLoading ? null : _submitLogin,
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBurgundy,
                side: const BorderSide(color: AppColors.goldAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Acceso Rápido al Dashboard (Admin)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              onPressed: _loginDirectoDemo,
            ),
          ),
          const SizedBox(height: 20),

          // FOOTER
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
<<<<<<< HEAD
                  '© 2026 CHUCHA ORDEN',
=======
                  '© 2026 POSTOR CAFETERÍA',
>>>>>>> origin/main
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSubtle,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.local_cafe_outlined, size: 16, color: AppColors.goldAccent),
                    SizedBox(width: 6),
                    Text(
                      'Sabor que tradición',
                      style: TextStyle(fontSize: 11, color: AppColors.textSubtle, fontStyle: FontStyle.italic),
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
}
