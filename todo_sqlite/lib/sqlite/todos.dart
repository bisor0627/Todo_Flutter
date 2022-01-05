class Todos {
  final int? id;
  // final DateTime todoDate;
  final String todoName;
  final String todoDesc;
  final bool todoState;

  Todos(
      {this.id,
      // required this.todoDate,
      required this.todoName,
      required this.todoDesc,
      required this.todoState});

  Todos.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        // todoDate = res['todoDate'],
        todoName = res['todoName'],
        todoDesc = res['todoDesc'],
        todoState = res['todoState'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      // 'todoDate': todoDate,
      'todoName': todoName,
      'todoDesc': todoDesc,
      'todoState': todoState
    };
  }
}
