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
// ! Variable
  late DatabaseHandler handler;
  late DateTime? _selectedTime;

  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late StreamController<String> nameStreamController;
  late StreamController<String> descStreamController;
late btnStreamController = StreamController<bool>();
  late Stream<int> testStream = countStream(30);

// ! Actions
  Future<int> addTodo() async {
    Todos firstTodo = Todos(
        name: nameController.text,
        desc: descController.text,
        state: 0,
        datetime: _selectedTime!);
    return await handler.insertTodos([firstTodo]);
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  Stream<bool> btnStream(int to) async* {
    bool state = false;
    nameController.addListener(() {
      state = descController.text.trim().isNotEmpty &&
          nameController.text.trim().isNotEmpty;
    });
    descController.addListener(() {
      state = descController.text.trim().isNotEmpty &&
          nameController.text.trim().isNotEmpty;
    });
    yield state;
  }

  void controllerActions() {
    nameStreamController = StreamController<String>.broadcast();
    descStreamController = StreamController<String>.broadcast();
    
    nameController.addListener(() {
      nameStreamController.sink.add(nameController.text.trim());
      // btnStreamController.sink.add(descController.text.trim().isNotEmpty &&
      // nameController.text.trim().isNotEmpty);
    });
    descController.addListener(() {
      descStreamController.sink.add(descController.text.trim());
      // btnStreamController.sink.add(descController.text.trim().isNotEmpty &&
      // nameController.text.trim().isNotEmpty);
    });
  }

  void closeActions() {
    nameStreamController.close();
    descStreamController.close();
    btnStreamController.close();
    nameController.dispose();
    descController.dispose();
  }

  void addTaskAction() async {
    addTodo();
    Navigator.pop(context);
  }

  Color streamColor(Object? obj, FocusNode focus) {
    String text = obj.toString().trim();
    if (focus.hasFocus == true) {
      if (text.isEmpty) {
        return Colors.redAccent;
      } else {
        return Colors.blueAccent;
      }
    } else {
      return black55;
    }
  }

// ! Widgets
  List<Widget> _drawTitle() {
    return [
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
      StreamBuilder(
          stream: testStream,
          builder: (context, snapshot) {
            return Text(snapshot.toString());
          })
    ];
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

  Widget _drawDescField() {
    return Padding(
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
    );
  }

  Widget _drawDateBtn() {
    return Padding(
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
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Text(
                DateFormat.yMMMd().format(_selectedTime ?? DateTime.now()),
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
    );
  }

  Widget drawBtnRow() {
    return Padding(
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
            child: StreamBuilder<bool>(
                stream: btnStreamController.stream,
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.none) {
                  return ElevatedButton(
                      onPressed: snapshot.data == null
                          ? null
                          : snapshot.data!
                              ? () {
                                  addTaskAction();
                                }
                              : null,
                      child: const Text("Creat Task"));
                  // } else {
                  // return Text("no");
                  // }
                }),
          ),
        ],
      ),
    );
  }

// ! Builds
  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _selectedTime = DateTime.now();
    controllerActions();
  }

  @override
  void dispose() {
    super.dispose();
    closeActions();
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
              children: _drawTitle() +
                  [
                    _drawNameFIeld(),
                    _drawDescField(),
                    _drawDateBtn(),
                    drawBtnRow()
                  ],
            ),
          )),
    );
  }
} // _InsertTodoState
