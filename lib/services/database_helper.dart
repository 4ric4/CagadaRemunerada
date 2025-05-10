import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:idb_shim/idb.dart' as idb;
import 'package:idb_shim/idb_browser.dart' as idb_browser;

/// Interface
abstract class StorageService {
  Future<void> init();
  Future<void> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAll(String table);
  Future<void> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List whereArgs,
  );
  Future<void> delete(String table, String where, List whereArgs);
}

/// Implementação do Storage para Mobile/Web
class DatabaseHelper implements StorageService {
  sqflite.Database? _sqliteDb;
  idb.Database? _indexedDb;
  final idb.IdbFactory _idbFactory = idb_browser.idbFactoryBrowser;

  @override
  Future<void> init() async {
    if (kIsWeb) {
      _indexedDb ??= await _idbFactory.open(
        'atividades_db',
        version: 2,
        onUpgradeNeeded: (e) {
          final db = e.database;
          if (!db.objectStoreNames.contains('atividades')) {
            db.createObjectStore('atividades', autoIncrement: true);
          }
          if (!db.objectStoreNames.contains('user_setting')) {
            db.createObjectStore('user_setting', autoIncrement: true);
          }
          if (!db.objectStoreNames.contains('historico')) {
            db.createObjectStore('historico', autoIncrement: true);
          }
          if (!db.objectStoreNames.contains('cadastro_salario')) {
            db.createObjectStore('cadastro_salario', autoIncrement: true);
          }
          if (!db.objectStoreNames.contains('registro_atividade')) {
            db.createObjectStore('registro_atividade', autoIncrement: true);
          }
        },
      );
    } else {
      _sqliteDb ??= await sqflite.openDatabase(
        'atividade.db',
        version: 2, // Atualize a versão do banco de dados
        onCreate: (db, version) async {
          await db.execute('''
              CREATE TABLE atividades(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                tipo TEXT,
                valor REAL,
                duracaoMinutos INTEGER,
                data TEXT
              )
            ''');
          await db.execute('''
              CREATE TABLE user_setting (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                salario REAL,
                dias_trabalho INTEGER,
                horas_por_dia REAL
              )
            ''');
          await db.execute('''
              CREATE TABLE historico(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                descricao TEXT,
                data TEXT
              )
            ''');
          await db.execute('''
              CREATE TABLE cadastro_salario(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                salario REAL,
                dataInicio TEXT,
                UNIQUE(salario, dataInicio)
              )
              )
            ''');
          await db.execute('''
              CREATE TABLE registro_atividade(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                atividadeId INTEGER,
                dataRegistro TEXT
              )
            ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            // Adicione aqui a criação das tabelas se estiverem faltando
            await db.execute('''
              CREATE TABLE IF NOT EXISTS user_setting (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                salario REAL,
                dias_trabalho INTEGER,
                horas_por_dia REAL
              )
            ''');
          }
        },
      );
    }
  }

  @override
  Future<void> insert(String table, Map<String, dynamic> data) async {
    await init();

    if (kIsWeb) {
      final db = _indexedDb!;
      final txn = db.transaction(table, idb.idbModeReadWrite);
      final store = txn.objectStore(table);
      await store.add(data);
      await txn.completed;
    } else {
      final db = _sqliteDb!;
      await db.insert(table, data);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    await init(); // Garantindo que o banco foi inicializado

    if (kIsWeb) {
      final db = _indexedDb!;
      final txn = db.transaction(table, idb.idbModeReadOnly);
      final store = txn.objectStore(table);
      final allItems = await store.getAll();
      await txn.completed;
      return allItems.cast<Map<String, dynamic>>();
    } else {
      final db = _sqliteDb!;
      return db.query(table);
    }
  }

  @override
  Future<void> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List whereArgs,
  ) async {
    await init(); // Garantindo que o banco foi inicializado

    if (kIsWeb) {
      // ID obrigatório para update no IndexedDB
      if (!data.containsKey('id')) {
        throw Exception('ID necessário para update no Web!');
      }

      final db = _indexedDb!;
      final txn = db.transaction(table, idb.idbModeReadWrite);
      final store = txn.objectStore(table);
      await store.put(data, data['id']);
      await txn.completed;
    } else {
      final db = _sqliteDb!;
      await db.update(table, data, where: where, whereArgs: whereArgs);
    }
  }

  @override
  Future<void> delete(String table, String where, List whereArgs) async {
    await init(); // Garantindo que o banco foi inicializado

    if (kIsWeb) {
      final db = _indexedDb!;
      final txn = db.transaction(table, idb.idbModeReadWrite);
      final store = txn.objectStore(table);
      var id = whereArgs.first;
      await store.delete(id);
      await txn.completed;
    } else {
      final db = _sqliteDb!;
      await db.delete(table, where: where, whereArgs: whereArgs);
    }
  }
}
