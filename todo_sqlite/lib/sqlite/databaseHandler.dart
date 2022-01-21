import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqlite/util.dart';
import 'todos.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler._internal() {
    initializeDB();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todo.db'),
      onCreate: (database, version) async {
        await database.execute(
            "create table todos(id integer primary key autoincrement, name text, desc text, state integer, datetime integer)");
      },
      version: 1,
    );
  }

  Future<int> insertTodos(List<Todos> todos) async {
    int result = 0;
    final Database db = await initializeDB();

    for (var todo in todos) {
      result = await db.rawInsert(
          'insert into todos(name, desc, state, datetime) values (?,?,?,?)', [
        todo.name,
        todo.desc,
        0,
        dateTimeFormat("yyyy-MM-dd", todo.datetime)
      ]);
    }
    return result;
  }

  Future<List<Todos>> queryTodos() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from todos');
    return queryResult.map((e) => Todos.fromMap(e)).toList();
  }

  Stream<List<Todos>> queryDateTodos(DateTime date) async* {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from todos where datetime = ?',
        [dateTimeFormat("yyyy-MM-dd", date)]);

    queryResult.map((e) => print);
    yield queryResult.map((e) => Todos.fromMap(e)).toList();
  }

  Future<void> deleteTodos(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from todos where id = ?', [id]);
  }

  Future<void> deleteMutiTodos(List<int> ids) async {
    final Database db = await initializeDB();
    for (int id in ids) {
      await db.rawDelete('delete from todos where id = ?', [id]);
    }
  }

  Future<int> updateTodos(List<Todos> todos) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var todo in todos) {
      result = await db.rawUpdate(
          'update todos set name = ?, desc = ?, state = ?, datetime = ? where id = ?',
          [
            todo.name,
            todo.desc,
            todo.state,
            dateTimeFormat("yyyy-MM-dd", todo.datetime),
            todo.id
          ]);
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
