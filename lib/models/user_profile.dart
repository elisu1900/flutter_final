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