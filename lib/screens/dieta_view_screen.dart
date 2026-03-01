import 'package:flutter/material.dart';
import 'package:flutter_final_app/services/local_storage_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class DietaViewScreen extends StatelessWidget {
  final Dieta dieta;

  const DietaViewScreen({super.key, required this.dieta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          dieta.nombre,
          style: const TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header total kcal
            _HeaderKcal(dieta: dieta),
            const SizedBox(height: 16),

            // Comidas
            ...dieta.comidas.map((comida) => _ComidaCard(comida: comida)),

            const SizedBox(height: 24),

            // Botones Editar / Eliminar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.pushNamed(
                        context,
                        '/modify-dieta',
                        arguments: dieta,
                      ) as Dieta?;
                      if (updated != null && context.mounted) {
                        Navigator.pop(context, updated);
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextColor,
                      side: const BorderSide(color: Color(0xFFB0BEC5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Consejo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Consejo: Intenta seguir las porciones indicadas para alcanzar tus objetivos nutricionales.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar dieta'),
        content: Text('¿Seguro que quieres eliminar "${dieta.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _HeaderKcal extends StatelessWidget {
  final Dieta dieta;
  const _HeaderKcal({required this.dieta});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary..withAlpha(128),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant_menu,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${dieta.kcalTotal.toStringAsFixed(0)} KCAL / día',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              Text(
                '${dieta.comidas.length} comidas al día',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComidaCard extends StatelessWidget {
  final Comida comida;
  const _ComidaCard({required this.comida});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Header de la comida
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
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
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${comida.kcalTotal.toStringAsFixed(0)} KCAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Alimentos
          ...comida.alimentos.map(
            (a) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    a.nombre,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  Text(
                    '${a.gramos.toStringAsFixed(0)} g',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w500,
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
