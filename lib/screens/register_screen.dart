import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/register_data.dart';
import 'package:flutter_final_app/services/user_profile_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Por favor, rellena todos los campos.');
      return;
    }
    if (password.length < 6) {
      setState(
          () => _errorMsg = 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);

      RegisterData.nombre = name;
      RegisterData.email = email;

      if (mounted) Navigator.pushNamed(context, '/register2');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMsg = _mapError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      default:
        return 'Error al crear la cuenta. Inténtalo de nuevo.';
    }
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
          'Crear cuenta',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Completa tus datos para comenzar tu viaje saludable',
                style: TextStyle(
                    fontSize: 14, color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 32),

              const Text('Nombre completo',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Juan Pérez',
                  hintStyle: TextStyle(
                      color: AppColors.primaryTextColor.withAlpha(128)),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.secondaryTextColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Correo electrónico',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'tu@email.com',
                  hintStyle: TextStyle(
                      color: AppColors.primaryTextColor.withAlpha(128)),
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.secondaryTextColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Contraseña',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                      color: AppColors.primaryTextColor.withAlpha(128)),
                  prefixIcon: const Icon(Icons.lock_outlined,
                      color: AppColors.secondaryTextColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondaryTextColor,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
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

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                        AppColors.primary.withAlpha(128),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Continuar',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
