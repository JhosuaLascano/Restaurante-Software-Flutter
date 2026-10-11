import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/domain/auth_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const RestauranteApp());
}

class RestauranteApp extends StatelessWidget {
  const RestauranteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Postor Cafetería',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBurgundy,
            primary: AppColors.primaryBurgundy,
            secondary: AppColors.goldAccent,
          ),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
