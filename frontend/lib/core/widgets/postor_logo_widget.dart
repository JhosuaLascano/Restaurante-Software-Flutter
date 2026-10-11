import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PostorLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool compact;

  const PostorLogoWidget({
    super.key,
    this.width,
    this.height,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? (compact ? 70 : 125),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/postor_cafeteria_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback nativo estilizado en caso de cualquier detalle de asset
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFFFAF6EE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 20, height: 1, color: AppColors.goldAccent),
                    const SizedBox(width: 6),
                    const Text(
                      'CAFETERÍA',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 10,
                        letterSpacing: 2,
                        color: AppColors.primaryBurgundy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(width: 20, height: 1, color: AppColors.goldAccent),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Chucha Orden',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryBurgundy,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B1A1E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldAccent, width: 0.8),
                  ),
                  child: const Text(
                    'SABOR QUE TRADICIÓN',
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      color: Color(0xFFF6EFE5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
