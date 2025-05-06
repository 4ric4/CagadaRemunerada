import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Adicionado
import '../models/user_settings.dart';
import '../models/atividade.dart';

class RegistroAtividades extends StatefulWidget {
  final UserSettings userSettings;
  final Function(Atividade) onAdd;

  const RegistroAtividades({
    required this.userSettings,
    required this.onAdd,
    super.key,
  });

  @override
  State<RegistroAtividades> createState() => _RegistroAtividadesState();
}

class _RegistroAtividadesState extends State<RegistroAtividades> {
  final TextEditingController _tempoController = TextEditingController();
  String? _diaSelecionado;
  String _tipoSelecionado = 'Cagada';

  final List<String> _diasSemana = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  DateTime _ultimaOcorrencia(String dia) {
    int hoje = DateTime.now().weekday;
    int alvo = _diasSemana.indexOf(dia);
    int alvoFlutter = alvo == 0 ? 7 : alvo;
    int diferenca = hoje - alvoFlutter;
    if (diferenca < 0) diferenca += 7;
    return DateTime.now().subtract(Duration(days: diferenca));
  }

  void _registrar() {
    final minutos = int.tryParse(_tempoController.text);
    if (minutos == null || minutos <= 0 || _diaSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha o tempo e escolha o dia da semana."),
        ),
      );
      return;
    }

    final valor = widget.userSettings.valorHora * (minutos / 60);
    final data = _ultimaOcorrencia(_diaSelecionado!);

    final atividade = Atividade(
      tipo: _tipoSelecionado,
      duracaoMinutos: minutos,
      data: data,
      valor: valor,
    );

    widget.onAdd(atividade);
    _tempoController.clear();
    setState(() {
      _diaSelecionado = null;
      _tipoSelecionado = 'Cagada';
    });
  }

  Widget _buildBotaoTipo(String tipo) {
    final bool selecionado = _tipoSelecionado == tipo;
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            setState(() => _tipoSelecionado = tipo);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selecionado ? Colors.greenAccent[400] : Colors.green[900],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            tipo,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final double maxContainerWidth = isMobile ? double.infinity : 950;
    final EdgeInsetsGeometry padding =
        isMobile
            ? const EdgeInsets.all(16)
            : const EdgeInsets.symmetric(vertical: 32, horizontal: 24);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          width: maxContainerWidth,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Registrar ',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.green[900],
                      ),
                    ),
                    const TextSpan(
                      text: 'Atividade',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBotaoTipo('Cagada'),
                  const SizedBox(width: 8),
                  _buildBotaoTipo('Mijada'),
                  const SizedBox(width: 8),
                  _buildBotaoTipo('Redes Sociais'),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                // Limita a altura do dropdown
                constraints: BoxConstraints(maxHeight: 200),
                child: DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    labelText: "Dia da Semana",
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  isExpanded: true,
                  value: _diaSelecionado,
                  items:
                      _diasSemana
                          .map(
                            (dia) => DropdownMenuItem(
                              value: dia,
                              child: Text(
                                dia,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (valor) => setState(() => _diaSelecionado = valor),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: TextField(
                  controller: _tempoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.access_time),
                    hintText: 'Tempo em minutos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: isMobile ? double.infinity : 154,
                height: 60,
                child: ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Registrar Atividade',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
