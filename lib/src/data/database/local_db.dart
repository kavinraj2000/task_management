import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {
  static final LocalDb instance = LocalDb._internal();
  static Database? _db;

  LocalDb._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_manager.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        dueDate INTEGER,
        status TEXT,
        priority TEXT,
        createdAt INTEGER,
        updatedAt INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final columns = await db.rawQuery("PRAGMA table_info(tasks)");

      final columnNames = columns.map((e) => e['name']).toList();

      if (!columnNames.contains('updatedAt')) {
        await db.execute('ALTER TABLE tasks ADD COLUMN updatedAt INTEGER');
      }
    }
  }
}
