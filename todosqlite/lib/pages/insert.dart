import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todosqlite/config/constant.dart';
import 'package:todosqlite/sqlite/databaseHandler.dart';
import 'package:todosqlite/sqlite/todos.dart';

class InsertTodos extends StatefulWidget {
  const InsertTodos({Key? key}) : super(key: key);

  @override
  _InsertTodoState createState() => _InsertTodoState();
}

class _InsertTodoState extends State<InsertTodos> {
  late DatabaseHandler handler;
  late DateTime datePicked;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late String name;
  late String desc;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Add Task',
                        style: title2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Fill out the details below to add a new task.',
                          style: bodyText1.override(
                            fontFamily: 'Lexend Deca',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: tertiaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: TextFormField(
                    controller: nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      hintText: 'Enter your task here....',
                      hintStyle: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: black55,
                    ),
                    style: bodyText1,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: TextFormField(
                    controller: descController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      labelStyle: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      hintText: 'Enter a description here...',
                      hintStyle: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: black55,
                    ),
                    style: bodyText1,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: InkWell(
                    onTap: () async {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      height: 50,
                      decoration: BoxDecoration(
                        color: black55,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: black55,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 14, 0, 0),
                        child: Text(
                          // dateTimeFormat('MMMEd', datePicked),
                          "Sample",
                          style: bodyText1.override(
                            fontFamily: 'Lexend Deca',
                            color: tertiaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                      ),
                      Container(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              addTodo();
                              Navigator.pop(context);
                            },
                            child: Text("Creat Task")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<int> addTodo() async {
    Todos firstTodo =
        Todos(name: nameController.text, desc: descController.text, state: 0);

    return await handler.insertTodos([firstTodo]);
  }
} // _InsertTodoState

 
