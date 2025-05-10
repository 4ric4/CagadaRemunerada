class UserSettings {
  double salarioMensal;
  int diasTrabalho;
  double horasPorDia;

  UserSettings({
    required this.salarioMensal,
    required this.diasTrabalho,
    required this.horasPorDia,
  });

  double get valorHora {
    final diasPorMes = diasTrabalho * 4;
    final horasMes = diasPorMes * horasPorDia;
    return salarioMensal / horasMes;
  }

  Map<String, dynamic> toMap() {
    return {
      'salario': salarioMensal,
      'dias_trabalho': diasTrabalho,
      'horas_por_dia': horasPorDia,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      salarioMensal: (map['salario'] ?? 0).toDouble(),
      diasTrabalho: (map['dias_trabalho'] ?? 0).toInt(),
      horasPorDia: (map['horas_por_dia'] ?? 0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'UserSettings(salarioMensal: $salarioMensal, diasTrabalho: $diasTrabalho, horasPorDia: $horasPorDia)';
  }
}
