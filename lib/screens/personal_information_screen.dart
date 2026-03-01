import 'package:flutter/material.dart';
import 'package:flutter_final_app/services/user_profile_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? _errorMsg;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _next() {
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    if (age <= 0 || age > 120) {
      setState(() => _errorMsg = 'Introduce una edad válida.');
      return;
    }
    if (_selectedGender == null) {
      setState(() => _errorMsg = 'Selecciona tu sexo.');
      return;
    }
    RegisterData.edad = age;
    RegisterData.sexo = _selectedGender!;
    Navigator.pushNamed(context, '/register3');
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
          'Información personal',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Paso 1 de 3',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.secondaryTextColor)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 1 / 3,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Cuéntanos más sobre ti para personalizar tu experiencia',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 32),

                // Edad
                const Text('Edad',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Ej: 25',
                    hintStyle: TextStyle(
                        color: AppColors.primaryTextColor.withAlpha(128)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Sexo
                const Text('Sexo',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _genderBtn('masculino', 'Masculino')),
                    const SizedBox(width: 16),
                    Expanded(child: _genderBtn('femenino', 'Femenino')),
                  ],
                ),

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

                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Siguiente',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderBtn(String value, String label) {
    final selected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  selected ? Colors.white : AppColors.primaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
