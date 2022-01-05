import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todos.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todo.db'),
      onCreate: (database, version) async {
        await database.execute(
            "create table todos(id integer primary key autoincrement, name text, desc text, state integer)");
      },
      version: 1,
    );
  }

  Future<int> insertTodos(List<Todos> todos) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var student in todos) {
      result = await db.rawInsert(
          'insert into todos(name, desc, state) values (?,?,?)',
          [student.name, student.desc, 0]);
    }
    return result;
  }

  Future<List<Todos>> queryTodos() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from todos');
    return queryResult.map((e) => Todos.fromMap(e)).toList();
  }

  Future<void> deleteTodos(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from todos where id = ?', [id]);
  }

  Future<int> updateTodos(List<Todos> todos) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var student in todos) {
      result = await db.rawUpdate(
          'update todos set name = ?, desc = ?, state = ? where id = ?',
          [student.name, student.desc, student.state, student.id]);
    }
    return result;
  }

  Future<int> updateState(int? id, int state) async {
    int result = 0;
    final Database db = await initializeDB();

    result = await db.rawUpdate(
        'update todos set state = ? where id = ?', [state == 0 ? 1 : 0, id]);

    return result;
  }
} // DatabaseHandler
