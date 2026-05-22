import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/saved_scan_model.dart';

class ScanStorageService {
  static final ScanStorageService _instance = ScanStorageService._internal();
  static Database? _database;

  factory ScanStorageService() {
    return _instance;
  }

  ScanStorageService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'buyo_scans.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT NOT NULL,
        diseaseName TEXT NOT NULL,
        severityLevel TEXT NOT NULL,
        confidence REAL NOT NULL,
        classification TEXT NOT NULL,
        recommendations TEXT NOT NULL,
        actionNeeded TEXT NOT NULL,
        accentColor INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<SavedScan> saveScan(
    String imagePath,
    Uint8List imageBytes,
    String diseaseName,
    String severityLevel,
    double confidence,
    String classification,
    List<String> recommendations,
    String actionNeeded,
    int accentColor,
  ) async {
    final db = await database;
    final recommendationsJson = recommendations.join('|||');

    final id = await db.insert('saved_scans', {
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'severityLevel': severityLevel,
      'confidence': confidence,
      'classification': classification,
      'recommendations': recommendationsJson,
      'actionNeeded': actionNeeded,
      'accentColor': accentColor,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return SavedScan(
      id: id,
      imagePath: imagePath,
      imageBytes: imageBytes,
      diseaseName: diseaseName,
      severityLevel: severityLevel,
      confidence: confidence,
      classification: classification,
      recommendations: recommendationsJson,
      actionNeeded: actionNeeded,
      accentColor: accentColor,
      createdAt: DateTime.now(),
    );
  }

  Future<List<SavedScan>> getAllScans() async {
    final db = await database;
    final maps = await db.query(
      'saved_scans',
      orderBy: 'createdAt DESC',
    );

    final scans = <SavedScan>[];
    for (final map in maps) {
      final imagePath = map['imagePath'] as String;
      final imageBytes = await _loadImageBytes(imagePath);
      if (imageBytes != null) {
        scans.add(SavedScan.fromMap(map, imageBytes));
      }
    }
    return scans;
  }

  Future<SavedScan?> getScanById(int id) async {
    final db = await database;
    final maps = await db.query(
      'saved_scans',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final imagePath = maps[0]['imagePath'] as String;
      final imageBytes = await _loadImageBytes(imagePath);
      if (imageBytes != null) {
        return SavedScan.fromMap(maps[0], imageBytes);
      }
    }
    return null;
  }

  Future<void> deleteScan(int id) async {
    final db = await database;
    final scan = await getScanById(id);
    if (scan != null) {
      await _deleteImageFile(scan.imagePath);
      await db.delete(
        'saved_scans',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<SavedScan>> getScansByClassification(String classification) async {
    final db = await database;
    final maps = await db.query(
      'saved_scans',
      where: 'classification = ?',
      whereArgs: [classification],
      orderBy: 'createdAt DESC',
    );

    final scans = <SavedScan>[];
    for (final map in maps) {
      final imagePath = map['imagePath'] as String;
      final imageBytes = await _loadImageBytes(imagePath);
      if (imageBytes != null) {
        scans.add(SavedScan.fromMap(map, imageBytes));
      }
    }
    return scans;
  }

  Future<Uint8List?> _loadImageBytes(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    return null;
  }

  Future<void> _deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
