class Atividade {
  int? id; // Campo id, que será utilizado pelo banco de dados
  String tipo;
  int duracaoMinutos;
  DateTime data;
  double valor;

  Atividade({
    this.id, // O id pode ser nulo quando a atividade ainda não foi salva
    required this.tipo,
    required this.duracaoMinutos,
    required this.data,
    required this.valor,
  });

  // Converte um Map para um objeto Atividade
  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'], // O 'id' vem do banco de dados (se houver)
      tipo: map['tipo'],
      duracaoMinutos: map['duracaoMinutos'],
      data: DateTime.parse(map['data']),
      valor: (map['valor'] != null ? (map['valor'] as num).toDouble() : 0.0),
    );
  }

  // Converte um objeto Atividade para um Map (para inserção ou atualização no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // O 'id' será usado para atualizar ou excluir no banco
      'tipo': tipo,
      'duracaoMinutos': duracaoMinutos,
      'data': data.toIso8601String(), // Converte a data para String
      'valor': valor,
    };
  }
}
