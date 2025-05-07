import 'package:flutter/material.dart';
import '../models/atividade.dart';
import 'package:intl/intl.dart';
import 'package:cagada_remunerada/services/database_helper.dart';

class Historico extends StatefulWidget {
  final List<Atividade> atividades;
  final Function(Atividade) onDelete;

  Historico({required this.atividades, required this.onDelete});

  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  String? tipoSelecionado = 'diario';

  final StorageService _storageService = DatabaseHelper();

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

  void _excluirAtividade(Atividade atividade) async {
    await _storageService.delete('atividades', 'id = ?', [atividade.id]);
    widget.onDelete(atividade);
  }

  @override
  Widget build(BuildContext context) {
    List<Atividade> atividadesFiltradas = _filtrarAtividades(tipoSelecionado);

    // Agrupar por data
    Map<String, List<Atividade>> agrupadas = {};
    for (var a in atividadesFiltradas) {
      String dia = DateFormat('yyyy-MM-dd').format(a.data);
      agrupadas.putIfAbsent(dia, () => []).add(a);
    }

    double totalGeral = atividadesFiltradas.fold(0, (sum, a) => sum + a.valor);

    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxSize = constraints.biggest.shortestSide.clamp(300, 686);

          return Center(
            child: Container(
              width: maxSize,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Linha com Dropdown no lado esquerdo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown filtro
                        Container(
                          width: 171,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E4708),
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                      ],
                    ),
                    SizedBox(height: 20),

                    // Container com borda fina
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                          // Lista de atividades agrupadas com rolagem
                          Container(
                            height:
                                atividadesFiltradas.length > 4
                                    ? 300
                                    : null, // Ajusta a altura
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...agrupadas.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  _excluirAtividade(a);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Alinha o total à direita
                      children: [
                        Text(
                          "Total gerado: R\$ ${totalGeral.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF39EE3F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
