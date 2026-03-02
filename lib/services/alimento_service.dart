import 'dart:convert';
import 'package:http/http.dart' as http;


class AlimentoBase {
  final String nombre;
  final String macro; 
  final double kcal;
  final double proteinas;
  final double carbohidratos;
  final double grasas;

  const AlimentoBase({
    required this.nombre,
    required this.macro,
    required this.kcal,
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
  });

  String get macroLabel {
    switch (macro) {
      case 'proteinas':
        return 'Proteína';
      case 'carbohidratos':
        return 'Carbohidrato';
      case 'grasas':
        return 'Grasa';
      case 'frutas':
        return 'Fruta';
      default:
        return macro;
    }
  }

  factory AlimentoBase.fromJson(Map<String, dynamic> j, String categoria) {
    return AlimentoBase(
      nombre: (j['nombre'] as String),
      macro: categoria,
      kcal: (j['kcal'] as num).toDouble(),
      proteinas: (j['proteinas'] as num? ?? 0).toDouble(),
      carbohidratos: (j['carbohidratos'] as num? ?? 0).toDouble(),
      grasas: (j['grasas'] as num? ?? 0).toDouble(),
    );
  }
}


class AlimentosService {
  static const String _url =
      'https://raw.githubusercontent.com/elisu1900/flutter-data/refs/heads/main/data.json';

  static List<AlimentoBase>? _cache;

  
  static Future<List<AlimentoBase>> getAlimentos() async {
    if (_cache != null) return _cache!;

    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Error al cargar alimentos (${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<AlimentoBase> todos = [];

    const categorias = ['carbohidratos', 'proteinas', 'grasas', 'frutas'];

    for (final categoria in categorias) {
      final lista = data[categoria] as List<dynamic>? ?? [];
      for (final item in lista) {
        todos.add(AlimentoBase.fromJson(item as Map<String, dynamic>, categoria));
      }
    }

    _cache = todos;
    return todos;
  }

  static Future<List<AlimentoBase>> buscar(String query) async {
    if (query.trim().isEmpty) return await getAlimentos();
    final todos = await getAlimentos();
    final q = _normalize(query);
    return todos.where((a) => _normalize(a.nombre).contains(q)).toList();
  }

  static Future<List<AlimentoBase>> porCategoria(String categoria) async {
    final todos = await getAlimentos();
    return todos.where((a) => a.macro == categoria).toList();
  }

  static void clearCache() => _cache = null;

  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }
}