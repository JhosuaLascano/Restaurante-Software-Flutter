import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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
      final success = await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido, ${authProvider.username}!'),
            backgroundColor: const Color(0xFF065F46),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      body: Row(
        children: [
          // PANEL IZQUIERDO: IMAGEN Y FRASE (Visibles solo en pantallas anchas / Web / Desktop)
          if (isWideScreen)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ALTA COCINA & GESTIÓN',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'La excelencia en cada detalle, el sabor en cada momento.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontFamily: 'Playfair Display',
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // PANEL DERECHO: FORMULARIO EXACTO DINETRACK
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
          // ICONO CIRCULAR
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7ED),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: Color(0xFFFF6B00),
              size: 24,
            ),
          ),
          const SizedBox(height: 15),

          // TITULO Y SUBTITULO
          const Text(
            'Chucha Orden',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'ACCESO AL SISTEMA ADMINISTRATIVO',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),

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
                  color: Color(0xFF4B5563),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Ingrese su usuario',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 1.5),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ingresa tu usuario' : null,
              ),
            ],
          ),
          const SizedBox(height: 25),

          // CAMPO CONTRASEÑA CON OLVIDASTE TU CONTRASEÑA
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
                      color: Color(0xFF4B5563),
                      letterSpacing: 0.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF6B00),
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
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined,
                      color: const Color(0xFF9CA3AF),
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
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 1.5),
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
                  activeColor: const Color(0xFFFF6B00),
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
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // BOTON INICIAR SESION
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
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
          const SizedBox(height: 20),

          // SUPPORT LINK
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Nuevo en el equipo? ',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Solicitar acceso',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFF6B00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // FOOTER
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 CHUCHA ORDEN',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.facebook, size: 18, color: Color(0xFF9CA3AF)),
                    SizedBox(width: 12),
                    Icon(Icons.camera_alt_outlined, size: 18, color: Color(0xFF9CA3AF)),
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
