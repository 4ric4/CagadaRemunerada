class Atividade {
  String tipo;
  int duracaoMinutos;
  DateTime data;
  double valor;

  Atividade({
    required this.tipo,
    required this.duracaoMinutos,
    required this.data,
    required this.valor,
  });

  // Converte um objeto Atividade para um mapa (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'duracaoMinutos': duracaoMinutos,
      'data': data.toIso8601String(), // Formato ISO para armazenar a data
      'valor': valor,
    };
  }

  // Converte um mapa (recuperado do banco de dados) para um objeto Atividade
  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      tipo: map['tipo'],
      duracaoMinutos: map['duracaoMinutos'],
      data: DateTime.parse(
        map['data'],
      ), // Convertendo o formato ISO de volta para DateTime
      valor: map['valor'],
    );
  }
}
