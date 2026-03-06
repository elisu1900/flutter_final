import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/comida.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class ComidaCard extends StatelessWidget {
  final Comida comida;
  final double? kcalObjetivoPorComida;

  const ComidaCard({
    super.key,
    required this.comida,
    this.kcalObjetivoPorComida,
  });

  @override
  Widget build(BuildContext context) {
    final kcalActual = comida.kcalTotal;
    final objetivo = kcalObjetivoPorComida ?? 0;
    final progress =
        objetivo > 0 ? (kcalActual / objetivo).clamp(0.0, 1.0) : 0.0;
    final overGoal = objetivo > 0 && kcalActual > objetivo;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comida.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: kcalActual.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (kcalObjetivoPorComida != null)
                            TextSpan(
                              text:
                                  ' / ${kcalObjetivoPorComida!.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 12,
                              ),
                            ),
                          const TextSpan(
                            text: ' kcal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (kcalObjetivoPorComida != null) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: Colors.white.withAlpha(60),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overGoal ? const Color(0xFFFFCDD2) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (comida.alimentos.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                'Sin alimentos. Edita la dieta para añadir.',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryTextColor.withAlpha(180)),
              ),
            ),
          ...comida.alimentos.map(
            (a) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      a.nombre,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.primaryTextColor),
                    ),
                  ),
                  Text(
                    '${a.gramos.toStringAsFixed(0)} g',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${a.kcalTotal.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (comida.alimentos.isNotEmpty)
            const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}