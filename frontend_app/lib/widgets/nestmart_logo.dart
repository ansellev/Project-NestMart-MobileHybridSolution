import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class NestmartLogo extends StatelessWidget {
  final double scale;
  const NestmartLogo({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flame + Arch + Basket composite
        SizedBox(
          width: 100 * scale,
          height: 100 * scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. The Arch (Oven-like outline with brick texture look)
              Positioned(
                bottom: 10 * scale,
                child: Container(
                  width: 76 * scale,
                  height: 64 * scale,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 4 * scale,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38 * scale),
                      topRight: Radius.circular(38 * scale),
                    ),
                  ),
                ),
              ),

              // Horizontal details on the Arch (represented by curved strokes or dashes)
              Positioned(
                bottom: 8 * scale,
                child: Container(
                  width: 86 * scale,
                  height: 4 * scale,
                  color: AppColors.primary,
                ),
              ),

              // 2. The Flame at the top center of the arch
              Positioned(
                top: 8 * scale,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween(begin: 0.9, end: 1.1),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Icon(
                        Icons.local_fire_department, // Replicates flame perfectly
                        color: AppColors.primary,
                        size: 26 * scale,
                      ),
                    );
                  },
                ),
              ),

              // 3. Inside elements: Bread basket or produce basket
              Positioned(
                bottom: 18 * scale,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        color: AppColors.primary,
                        size: 32 * scale,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8 * scale),
        // Logo Text in Playfair serif font with tracking/spacing
        Text(
          'NESTMART',
          style: GoogleFonts.playfairDisplay(
            fontSize: 26 * scale,
            fontWeight: FontWeight.bold,
            letterSpacing: 4 * scale,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
