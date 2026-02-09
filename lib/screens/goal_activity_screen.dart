import 'package:flutter/material.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class GoalsActivityScreen extends StatefulWidget {
  const GoalsActivityScreen({Key? key}) : super(key: key);

  @override
  State<GoalsActivityScreen> createState() => _GoalsActivityScreenState();
}

class _GoalsActivityScreenState extends State<GoalsActivityScreen> {
  String? _selectedGoal;
  String? _selectedActivityLevel;
  final _birthDateController = TextEditingController();

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Widget _buildGoalOption(String title) {
    final isSelected = _selectedGoal == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = title;
        });
      },
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

  Widget _buildActivityOption(String title, String description) {
    final isSelected = _selectedActivityLevel == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityLevel = title;
        });
      },
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
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
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
          onPressed: () {
            Navigator.pop(context);
          },
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
                    // Indicador de progreso
                    const Text(
                      'Paso 3 de 3',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 3 / 3,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '¡Último paso! Define tus objetivos',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Objetivo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGoalOption('Perder peso'),
                    _buildGoalOption('Ganar peso'),
                    _buildGoalOption('Mantener peso'),
                    const SizedBox(height: 32),

                    const Text(
                      'Nivel de actividad física',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF263238),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityOption(
                      'No muy activo',
                      'Gran parte del día sentado (ej: oficinista)',
                    ),
                    _buildActivityOption(
                      'Ligeramente activo',
                      'Mucho tiempo de pie (ej: cocinero)',
                    ),
                    _buildActivityOption(
                      'Activo',
                      'Actividad física frecuente (ej: camarero)',
                    ),
                    _buildActivityOption(
                      'Muy activo',
                      'Actividad física intensa (ej: repartidor en bici)',
                    ),
                    const SizedBox(height: 32),

                    // Fecha de nacimiento
                    const Text(
                      'Fecha de nacimiento',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _birthDateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _birthDateController.text =
                                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        hintStyle: TextStyle(
                          color: AppColors.primaryTextColor.withAlpha(128),
                        ),
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
