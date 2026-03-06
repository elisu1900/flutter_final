class Alimento {
  final String id;
  String nombre;
  double gramos;
  double kcal;          
  double proteinas;     
  double carbohidratos; 
  double grasas;        

  Alimento({
    required this.id,
    required this.nombre,
    required this.gramos,
    required this.kcal,
    this.proteinas = 0,
    this.carbohidratos = 0,
    this.grasas = 0,
  });

  double get kcalTotal          => (kcal          * gramos) / 100;
  double get proteinasTotal     => (proteinas     * gramos) / 100;
  double get carbohidratosTotal => (carbohidratos * gramos) / 100;
  double get grasasTotal        => (grasas        * gramos) / 100;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'gramos': gramos,
        'kcal': kcal,
        'proteinas': proteinas,
        'carbohidratos': carbohidratos,
        'grasas': grasas,
      };

  factory Alimento.fromJson(Map<String, dynamic> j) => Alimento(
        id: j['id'],
        nombre: j['nombre'],
        gramos: (j['gramos'] as num).toDouble(),
        kcal: (j['kcal'] as num).toDouble(),
        proteinas: (j['proteinas'] as num? ?? 0).toDouble(),
        carbohidratos: (j['carbohidratos'] as num? ?? 0).toDouble(),
        grasas: (j['grasas'] as num? ?? 0).toDouble(),
      );
}