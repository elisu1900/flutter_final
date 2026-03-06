import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/alimento.dart';
import 'package:flutter_final_app/models/comida.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class ComidaEditor extends StatelessWidget {
  final Comida comida;
  final VoidCallback onRemoveComida;
  final VoidCallback onAddAlimento;
  final void Function(String alimentoId) onRemoveAlimento;
  final void Function(Alimento a) onEditAlimento;

  const ComidaEditor({
    super.key,
    required this.comida,
    required this.onRemoveComida,
    required this.onAddAlimento,
    required this.onRemoveAlimento,
    required this.onEditAlimento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(128),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  comida.nombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 20, color: AppColors.secondaryTextColor),
                  onPressed: onRemoveComida,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          ...comida.alimentos.map(
            (a) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onEditAlimento(a),
                      child: Text(
                        a.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${a.gramos.toStringAsFixed(0)} g',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onRemoveAlimento(a.id),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, bottom: 8, top: 4),
            child: TextButton.icon(
              onPressed: onAddAlimento,
              icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
              label: const Text(
                '+ Añadir alimento',
                style: TextStyle(fontSize: 13, color: AppColors.primary),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}