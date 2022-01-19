import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';

class InsertTodos extends StatefulWidget {
  const InsertTodos({Key? key}) : super(key: key);

  @override
  _InsertTodoState createState() => _InsertTodoState();
}

class _InsertTodoState extends State<InsertTodos> {
  late DatabaseHandler handler;
  late DateTime? _selectedTime;

  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late StreamController<String> nameStreamController;
  late StreamController<String> descStreamController;

  late bool _isEnable;

//Data
  Future<int> addTodo() async {
    Todos firstTodo = Todos(
        name: nameController.text,
        desc: descController.text,
        state: 0,
        datetime: _selectedTime!);
    return await handler.insertTodos([firstTodo]);
  }

//Widget

  Color streamColor(Object? obj, FocusNode focus) {
    String text = obj.toString().trim();
    if (focus.hasFocus == true) {
      if (text.isEmpty) {
        _isEnable = false;
        return Colors.redAccent;
      } else {
        nameController.text.trim().isNotEmpty &&
                descController.text.trim().isNotEmpty
            ? _isEnable = true
            : _isEnable = false;
        return Colors.blueAccent;
      }
    } else if (focus.hasFocus && text.isEmpty) {
      return black55;
    } else {
      return black55;
    }
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _selectedTime = DateTime.now();
    nameStreamController = StreamController<String>.broadcast();
    descStreamController = StreamController<String>.broadcast();

    _isEnable = false;

    nameController.addListener(() {
      nameStreamController.sink.add(nameController.text.trim());
    });

    descController.addListener(() {
      descStreamController.sink.add(descController.text.trim());
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameStreamController.close();
    descStreamController.close();
    nameController.dispose();
    descController.dispose();
  }

  Widget _drawNameFIeld() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      child: StreamBuilder(
          stream: nameStreamController.stream,
          builder: (context, snapshot) {
            return TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              textInputAction: TextInputAction.go,
              onChanged: (value) {},
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(descFocus),
              decoration: InputDecoration(
                  labelText: "Task Name", //'Details'
                  labelStyle: bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: tertiaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  hintText:
                      "Enter your task here....", //'Enter a description here...'
                  hintStyle: bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: tertiaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: streamColor(snapshot.data, nameFocus),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: streamColor(snapshot.data, nameFocus),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  )),
              style: bodyText1,
            );
          }),
    );
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
                        'Add Task',
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
                _drawNameFIeld(),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: StreamBuilder(
                      stream: descStreamController.stream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: descController,
                          focusNode: descFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) => addTaskAction,
                          decoration: InputDecoration(
                              labelText: "Details", //'Details'
                              labelStyle: bodyText1.override(
                                fontFamily: 'Lexend Deca',
                                color: tertiaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              hintText:
                                  "Enter a description here...", //'Enter a description here...'
                              hintStyle: bodyText1.override(
                                fontFamily: 'Lexend Deca',
                                color: tertiaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: streamColor(snapshot.data, descFocus),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: streamColor(snapshot.data, descFocus),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              )),
                          style: bodyText1,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                        );
                      }),
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
                          );

                          selectedDate.then((dateTime) {
                            setState(() {
                              _selectedTime = dateTime;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 0),
                          child: Text(
                            DateFormat.yMMMd()
                                .format(_selectedTime ?? DateTime.now()),
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
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: _isEnable ? addTaskAction : null,
                            child: const Text("Creat Task")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void addTaskAction() async {
    addTodo();
    Navigator.pop(context);
  }
} // _InsertTodoState

