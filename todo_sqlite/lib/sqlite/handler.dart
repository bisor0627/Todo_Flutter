import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todos.dart';

class Handler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todos.db'),
      onCreate: (database, version) async {
        await database.execute(
            "create table todos(id integer primary key autoincrement, todoName text, todoDesc text, todoState boolean)");
      },
      version: 1,
    );
  }

  Future<int> insertTodos(Todos todos) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'insert into todos(todoName, todoDesc, todoState) values (?,?,?,?)',
        [todos.todoName, todos.todoDesc, todos.todoState]);

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
    for (var todo in todos) {
      result = await db.rawUpdate(
          'update todos set todoName = ?, todoDesc = ?, todoState = ? where id = ?',
          [todo.todoName, todo.todoDesc, todo.todoState, todo.id]);
    }
    return result;
  }
} // <<<<