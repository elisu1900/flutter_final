import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/models/user_profile.dart';
import 'package:flutter_final_app/services/user_profile_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';
import 'package:flutter_final_app/widgets/comida_card.dart';
import 'package:flutter_final_app/widgets/header_kcal.dart';
import 'package:flutter_final_app/widgets/macro_row.dart';

class DietaViewScreen extends StatefulWidget {
  final Dieta dieta;

  const DietaViewScreen({super.key, required this.dieta});

  @override
  State<DietaViewScreen> createState() => _DietaViewScreenState();
}

class _DietaViewScreenState extends State<DietaViewScreen> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await UserProfileService.getProfile();
    if (mounted) setState(() => _profile = p);
  }

  @override
  Widget build(BuildContext context) {
    final dieta = widget.dieta;
    final kcalObjetivo = _profile?.kcalObjetivo;
    final kcalActual = dieta.kcalTotal;
    final porComida = kcalObjetivo != null && dieta.comidas.isNotEmpty
        ? kcalObjetivo / dieta.comidas.length
        : null;

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
            HeaderKcal(
              dieta: dieta,
              kcalObjetivo: kcalObjetivo,
            ),
            const SizedBox(height: 16),

            if (_profile != null) MacrosRow(profile: _profile!, dieta: dieta),
            const SizedBox(height: 16),

            ...dieta.comidas.map((comida) => ComidaCard(
                  comida: comida,
                  kcalObjetivoPorComida: porComida,
                )),

            const SizedBox(height: 24),

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
                          borderRadius: BorderRadius.circular(8)),
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
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

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
                    fontSize: 12, color: AppColors.secondaryTextColor),
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
        content: Text(
            '¿Seguro que quieres eliminar "${widget.dieta.nombre}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
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