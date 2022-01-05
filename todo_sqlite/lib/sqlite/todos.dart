class Todos {
  final int? id;
  final String name;
  final String desc;
  final int state;

  Todos({this.id, required this.name, required this.desc, required this.state});

  Todos.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        desc = res['desc'],
        state = res['state'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'desc': desc, 'state': state};
  }
}
