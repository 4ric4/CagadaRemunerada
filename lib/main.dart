import 'package:cagada_remunerada/services/database_helper.dart';
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

  // Inicializando o banco de dados
  await DatabaseHelper().init();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class MyApp extends StatefulWidget {
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserSettings? userSettings;
  List<Atividade> atividades = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Carregar dados persistidos
  void _loadData() async {
    // Carregar as configurações do usuário
    final userSettingsList = await DatabaseHelper().getAll('user_setting');
    if (userSettingsList.isNotEmpty) {
      setState(() {
        userSettings = UserSettings.fromMap(userSettingsList.first);
      });
    }

    // Carregar as atividades registradas
    final atividadesList = await DatabaseHelper().getAll('atividades');
    setState(() {
      atividades =
          atividadesList
              .map((e) => Atividade.fromMap(e))
              .toList(); // Convertendo para objetos Atividade
    });
  }

  void setUserSettings(UserSettings settings) async {
    setState(() {
      userSettings = settings;
      _selectedIndex = 0; // Vai para Registro após cadastrar salário
    });

    // Salvando as configurações no banco de dados
    await DatabaseHelper().insert('user_setting', settings.toMap());
  }

  void addAtividade(Atividade atividade) async {
    setState(() {
      atividades.add(atividade);
    });

    // Salvando a atividade no banco de dados
    await DatabaseHelper().insert('atividades', atividade.toMap());
  }

  // Função de deletar atividade
  void deleteAtividade(Atividade atividade) async {
    setState(() {
      atividades.remove(atividade);
    });

    // Deletando a atividade do banco de dados
    await DatabaseHelper().delete('atividades', 'id = ?', [atividade.id]);
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
                Color(0xFF1E4708).withOpacity(0.8),
                Color(0xFF39EE3F).withOpacity(0.8),
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
