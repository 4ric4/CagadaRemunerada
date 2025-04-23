import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/atividade.dart';
import 'package:intl/intl.dart';

class DashboardGrafico extends StatelessWidget {
  final List<Atividade> atividades;

  DashboardGrafico({required this.atividades});

  @override
  Widget build(BuildContext context) {
    Map<String, double> ganhosPorDia = {};

    // Calcula o total de ganhos por dia
    for (var a in atividades) {
      String dia = DateFormat('yyyy-MM-dd').format(a.data);
      ganhosPorDia[dia] = (ganhosPorDia[dia] ?? 0) + a.valor;
    }

    final dias = ganhosPorDia.keys.toList()..sort();
    final diasRecentes = dias.reversed.take(7).toList().reversed.toList();

    // Encontra o dia com o maior ganho
    String diaMaiorGanho = "";
    double maiorGanho = 0;

    ganhosPorDia.forEach((dia, valor) {
      if (valor > maiorGanho) {
        maiorGanho = valor;
        diaMaiorGanho = dia;
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ganhos Recentes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChart(
                  BarChartData(
                    barGroups:
                        diasRecentes.asMap().entries.map((entry) {
                          final i = entry.key;
                          final dia = entry.value;
                          final valor = ganhosPorDia[dia]!;
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: valor,
                                width: 22,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green,
                                    Colors.lightGreenAccent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                    maxY:
                        ganhosPorDia.values.isNotEmpty
                            ? ganhosPorDia.values.reduce(
                                  (a, b) => a > b ? a : b,
                                ) +
                                10
                            : 100,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 20,
                          getTitlesWidget:
                              (value, meta) => Text(
                                'R\$${value.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < 0 || index >= diasRecentes.length)
                              return Container();
                            final dia = diasRecentes[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                DateFormat('E').format(DateTime.parse(dia)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipMargin: 12,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final dia = diasRecentes[group.x.toInt()];
                          return BarTooltipItem(
                            '${DateFormat('EEE, dd/MM').format(DateTime.parse(dia))}\n'
                            'R\$ ${rod.toY.toStringAsFixed(2)}',
                            TextStyle(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ), // Cor do texto
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ),

                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 20,
                    ),
                    alignment: BarChartAlignment.spaceAround,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Exibe o dia com o maior ganho
              if (diaMaiorGanho.isNotEmpty)
                Text(
                  "Dia com o maior ganho: ${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(diaMaiorGanho))}\n"
                  "R\$ ${maiorGanho.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
