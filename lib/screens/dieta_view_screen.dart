import 'package:flutter/material.dart';
import 'package:flutter_final_app/services/local_storage_service.dart';
import 'package:flutter_final_app/services/user_profile_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

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
            // ── Header total kcal ──────────────────────────────────────────
            _HeaderKcal(
              dieta: dieta,
              kcalObjetivo: kcalObjetivo,
            ),
            const SizedBox(height: 16),

            // ── Macros resumen ─────────────────────────────────────────────
            if (_profile != null) _MacrosRow(profile: _profile!, dieta: dieta),
            const SizedBox(height: 16),

            // ── Comidas ────────────────────────────────────────────────────
            ...dieta.comidas.map((comida) => _ComidaCard(
                  comida: comida,
                  kcalObjetivoPorComida: porComida,
                )),

            const SizedBox(height: 24),

            // ── Botones Editar / Eliminar ──────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
//  HEADER con barra de progreso total
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderKcal extends StatelessWidget {
  final Dieta dieta;
  final double? kcalObjetivo;

  const _HeaderKcal({required this.dieta, this.kcalObjetivo});

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

          // Barra de progreso total (solo si hay perfil)
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

// ─────────────────────────────────────────────────────────────────────────────
//  FILA DE MACROS
// ─────────────────────────────────────────────────────────────────────────────

class _MacrosRow extends StatelessWidget {
  final UserProfile profile;
  final Dieta dieta;

  const _MacrosRow({required this.profile, required this.dieta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
      child: Row(
        children: [
          _MacroItem(
            label: 'Proteínas',
            actual: dieta.proteinasTotal,
            objetivo: profile.proteinasG,
            color: const Color(0xFF1976D2),
          ),
          _divider(),
          _MacroItem(
            label: 'Carbos',
            actual: dieta.carbohidratosTotal,
            objetivo: profile.carbohidratosG,
            color: const Color(0xFF388E3C),
          ),
          _divider(),
          _MacroItem(
            label: 'Grasas',
            actual: dieta.grasasTotal,
            objetivo: profile.grasasG,
            color: const Color(0xFF7B1FA2),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: const Color(0xFFE0E0E0),
        margin: const EdgeInsets.symmetric(horizontal: 8),
      );
}

class _MacroItem extends StatelessWidget {
  final String label;
  final double actual;
  final double objetivo;
  final Color color;

  const _MacroItem({
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

// ─────────────────────────────────────────────────────────────────────────────
//  TARJETA DE COMIDA con barra de progreso propia
// ─────────────────────────────────────────────────────────────────────────────

class _ComidaCard extends StatelessWidget {
  final Comida comida;
  final double? kcalObjetivoPorComida;

  const _ComidaCard({required this.comida, this.kcalObjetivoPorComida});

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
          // Header de la comida
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
                    // "500 kcal / 667 kcal"
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
                // Barra de progreso por comida
                if (kcalObjetivoPorComida != null) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: Colors.white.withAlpha(60),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overGoal
                            ? const Color(0xFFFFCDD2)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Alimentos
          if (comida.alimentos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
