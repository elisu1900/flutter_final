import 'package:flutter_final_app/models/comida.dart';

class Dieta {
  final String id;
  String nombre;
  List<Comida> comidas;

  Dieta({
    required this.id,
    required this.nombre,
    List<Comida>? comidas,
  }) : comidas = comidas ?? [];

  double get kcalTotal          => comidas.fold(0, (s, c) => s + c.kcalTotal);
  double get proteinasTotal     => comidas.fold(0, (s, c) => s + c.proteinasTotal);
  double get carbohidratosTotal => comidas.fold(0, (s, c) => s + c.carbohidratosTotal);
  double get grasasTotal        => comidas.fold(0, (s, c) => s + c.grasasTotal);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'comidas': comidas.map((c) => c.toJson()).toList(),
      };

  factory Dieta.fromJson(Map<String, dynamic> j) => Dieta(
        id: j['id'],
        nombre: j['nombre'],
        comidas: (j['comidas'] as List)
            .map((c) => Comida.fromJson(c))
            .toList(),
      );
}