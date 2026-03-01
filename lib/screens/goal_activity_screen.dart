import 'package:flutter/material.dart';
import 'package:flutter_final_app/services/user_profile_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class GoalsActivityScreen extends StatefulWidget {
  const GoalsActivityScreen({super.key});

  @override
  State<GoalsActivityScreen> createState() => _GoalsActivityScreenState();
}

class _GoalsActivityScreenState extends State<GoalsActivityScreen> {
  Goal? _selectedGoal;
  ActivityLevel? _selectedActivityLevel;
  String? _errorMsg;
  bool _saving = false;

  Widget _buildGoalOption(String title, Goal value) {
    final isSelected = _selectedGoal == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? AppColors.primary : AppColors.primaryTextColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityOption(
      String title, String description, ActivityLevel value) {
    final isSelected = _selectedActivityLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivityLevel = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color:
                    isSelected ? AppColors.primary : AppColors.primaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(description,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.secondaryTextColor)),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    if (_selectedGoal == null) {
      setState(() => _errorMsg = 'Selecciona un objetivo.');
      return;
    }
    if (_selectedActivityLevel == null) {
      setState(() => _errorMsg = 'Selecciona tu nivel de actividad.');
      return;
    }

    RegisterData.objetivo = _selectedGoal!;
    RegisterData.actividad = _selectedActivityLevel!;

    setState(() => _saving = true);
    final profile = RegisterData.toProfile();
    await UserProfileService.saveProfile(profile);
    RegisterData.reset();
    setState(() => _saving = false);

    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

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
        title: const Text(
          'Objetivos y actividad',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Paso 3 de 3',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryTextColor)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '¡Último paso! Define tus objetivos',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.secondaryTextColor),
                    ),
                    const SizedBox(height: 32),

                    // Objetivos
                    const Text('Objetivo',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryTextColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    _buildGoalOption('Perder peso', Goal.lose),
                    _buildGoalOption('Mantener peso', Goal.maintain),
                    _buildGoalOption('Ganar peso', Goal.gain),
                    const SizedBox(height: 32),

                    // Actividad
                    const Text('Nivel de actividad física',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryTextColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    _buildActivityOption('No muy activo',
                        'Gran parte del día sentado (ej: oficinista)',
                        ActivityLevel.sedentary),
                    _buildActivityOption('Ligeramente activo',
                        'Mucho tiempo de pie (ej: cocinero)',
                        ActivityLevel.light),
                    _buildActivityOption('Activo',
                        'Actividad física frecuente (ej: camarero)',
                        ActivityLevel.moderate),
                    _buildActivityOption('Muy activo',
                        'Actividad física intensa (ej: repartidor en bici)',
                        ActivityLevel.veryActive),

                    if (_errorMsg != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_errorMsg!,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFFD32F2F))),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saving ? null : _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Finalizar',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
