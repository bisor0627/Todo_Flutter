import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';
import 'package:todo_sqlite/widget/button.dart';
import 'package:todo_sqlite/widget/textfield.dart';

class InsertTodos extends StatefulWidget {
  final Todos? rtodo;
  const InsertTodos({Key? key, this.rtodo}) : super(key: key);

  @override
  _InsertTodoState createState() => _InsertTodoState(rtodo);
}

class _InsertTodoState extends State<InsertTodos> {
  _InsertTodoState(Todos? rtodo);
// ! Variable -------------------------------
  late bool _nowQueryType; // insert or update

  late var handler = DatabaseHandler();
  late DateTime? _selectedTime; // 캘린더 선택 날짜

  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late StreamController<String> nameStreamController;
  late StreamController<String> descStreamController;
  late StreamController<bool> btnStreamController;

// ! Actions -------------------------------
  Future<int> addTodo() async {
    Todos firstTodo = Todos(
        name: nameController.text,
        desc: descController.text,
        state: 0,
        datetime: _selectedTime!);
    return await handler.insertTodos([firstTodo]);
  }

  Future<int> updateTodo() async {
    Todos firstTodo = Todos(
        id: widget.rtodo?.id,
        name: nameController.text,
        desc: descController.text,
        state: widget.rtodo!.state,
        datetime: _selectedTime!);
    return await handler.updateTodos([firstTodo]);
  }

  void controllerActions() {
    nameStreamController = StreamController<String>();
    descStreamController = StreamController<String>();
    btnStreamController = StreamController<bool>();

    nameController.addListener(() {
      nameStreamController.sink.add(nameController.text.trim());
      btnStreamController.sink.add(descController.text.trim().isNotEmpty &&
          nameController.text.trim().isNotEmpty);
    });
    descController.addListener(() {
      descStreamController.sink.add(descController.text.trim());
      btnStreamController.sink.add(descController.text.trim().isNotEmpty &&
          nameController.text.trim().isNotEmpty);
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
    _nowQueryType ? updateTodo() : addTodo();
    Navigator.pop(context);
  }

// ! Widgets -------------------------------
  List<Widget> _drawTitle() {
    return [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              _nowQueryType ? 'Update Task' : 'Add Task',
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
      )
    ];
  }

  Widget _drawNameFIeld() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        child: SimpleTextField(
          controller: nameController,
          focusNode: nameFocus,
          stream: nameStreamController.stream,
          labelText: "Task Name",
          hintText: "Enter your task here....",
        ));
  }

  Widget _drawDescField() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        child: SimpleTextField(
          controller: descController,
          focusNode: descFocus,
          stream: descStreamController.stream,
          labelText: "Details",
          hintText: "Enter a description here...",
          maxLines: 3,
        ));
  }

  Widget _drawDateBtn() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
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
          style: ElevatedButton.styleFrom(
            primary: ThemeData().canvasColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: black55)),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat.yMMMd().format(_selectedTime ?? DateTime.now()),
              style: bodyText1.override(
                color: tertiaryColor,
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
          SimpleButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
            style: ElevatedButton.styleFrom(primary: Colors.grey),
          ),
          StreamBuilder<bool>(
              stream: btnStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const SimpleButton(
                    onPressed: null,
                    child: Text("Back"),
                  );
                } else {
                  return SimpleButton(
                      onPressed: snapshot.data == null
                          ? null
                          : snapshot.data!
                              ? () {
                                  addTaskAction();
                                }
                              : null,
                      child:
                          Text(_nowQueryType ? "Update Task" : "Creat Task"));
                }
              }),
        ],
      ),
    );
  }

// ! Cycles -------------------------------

  @override
  void initState() {
    super.initState();
    controllerActions();

    if (widget.rtodo != null) {
      // update root
      _nowQueryType = true;
      _selectedTime = widget.rtodo?.datetime;
      nameController.text = widget.rtodo!.name;
      descController.text = widget.rtodo!.desc;
    } else {
      // insert root
      _nowQueryType = false;
      _selectedTime = DateTime.now();
    }
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

