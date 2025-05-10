class Atividade {
  int? id;
  String tipo;
  int duracaoMinutos;
  DateTime data;
  double valor;

  Atividade({
    this.id,
    required this.tipo,
    required this.duracaoMinutos,
    required this.data,
    required this.valor,
  });

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'],
      tipo: map['tipo'],
      duracaoMinutos: map['duracaoMinutos'],
      data: DateTime.parse(map['data']),
      valor: _parseDouble(map['valor']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'duracaoMinutos': duracaoMinutos,
      'data': data.toIso8601String(),
      'valor': valor,
    };
  }

  /// Método auxiliar para converter qualquer valor para double de forma segura
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
