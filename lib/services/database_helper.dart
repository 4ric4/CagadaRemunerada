import 'dart:convert'; // Para converter dados para String e vice-versa
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para Web
import 'package:sqflite/sqflite.dart'; // Para SQLite no mobile
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Para SQLite na Web

class DatabaseHelper {
  Database? _db;

  // Instancia o banco de dados dependendo do ambiente
  Future<Database> getDatabase() async {
    if (kIsWeb) {
      // Web: Usamos SharedPreferences ou IndexedDB
      return Future.value(
        null,
      ); // Não usaremos SQLite aqui, ou podemos usar localStorage
    } else {
      // Mobile: Usamos SQLite
      if (_db == null) {
        _db = await openDatabase(
          'atividade.db',
          version: 1,
          onCreate: (db, version) {
            db.execute('''
              CREATE TABLE atividades(
                id INTEGER PRIMARY KEY,
                tipo TEXT,
                valor REAL,
                duracaoMinutos INTEGER,
                data TEXT
              )
            ''');
          },
        );
      }
      return _db!;
    }
  }

  // Salva dados no banco SQLite ou SharedPreferences
  Future<void> saveData(String tipo, String valor) async {
    if (kIsWeb) {
      // Web: Armazenar no SharedPreferences (ou IndexedDB)
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> atividades =
          await fetchData(); // Carrega atividades salvas
      atividades.add({
        'tipo': tipo,
        'valor': valor,
        'duracaoMinutos': 60,
        'data': DateTime.now().toIso8601String(),
      });
      // Convertendo a lista de atividades para JSON para armazenar como string
      prefs.setString('atividades', json.encode(atividades));
    } else {
      // Mobile: Armazenar no SQLite
      final db = await getDatabase();
      await db.insert('atividades', {
        'tipo': tipo,
        'valor': double.parse(valor),
        'duracaoMinutos': 60,
        'data': DateTime.now().toIso8601String(),
      });
    }
  }

  // Buscar dados do banco SQLite (ou SharedPreferences)
  Future<List<Map<String, dynamic>>> fetchData() async {
    if (kIsWeb) {
      // Web: Recuperar do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString('atividades');
      if (data != null) {
        // Convertendo de volta de String para List<Map>
        List<dynamic> jsonData = json.decode(data);
        return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return [];
    } else {
      // Mobile: Recuperar do SQLite
      final db = await getDatabase();
      return db.query('atividades');
    }
  }
}
