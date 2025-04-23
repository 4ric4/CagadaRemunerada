import 'package:flutter/material.dart';
import '../models/atividade.dart';
import 'package:intl/intl.dart';

class Historico extends StatefulWidget {
  final List<Atividade> atividades;
  final Function(Atividade) onDelete; // Callback para exclusão de atividade

  Historico({required this.atividades, required this.onDelete});

  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  String? tipoSelecionado = 'diario';

  // Função para filtrar as atividades baseadas no tipo (diário ou mensal)
  List<Atividade> _filtrarAtividades(String? tipo) {
    DateTime hoje = DateTime.now();

    switch (tipo) {
      case 'diario':
        return widget.atividades
            .where(
              (a) =>
                  DateFormat('yyyy-MM-dd').format(a.data) ==
                  DateFormat('yyyy-MM-dd').format(hoje),
            )
            .toList();
      case 'mensal':
        return widget.atividades
            .where(
              (a) => a.data.month == hoje.month && a.data.year == hoje.year,
            )
            .toList();
      default:
        return widget.atividades;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 980;

    List<Atividade> atividadesFiltradas = _filtrarAtividades(tipoSelecionado);

    // Agrupar atividades por data
    Map<String, List<Atividade>> agrupadas = {};
    for (var a in atividadesFiltradas) {
      String dia = DateFormat('yyyy-MM-dd').format(a.data);
      agrupadas.putIfAbsent(dia, () => []).add(a);
    }

    // Calcular total geral
    double totalGeral = atividadesFiltradas.fold(0, (sum, a) => sum + a.valor);

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: isSmallScreen ? screenWidth * 0.9 : 950,
          height: isSmallScreen ? null : 686,
          margin: EdgeInsets.only(top: 50, bottom: 50),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown de tipo de filtro (Diário ou Mensal)
              Positioned(
                top: 242,
                left: 580,
                child: Container(
                  width: 171,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E4708),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Color(0xFF1E4708),
                      value: tipoSelecionado,
                      iconEnabledColor: Colors.white,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                      onChanged: (value) {
                        setState(() {
                          tipoSelecionado = value;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text('Diário'),
                          value: 'diario',
                        ),
                        DropdownMenuItem(
                          child: Text('Mensal'),
                          value: 'mensal',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Exibição do total gerado
              Text(
                "Total gerado: R\$ ${totalGeral.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  backgroundColor: Color(0xFF39EE3F).withOpacity(0.7),
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 20),

              // Exibição de atividades filtradas (diário ou mensal)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de acordo com o tipo de filtro (Diário ou Mensal)
                  Text(
                    tipoSelecionado == 'mensal'
                        ? 'Mês: ${DateFormat('MMMM yyyy', 'pt_BR').format(DateTime.now())}'
                        : 'Dia: ${DateFormat('dd MMM yyyy', 'pt_BR').format(DateTime.now())}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1E4708),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1, color: Colors.black),
                  SizedBox(height: 10),

                  // Agrupar e exibir atividades por data
                  ...agrupadas.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(entry.key))}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        ...entry.value.map(
                          (a) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${a.tipo}: ${a.duracaoMinutos}min - R\$ ${a.valor.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  widget.onDelete(
                                    a,
                                  ); // Chama a função de exclusão
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.black),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
