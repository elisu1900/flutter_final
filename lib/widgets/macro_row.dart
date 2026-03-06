import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/models/user_profile.dart';
import 'package:flutter_final_app/styles/app_colors.dart';
import 'package:flutter_final_app/widgets/macro_item.dart';

class MacrosRow extends StatelessWidget {
  final UserProfile profile;
  final Dieta dieta;

  const MacrosRow({super.key, required this.profile, required this.dieta});

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: const Color(0xFFE0E0E0),
        margin: const EdgeInsets.symmetric(horizontal: 8),
      );

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
          MacroItem(
            label: 'Proteínas',
            actual: dieta.proteinasTotal,
            objetivo: profile.proteinasG,
            color: const Color(0xFF1976D2),
          ),
          _divider(),
          MacroItem(
            label: 'Carbos',
            actual: dieta.carbohidratosTotal,
            objetivo: profile.carbohidratosG,
            color: const Color(0xFF388E3C),
          ),
          _divider(),
          MacroItem(
            label: 'Grasas',
            actual: dieta.grasasTotal,
            objetivo: profile.grasasG,
            color: const Color(0xFF7B1FA2),
          ),
        ],
      ),
    );
  }
}
