import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = path.join(await sql.getDatabasesPath(), 'friends.db');
    return sql.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE friends_table (id TEXT PRIMARY KEY, name TEXT, about TEXT, rating INTEGER, image TEXT, wNumber TEXT, birthDay TEXT)');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDb = await DBHelper.database();
    return sqlDb.query(table);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(String table, Map<String, dynamic> data) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  static Future<void> delete(String table, String id) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
