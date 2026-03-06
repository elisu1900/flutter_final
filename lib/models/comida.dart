import 'package:flutter_final_app/models/alimento.dart';

class Comida {
  final String id;
  String nombre;
  List<Alimento> alimentos;

  Comida({
    required this.id,
    required this.nombre,
    List<Alimento>? alimentos,
  }) : alimentos = alimentos ?? [];

  double get kcalTotal          => alimentos.fold(0, (s, a) => s + a.kcalTotal);
  double get proteinasTotal     => alimentos.fold(0, (s, a) => s + a.proteinasTotal);
  double get carbohidratosTotal => alimentos.fold(0, (s, a) => s + a.carbohidratosTotal);
  double get grasasTotal        => alimentos.fold(0, (s, a) => s + a.grasasTotal);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'alimentos': alimentos.map((a) => a.toJson()).toList(),
      };

  factory Comida.fromJson(Map<String, dynamic> j) => Comida(
        id: j['id'],
        nombre: j['nombre'],
        alimentos: (j['alimentos'] as List)
            .map((a) => Alimento.fromJson(a))
            .toList(),
      );
}