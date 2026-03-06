import 'package:flutter/material.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class MacroItem extends StatelessWidget {
  final String label;
  final double actual;
  final double objetivo;
  final Color color;

  const MacroItem({
    super.key,
    required this.label,
    required this.actual,
    required this.objetivo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = objetivo > 0 ? (actual / objetivo).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: actual.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color),
                ),
                TextSpan(
                  text: ' / ${objetivo.toStringAsFixed(0)}g',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: color.withAlpha(40),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}