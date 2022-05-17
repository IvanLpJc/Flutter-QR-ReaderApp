import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;

  /**
   * i El guión bajo después del punto indica que es un constructor
   * i privado
   */

  static final DBProvider db = DBProvider._();

  /**
   * i Así siempre obtenemos la misma instancia de la db
   */
  DBProvider._();

  /**
   * Es async porque la lectura de la db no es sincrona
   */
  Future<Database?> get database async {
    /**
     * Indicamos que si ya está instanciada la base de datos, queremos que 
     * devuelva exactamente la misma
     */
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    //* Path para almacenar la db, el cual será el espacio del dispositivo
    //* asignado para nuestra app
    //C:\Users\malve\AppData\Local\Google\AndroidStudio2021.1\device-explorer\Note-10_API_30 [emulator-5554]\data\user\0\com.example.qr_reader\app_flutter
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    /**
     * El join lo importamos de path/path.dart para unir strings
     * Así vamos a crear el path para el archivo de base de datos
     */
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //* Creación de la DB
    /**
     * version: versión de la db que hay que incrementar cuando se haga algún
     * cambios estructurales en la base de datos (borrar tablas, crear nuevas...)
     * *Porqué? 
     * Cuando el método de openDatabase se ejecuta, si tiene la misma
     * versión, no ejecutará las rutinas de creación/borrado/etc
     */
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Que se hará cuando se cree la base de datos
      await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          );
        ''');
    });
  }

  //* Forma 1 de añadir datos
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    // Verificar la base de datos
    final db = await database;

    final response = await db!.rawInsert('''
      INSERT INTO Scans( id, tipo, valor)
        VALUES ($id, '$tipo', '$valor')
    ''');

    return response;
  }

  //* Forma 2 (más sencillo)

  Future<int?> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;

    final response = await db!.insert('Scans', nuevoScan.toJson());
    print(response);
    return response;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;

    final response = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    return response.isNotEmpty ? ScanModel.fromJson(response.first) : null;
  }

  Future<List<ScanModel>?> getAllScans() async {
    final db = await database;

    final response = await db!.query('Scans');

    return response.isNotEmpty
        ? response.map((scan) => ScanModel.fromJson(scan)).toList()
        : null;
  }

  Future<List<ScanModel>> getScansByType(String tipo) async {
    final db = await database;

    final response =
        await db!.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    return response.isNotEmpty
        ? response.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

  Future<int> updateScan(ScanModel updatedScan) async {
    final db = await database;

    final response = await db!.update('Scans', updatedScan.toJson(),
        where: 'id = ?', whereArgs: [updatedScan.id]);

    return response;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final response =
        await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return response;
  }

  Future<int> deleteAllScan() async {
    final db = await database;
    final response = await db!.delete('Scans');
    return response;
  }
}
