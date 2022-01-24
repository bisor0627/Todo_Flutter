import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';

class GlobalAppBar extends AppBar {
  GlobalAppBar({Key? key, this.actions, this.leading, this.titleText})
      : super(key: key);
  List<Widget>? actions;
  Widget? leading;
  String? titleText;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        actions: actions,
        // [
        //   IconButton(
        //       onPressed: () async {
        //         await Navigator.push(context,
        //             MaterialPageRoute(builder: (context) {
        //           return const InsertTodos();
        //         }));
        //         listStreamController
        //             .addStream(handler.queryDateTodos(_targetDateTime));
        //       },
        //       icon: const Icon(Icons.add))
        // ],
        leading: leading,
        // GestureDetector(
        //   onLongPress: () => _deleteMode.value
        //       ? _deleteMode.value = false
        //       : _deleteMode.value = true,
        //   child: IconButton(
        //     icon: Icon(Icons.delete_forever),
        //     onPressed: () async {
        //       await multiDeleteTodos(_delTodosID);
        //       _delTodosID.clear();
        //       listStreamController
        //           .addStream(handler.queryDateTodos(_targetDateTime));
        //     },
        //   ),
        // ),
        title: Text(
          titleText!,
          style: title2,
        ),
        centerTitle: true,
        elevation: 0);
  }
}
