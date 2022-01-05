class Todos {
  int? id;
  String name;
  String desc;
  late int state;

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
