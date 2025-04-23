class UserSettings {
  double salarioMensal;
  int diasTrabalho;
  double horasPorDia;

  UserSettings({
    required this.salarioMensal,
    required this.diasTrabalho,
    required this.horasPorDia,
  });

  // Método que calcula o valor por hora do usuário
  double get valorHora {
    final diasPorMes = diasTrabalho * 4; // Simplificação
    final horasMes = diasPorMes * horasPorDia;
    return salarioMensal / horasMes;
  }

  // Converte um objeto UserSettings para um mapa (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'salarioMensal': salarioMensal,
      'diasTrabalho': diasTrabalho,
      'horasPorDia': horasPorDia,
    };
  }

  // Converte um mapa (recuperado do banco de dados) para um objeto UserSettings
  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      salarioMensal: map['salarioMensal'],
      diasTrabalho: map['diasTrabalho'],
      horasPorDia: map['horasPorDia'],
    );
  }
}
