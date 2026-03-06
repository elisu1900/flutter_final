import 'dart:convert';
import 'package:flutter_final_app/models/alimento.dart';
import 'package:flutter_final_app/models/comida.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorageService {
  static const String _dietasKey = 'dietas_v1';

  Future<List<Dieta>> getDietas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dietasKey);
    if (raw == null) return _defaultDietas();
    final list = jsonDecode(raw) as List;
    return list.map((d) => Dieta.fromJson(d)).toList();
  }

  Future<void> saveDietas(List<Dieta> dietas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _dietasKey, jsonEncode(dietas.map((d) => d.toJson()).toList()));
  }

  Future<void> addDieta(Dieta dieta) async {
    final dietas = await getDietas();
    dietas.add(dieta);
    await saveDietas(dietas);
  }

  Future<void> updateDieta(Dieta updated) async {
    final dietas = await getDietas();
    final idx = dietas.indexWhere((d) => d.id == updated.id);
    if (idx != -1) dietas[idx] = updated;
    await saveDietas(dietas);
  }

  Future<void> deleteDieta(String id) async {
    final dietas = await getDietas();
    dietas.removeWhere((d) => d.id == id);
    await saveDietas(dietas);
  }

  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  List<Dieta> _defaultDietas() => [
        Dieta(
          id: '1',
          nombre: 'Día de Descanso',
          comidas: [
            Comida(
              id: '101',
              nombre: 'Desayuno',
              alimentos: [
                Alimento(id: '1001', nombre: 'Avena',     gramos: 80,  kcal: 390, proteinas: 13,  carbohidratos: 66, grasas: 7),
                Alimento(id: '1002', nombre: 'Plátano',   gramos: 120, kcal: 90,  carbohidratos: 23),
                Alimento(id: '1003', nombre: 'Almendras', gramos: 30,  kcal: 580, grasas: 55),
              ],
            ),
            Comida(
              id: '102',
              nombre: 'Comida',
              alimentos: [
                Alimento(id: '1004', nombre: 'Pechuga pollo', gramos: 150, kcal: 120, proteinas: 22),
                Alimento(id: '1005', nombre: 'Arroz',         gramos: 150, kcal: 360, carbohidratos: 78),
                Alimento(id: '1006', nombre: 'AOVE',          gramos: 10,  kcal: 884, grasas: 100),
              ],
            ),
            Comida(
              id: '103',
              nombre: 'Cena',
              alimentos: [
                Alimento(id: '1007', nombre: 'Salmón',   gramos: 180, kcal: 220, proteinas: 22, grasas: 13),
                Alimento(id: '1008', nombre: 'Patata',   gramos: 200, kcal: 77,  carbohidratos: 17),
                Alimento(id: '1009', nombre: 'Aguacate', gramos: 80,  kcal: 160, grasas: 15),
              ],
            ),
          ],
        ),
      ];
}