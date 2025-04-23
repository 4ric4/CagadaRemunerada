import 'package:flutter/material.dart';
import 'screens/cadastro_salario.dart';
import 'screens/registro_atividades.dart';
import 'screens/historico.dart';
import 'screens/dashboard.dart';
import 'screens/splash_screen.dart';
import 'models/user_settings.dart';
import 'models/atividade.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class MyApp extends StatefulWidget {
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserSettings? userSettings;
  List<Atividade> atividades = [];
  int _selectedIndex = 0;

  void setUserSettings(UserSettings settings) {
    setState(() {
      userSettings = settings;
      _selectedIndex = 0; // Vai para Registro após cadastrar salário
    });
  }

  void addAtividade(Atividade atividade) {
    setState(() {
      atividades.add(atividade);
    });
  }

  // Função de deletar atividade
  void deleteAtividade(Atividade atividade) {
    setState(() {
      atividades.remove(atividade);
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.png'), // Caminho da imagem
              fit: BoxFit.cover, // Faz a imagem cobrir toda a tela
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(
                  0xFF1E4708,
                ).withOpacity(0.8), // Cor verde escura com transparência
                Color(
                  0xFF39EE3F,
                ).withOpacity(0.8), // Cor verde clara com transparência
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildRegistroAtividades(),
              _buildHistorico(),
              _buildDashboard(),
              _buildCadastroSalario(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar),
              label: 'Registrar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histórico',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
            if (userSettings != null)
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Editar Salário',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistroAtividades() {
    return userSettings == null
        ? CadastroSalario(onSave: setUserSettings)
        : SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: RegistroAtividades(
            userSettings: userSettings!,
            onAdd: addAtividade,
          ),
        );
  }

  Widget _buildHistorico() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Historico(
        atividades: atividades,
        onDelete:
            deleteAtividade, // Passando a função de deletar para o histórico
      ),
    );
  }

  Widget _buildDashboard() {
    return DashboardGrafico(atividades: atividades);
  }

  Widget _buildCadastroSalario() {
    return CadastroSalario(onSave: setUserSettings);
  }
}
