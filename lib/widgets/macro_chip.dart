import 'package:flutter/material.dart';
import 'package:flutter_final_app/services/alimento_service.dart';

class MacroChips extends StatelessWidget {
  final AlimentoBase base;
  const MacroChips({super.key, required this.base});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _chip('${base.kcal.toStringAsFixed(0)} kcal', const Color(0xFFEF6C00)),
        if (base.proteinas > 0)
          _chip('P: ${base.proteinas.toStringAsFixed(1)} g',
              const Color(0xFF1976D2)),
        if (base.carbohidratos > 0)
          _chip('C: ${base.carbohidratos.toStringAsFixed(1)} g',
              const Color(0xFF388E3C)),
        if (base.grasas > 0)
          _chip('G: ${base.grasas.toStringAsFixed(1)} g',
              const Color(0xFF7B1FA2)),
        _chip('por 100 g', Colors.grey),
      ],
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}