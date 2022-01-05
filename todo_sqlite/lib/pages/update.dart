import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';

class Repo {
  static late Todos todoData;
}

class UpdateTodos extends StatefulWidget {
  final Todos rtodo;

  const UpdateTodos({Key? key, required this.rtodo}) : super(key: key);

  @override
  _UpdateTodosState createState() => _UpdateTodosState(rtodo);
}

class _UpdateTodosState extends State<UpdateTodos> {
  late DatabaseHandler handler;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

// Create Constructor
  _UpdateTodosState(Todos rtodo) {
    Repo.todoData = rtodo;
  }
  late String result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = Repo.todoData.name;
    descController.text = Repo.todoData.desc;

    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      Repo.todoData.name,
                      style: title1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(Repo.todoData.desc,
                        style: bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: tertiaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 16,
              endIndent: 16,
              color: black55,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      'Due',
                      style: subtitle1,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (Repo.todoData.state == 0) {
                  setState(() {
                    Repo.todoData.state = 1;
                  });
                } else {
                  setState(() {
                    Repo.todoData.state = 0;
                  });
                }
              },
              icon: Icon(
                Repo.todoData.state == 0
                    ? Icons.radio_button_off
                    : Icons.check_circle,
                color: primarycolor,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
} // _UpdateTodosState

