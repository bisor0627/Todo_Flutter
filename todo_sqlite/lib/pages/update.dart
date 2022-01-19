import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';
import 'package:intl/intl.dart';

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
  late DateTime _selectedTime;

// Create Constructor
  _UpdateTodosState(Todos rtodo);

  @override
  void initState() {
    super.initState();
    print("todoData id!");
    print(widget.rtodo.id);
    nameController.text = widget.rtodo.name;
    descController.text = widget.rtodo.desc;
    _selectedTime = widget.rtodo.datetime;

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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Update Task',
                        style: title2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Update your task.',
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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Task title",
                      labelStyle: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: "description",
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
                        borderSide: const BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black55,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: bodyText1,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: InkWell(
                    onTap: () async {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: black55,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Future<DateTime?> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), // 초깃값
                            firstDate: DateTime(2018), // 시작일
                            lastDate: DateTime(2030), // 마지막일
                            // builder: (BuildContext context, Widget? child) {
                            //   return Theme(
                            //     data: ThemeData.dark(), // 다크테마
                            //   );
                            // },
                          );

                          selectedDate.then((dateTime) {
                            setState(() {
                              _selectedTime = dateTime!;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 0),
                          child: Text(
                            DateFormat.yMMMd().format(_selectedTime),
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
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
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
                            child: const Text("Cancel")),
                      ),
                      Container(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              updateTodo();
                              // Navigator.pop(context);
                            },
                            child: const Text("Update Task")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<int> updateTodo() async {
    Todos firstTodo = Todos(
        id: widget.rtodo.id,
        name: nameController.text,
        desc: descController.text,
        state: widget.rtodo.state,
        datetime: _selectedTime);
    return await handler.updateTodos([firstTodo]);
  }
}
