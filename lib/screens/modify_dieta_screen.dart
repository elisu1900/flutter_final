import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/alimento.dart';
import 'package:flutter_final_app/models/comida.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/widgets/buscador_alimento.dart';
import 'package:flutter_final_app/services/local_storage_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';
import 'package:flutter_final_app/widgets/comida_editor.dart';

class ModifyDietaScreen extends StatefulWidget {
  final Dieta dieta;

  const ModifyDietaScreen({super.key, required this.dieta});

  @override
  State<ModifyDietaScreen> createState() => _ModifyDietaScreenState();
}

class _ModifyDietaScreenState extends State<ModifyDietaScreen> {
  final LocalStorageService _storage = LocalStorageService();
  late String _nombre;
  late List<Comida> _comidas;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nombre = widget.dieta.nombre;
    _comidas = widget.dieta.comidas
        .map((c) => Comida(
              id: c.id,
              nombre: c.nombre,
              alimentos: c.alimentos
                  .map((a) => Alimento(
                        id: a.id,
                        nombre: a.nombre,
                        gramos: a.gramos,
                        kcal: a.kcal,
                      ))
                  .toList(),
            ))
        .toList();
  }


  void _addComida() {
    setState(() {
      _comidas.add(Comida(
        id: _storage.generateId(),
        nombre: _nombreComidaPorDefecto(),
      ));
    });
  }

  String _nombreComidaPorDefecto() {
    const nombres = ['Desayuno', 'Comida', 'Merienda', 'Cena', 'Snack'];
    for (final n in nombres) {
      if (_comidas.every((c) => c.nombre != n)) return n;
    }
    return 'Comida ${_comidas.length + 1}';
  }

  void _removeComida(String comidaId) {
    setState(() {
      _comidas.removeWhere((c) => c.id == comidaId);
    });
  }


  void _addAlimento(String comidaId) async {
    final alimento = await showModalBottomSheet<Alimento>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BuscadorAlimentoSheet(),
    );
    if (alimento != null) {
      setState(() {
        final comida = _comidas.firstWhere((c) => c.id == comidaId);
        comida.alimentos.add(alimento);
      });
    }
  }

  void _removeAlimento(String comidaId, String alimentoId) {
    setState(() {
      final comida = _comidas.firstWhere((c) => c.id == comidaId);
      comida.alimentos.removeWhere((a) => a.id == alimentoId);
    });
  }

  void _showAlimentoDialog(String comidaId, Alimento? existing) {
    final nombreCtrl = TextEditingController(text: existing?.nombre ?? '');
    final gramosCtrl = TextEditingController(
        text: existing != null ? existing.gramos.toString() : '');
    final kcalCtrl = TextEditingController(
        text: existing != null ? existing.kcal.toString() : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Añadir alimento' : 'Editar alimento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej: Pechuga de pollo',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: gramosCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Gramos',
                  hintText: '150',
                  suffixText: 'g',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kcalCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Kcal por 100 g',
                  hintText: '165',
                  suffixText: 'kcal/100g',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreCtrl.text.trim();
              final gramos = double.tryParse(gramosCtrl.text.trim()) ?? 0;
              final kcal = double.tryParse(kcalCtrl.text.trim()) ?? 0;

              if (nombre.isEmpty || gramos <= 0) return;

              setState(() {
                final comida = _comidas.firstWhere((c) => c.id == comidaId);
                if (existing == null) {
                  comida.alimentos.add(Alimento(
                    id: _storage.generateId(),
                    nombre: nombre,
                    gramos: gramos,
                    kcal: kcal,
                  ));
                } else {
                  final idx =
                      comida.alimentos.indexWhere((a) => a.id == existing.id);
                  if (idx != -1) {
                    comida.alimentos[idx] = Alimento(
                      id: existing.id,
                      nombre: nombre,
                      gramos: gramos,
                      kcal: kcal,
                    );
                  }
                }
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(existing == null ? 'Añadir' : 'Guardar'),
          ),
        ],
      ),
    );
  }


  Future<void> _guardar() async {
    if (_nombre.trim().isEmpty) return;
    setState(() => _saving = true);

    final updated = Dieta(
      id: widget.dieta.id,
      nombre: _nombre.trim(),
      comidas: _comidas,
    );

    await _storage.updateDieta(updated);
    setState(() => _saving = false);

    if (mounted) Navigator.pop(context, updated);
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
          'Editar Dieta',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre de la dieta',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: _nombre),
                    onChanged: (v) => _nombre = v,
                    decoration: InputDecoration(
                      hintText: 'Ej: Día de Entrenamiento',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ..._comidas.map((comida) => ComidaEditor(
                        comida: comida,
                        onRemoveComida: () => _removeComida(comida.id),
                        onAddAlimento: () => _addAlimento(comida.id),
                        onRemoveAlimento: (alimentoId) =>
                            _removeAlimento(comida.id, alimentoId),
                        onEditAlimento: (a) =>
                            _showAlimentoDialog(comida.id, a),
                      )),

                  TextButton.icon(
                    onPressed: _addComida,
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    label: const Text(
                      '+ Añadir comida',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Guardar cambios',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}