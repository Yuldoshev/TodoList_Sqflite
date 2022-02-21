import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_sqflite/model/model.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE todos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          model TEXT,
          creationDate TEXT
        )

      ''');
      },
      version: 1,
    );
  }

  addNewTodo(Model newModel) async {
    final db = await database;
    await db!.insert(
      'todos',
      newModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getModel() async {
    final db = await database;
    var res = await db!.query('todos');
    if (res.isEmpty) {
      return null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }
}
