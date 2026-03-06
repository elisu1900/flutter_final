import 'package:flutter_final_app/models/user_profile.dart';

class RegisterData {
  static String nombre = '';
  static String email = '';
  static int edad = 0;
  static String sexo = '';
  static double peso = 0;
  static double altura = 0;
  static ActivityLevel actividad = ActivityLevel.sedentary;
  static Goal objetivo = Goal.maintain;

  static void reset() {
    nombre = '';
    email = '';
    edad = 0;
    sexo = '';
    peso = 0;
    altura = 0;
    actividad = ActivityLevel.sedentary;
    objetivo = Goal.maintain;
  }

  static bool get isComplete =>
      nombre.isNotEmpty &&
      email.isNotEmpty &&
      edad > 0 &&
      sexo.isNotEmpty &&
      peso > 0 &&
      altura > 0;

  static UserProfile toProfile() => UserProfile(
        nombre: nombre,
        email: email,
        edad: edad,
        sexo: sexo,
        peso: peso,
        altura: altura,
        actividad: actividad,
        objetivo: objetivo,
      );
}