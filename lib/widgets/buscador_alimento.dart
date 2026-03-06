import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/alimento.dart';
import 'package:flutter_final_app/services/alimento_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';
import 'package:flutter_final_app/widgets/macro_chip.dart';


class BuscadorAlimentoSheet extends StatefulWidget {
  const BuscadorAlimentoSheet({super.key});

  @override
  State<BuscadorAlimentoSheet> createState() => _BuscadorAlimentoSheetState();
}

class _BuscadorAlimentoSheetState extends State<BuscadorAlimentoSheet> {
  final _searchCtrl = TextEditingController();
  List<AlimentoBase> _resultados = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarTodos();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarTodos() async {
    try {
      final todos = await AlimentosService.getAlimentos();
      if (mounted) setState(() { _resultados = todos; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'No se pudo cargar la lista de alimentos.\nRevisa tu conexión.'; _loading = false; });
    }
  }

  Future<void> _onSearch(String query) async {
    try {
      final res = await AlimentosService.buscar(query);
      if (mounted) setState(() => _resultados = res);
    } catch (_) {}
  }

  void _seleccionar(AlimentoBase base) {
    final gramosCtrl = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          base.nombre[0].toUpperCase() + base.nombre.substring(1),
          style: const TextStyle(fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info nutricional por 100 g
            MacroChips(base: base),
            const SizedBox(height: 20),
            const Text(
              'Cantidad (g)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: gramosCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                suffixText: 'g',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final gramos = double.tryParse(gramosCtrl.text.trim()) ?? 0;
              if (gramos <= 0) return;

              final alimento = Alimento(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nombre: base.nombre[0].toUpperCase() + base.nombre.substring(1),
                gramos: gramos,
                kcal: base.kcal,
                proteinas: base.proteinas,
                carbohidratos: base.carbohidratos,
                grasas: base.grasas,
              );

              Navigator.pop(ctx);           // cierra diálogo de gramos
              Navigator.pop(context, alimento); // cierra sheet y devuelve alimento
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Buscar alimento',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Ej: pollo, avena, aguacate…',
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.secondaryTextColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        )
                      : _resultados.isEmpty
                          ? const Center(
                              child: Text(
                                'Sin resultados',
                                style: TextStyle(
                                    color: AppColors.secondaryTextColor),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollCtrl,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              itemCount: _resultados.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final a = _resultados[i];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 4),
                                  title: Text(
                                    a.nombre[0].toUpperCase() +
                                        a.nombre.substring(1),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${a.kcal.toStringAsFixed(0)} kcal · ${a.macroLabel}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.secondaryTextColor,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.primary,
                                  ),
                                  onTap: () => _seleccionar(a),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
