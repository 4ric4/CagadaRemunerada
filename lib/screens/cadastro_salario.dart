import 'package:cagada_remunerada/screens/registro_atividades.dart';
import 'package:cagada_remunerada/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_settings.dart';

class CadastroSalario extends StatefulWidget {
  final Function(UserSettings) onSave;

  CadastroSalario({required this.onSave});

  @override
  _CadastroSalarioState createState() => _CadastroSalarioState();
}

class _CadastroSalarioState extends State<CadastroSalario>
    with SingleTickerProviderStateMixin {
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _diasController = TextEditingController();
  final TextEditingController _horasController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _salarioController.dispose();
    _diasController.dispose();
    _horasController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    try {
      final salario = double.tryParse(_salarioController.text);
      final dias = int.tryParse(_diasController.text);
      final horas = double.tryParse(_horasController.text);

      if (salario != null && dias != null && horas != null) {
        final settings = UserSettings(
          salarioMensal: salario,
          diasTrabalho: dias,
          horasPorDia: horas,
        );

        // Salvar no banco de dados
        final dbHelper = DatabaseHelper();
        await dbHelper.insert("user_setting", {
          "salario": salario,
          "dias_trabalho": dias,
          "horas_por_dia": horas,
        });

        widget.onSave(settings);

        // Usar Future.delayed para atrasar a navegação
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => RegistroAtividades(
                    userSettings: settings,
                    onAdd: (atividade) {},
                  ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Preencha todos os campos corretamente")),
        );
      }
    } catch (e) {
      // Se houver um erro, logue ele
      print("Erro ao salvar dados: $e");
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(),
      prefixIcon: Icon(icon, color: Color(0xFF1E4708)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF1E4708), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF1E4708), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 950 ? 950.0 : screenWidth * 0.9;
    final containerHeight = 550.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/splash.png', fit: BoxFit.cover),
          Container(color: Color(0xFF39EE3F).withOpacity(0.4)),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: containerWidth,
                height: containerHeight,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Ganho Diário",
                        style: GoogleFonts.montserrat(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _salarioController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          'Salário Mensal',
                          Icons.attach_money,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _diasController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          'Dias de Trabalho por Semana',
                          Icons.calendar_today,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _horasController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          'Horas de Trabalho por Dia',
                          Icons.access_time,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E4708),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Salvar Configurações',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
