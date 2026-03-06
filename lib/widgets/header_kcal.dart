import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class HeaderKcal extends StatelessWidget {
  final Dieta dieta;
  final double? kcalObjetivo;

  const HeaderKcal({super.key, required this.dieta, this.kcalObjetivo});

  @override
  Widget build(BuildContext context) {
    final kcalActual = dieta.kcalTotal;
    final objetivo = kcalObjetivo ?? 0;
    final progress =
        objetivo > 0 ? (kcalActual / objetivo).clamp(0.0, 1.0) : 0.0;
    final overGoal = objetivo > 0 && kcalActual > objetivo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "2000 kcal / 2500 kcal"
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: kcalActual.toStringAsFixed(0),
                            style: TextStyle(
                              color: overGoal
                                  ? const Color(0xFFD32F2F)
                                  : AppColors.primary,
                            ),
                          ),
                          if (kcalObjetivo != null)
                            TextSpan(
                              text:
                                  ' / ${kcalObjetivo!.toStringAsFixed(0)} kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryTextColor,
                              ),
                            )
                          else
                            const TextSpan(
                              text: ' kcal',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondaryTextColor),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dieta.comidas.length} comidas al día',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (kcalObjetivo != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  overGoal ? '¡Por encima del objetivo!' : 'Progreso del día',
                  style: TextStyle(
                    fontSize: 11,
                    color: overGoal
                        ? const Color(0xFFD32F2F)
                        : AppColors.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: overGoal
                        ? const Color(0xFFD32F2F)
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.primary.withAlpha(40),
                valueColor: AlwaysStoppedAnimation<Color>(
                  overGoal ? const Color(0xFFD32F2F) : AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}