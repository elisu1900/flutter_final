import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


enum ActivityLevel {
  sedentary,    
  light,       
  moderate,     
  veryActive,   
}

enum Goal { lose, maintain, gain }

class UserProfile {
  final String nombre;
  final String email;
  final int edad;
  final String sexo; 
  final double peso; 
  final double altura; 
  final ActivityLevel actividad;
  final Goal objetivo;

  const UserProfile({
    required this.nombre,
    required this.email,
    required this.edad,
    required this.sexo,
    required this.peso,
    required this.altura,
    required this.actividad,
    required this.objetivo,
  });

  double get tmb {
    if (sexo == 'masculino') {
      return (10 * peso) + (6.25 * altura) - (5 * edad) + 5;
    } else {
      return (10 * peso) + (6.25 * altura) - (5 * edad) - 161;
    }
  }

  double get _factor {
    switch (actividad) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
    }
  }

  double get kcalMantenimiento => tmb * _factor;

  double get kcalObjetivo {
    switch (objetivo) {
      case Goal.lose:
        return kcalMantenimiento - 400;
      case Goal.gain:
        return kcalMantenimiento + 400;
      case Goal.maintain:
        return kcalMantenimiento;
    }
  }

  double get carbohidratosG => (kcalObjetivo * 0.50) / 4;
  double get proteinasG     => (kcalObjetivo * 0.20) / 4;
  double get grasasG        => (kcalObjetivo * 0.30) / 9;

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'email': email,
        'edad': edad,
        'sexo': sexo,
        'peso': peso,
        'altura': altura,
        'actividad': actividad.index,
        'objetivo': objetivo.index,
      };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        nombre: j['nombre'] ?? '',
        email: j['email'] ?? '',
        edad: j['edad'] ?? 25,
        sexo: j['sexo'] ?? 'masculino',
        peso: (j['peso'] as num).toDouble(),
        altura: (j['altura'] as num).toDouble(),
        actividad: ActivityLevel.values[j['actividad'] ?? 0],
        objetivo: Goal.values[j['objetivo'] ?? 1],
      );
}


class UserProfileService {
  static const String _key = 'user_profile_v1';

  // Perfil en memoria (caché ligera)
  static UserProfile? _cache;

  static Future<UserProfile?> getProfile() async {
    if (_cache != null) return _cache;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    _cache = UserProfile.fromJson(jsonDecode(raw));
    return _cache;
  }

  static Future<void> saveProfile(UserProfile p) async {
    _cache = p;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(p.toJson()));
  }

  static Future<void> clearProfile() async {
    _cache = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static void clearCache() => _cache = null;
}


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
