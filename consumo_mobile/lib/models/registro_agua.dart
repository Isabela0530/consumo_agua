class RegistroAgua {
  String data;
  double quantidadeEmMl;
  double pesoAtualKg;

  RegistroAgua({
    required this.data,
    required this.quantidadeEmMl,
    required this.pesoAtualKg,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'quantidade_em_ml': quantidadeEmMl,
      'peso_atual_kg': pesoAtualKg,
    };
  }

  factory RegistroAgua.fromMap(Map<String, dynamic> map) {
    return RegistroAgua(
      data: map['data'],
      quantidadeEmMl: (map['quantidade_em_ml'] as num).toDouble(),
      pesoAtualKg: (map['peso_atual_kg'] as num).toDouble(),
    );
  }
}