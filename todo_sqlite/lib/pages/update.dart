import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';

class UpdateTodos extends StatefulWidget {
  final String rname;
  final String rdesc;
  final int rstate;

  const UpdateTodos(
      {Key? key,
      required this.rname,
      required this.rdesc,
      required this.rstate})
      : super(key: key);

  @override
  _UpdateTodosState createState() => _UpdateTodosState(rname, rdesc, rstate);
}

class _UpdateTodosState extends State<UpdateTodos> {
  late DatabaseHandler handler;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

// Create Constructor
  _UpdateTodosState(String rname, String rdesc, int rstate) {
    name = rname;
    desc = rdesc;
    state = rstate;
  }

  late String name;
  late String desc;
  late int state;
  late String result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = name;
    descController.text = desc;

    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                name,
                style: title1,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    name,
                    style: title1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(desc,
                      style: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: tertiaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      )),
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
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            state.toString(),
                            style: title2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text("")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} // _UpdateTodosState

