import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/comida.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/services/local_storage_service.dart';
import 'package:flutter_final_app/styles/app_colors.dart';
import 'package:flutter_final_app/widgets/drawer.dart';

class VerDietasScreen extends StatefulWidget {
  const VerDietasScreen({super.key});

  @override
  State<VerDietasScreen> createState() => _VerDietasScreenState();
}

class _VerDietasScreenState extends State<VerDietasScreen> {
  final LocalStorageService _storage = LocalStorageService();
  final int _maxDietas = 5;

  List<Dieta> _dietas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDietas();
  }

  Future<void> _loadDietas() async {
    final dietas = await _storage.getDietas();
    if (mounted) {
      setState(() {
        _dietas = dietas;
        _loading = false;
      });
    }
  }

  Future<void> _crearNuevaDieta() async {
    if (_dietas.length >= _maxDietas) return;

    final nueva = Dieta(
      id: _storage.generateId(),
      nombre: 'Nueva dieta ${_dietas.length + 1}',
      comidas: [
        Comida(
          id: _storage.generateId(),
          nombre: 'Desayuno',
        ),
        Comida(
          id: _storage.generateId(),
          nombre: 'Comida',
        ),
        Comida(
          id: _storage.generateId(),
          nombre: 'Cena',
        ),
      ],
    );

    await _storage.addDieta(nueva);
    await _loadDietas();
  }

  Future<void> _openDieta(Dieta dieta) async {
    final result = await Navigator.pushNamed(
      context,
      '/dieta-view',
      arguments: dieta,
    );

    if (result == 'deleted') {
      await _storage.deleteDieta(dieta.id);
      await _loadDietas();
    } else if (result is Dieta) {
      await _loadDietas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.primaryTextColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Mis Dietas',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: const MenuDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF90CAF9),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Puedes tener hasta $_maxDietas dietas diferentes para distintos tipos de día',
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: _dietas.isEmpty
                        ? _EmptyState(onCrear: _crearNuevaDieta)
                        : ListView.builder(
                            itemCount: _dietas.length,
                            itemBuilder: (context, index) {
                              final dieta = _dietas[index];
                              return _DietaCard(
                                dieta: dieta,
                                onTap: () => _openDieta(dieta),
                              );
                            },
                          ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _dietas.length < _maxDietas
                          ? _crearNuevaDieta
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: _dietas.length < _maxDietas
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Crear nueva dieta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _dietas.length < _maxDietas
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}


class _DietaCard extends StatelessWidget {
  final Dieta dieta;
  final VoidCallback onTap;

  const _DietaCard({required this.dieta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_menu,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dieta.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dieta.comidas.length} comidas · ${dieta.kcalTotal.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.secondaryTextColor),
          ],
        ),
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  final VoidCallback onCrear;
  const _EmptyState({required this.onCrear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 64, color: AppColors.primary.withAlpha(128)),
          const SizedBox(height: 16),
          const Text(
            'Aún no tienes dietas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea tu primera dieta para empezar',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
