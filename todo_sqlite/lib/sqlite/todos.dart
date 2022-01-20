class Todos {
  int? id;
  late String name;
  late String desc;
  late int state;
  late DateTime datetime;

  Todos(
      {this.id,
      required this.name,
      required this.desc,
      required this.state,
      required this.datetime});

  Todos.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    name = res['name'];
    desc = res['desc'];
    state = res['state'];
    datetime = DateTime.parse(res['datetime'].toString());
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'state': state,
      'datetime': datetime
    };
  }
}
