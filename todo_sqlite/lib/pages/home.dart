import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/pages/calendar.dart';
import 'package:todo_sqlite/pages/insert.dart';
import 'package:todo_sqlite/pages/update.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';
import 'package:todo_sqlite/widget/customCalendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHandler handler;
  late TextEditingController searchFieldController;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    searchFieldController = TextEditingController();
    // Temp Action
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        leading: PopupMenuButton(
          onSelected: (item) => menuBtnSelected(context, item),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text("캘린더"),
              value: 0,
            ),
            PopupMenuItem(
              child: Text("한 주 보기"),
              value: 1,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const InsertTodos();
                })).then((value) => reloadData());
              },
              icon: const Icon(Icons.add))
        ],
        title: Text(
          'My Tasks',
          style: title2,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: handler.queryTodos(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Todos>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(
                                  Icons.delete_forever,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              key: ValueKey<int>(snapshot.data![index].id!),
                              onDismissed: (DismissDirection direction) async {
                                await handler
                                    .deleteTodos(snapshot.data![index].id!);
                                setState(() {
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: GestureDetector(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index].name,
                                                      style: title2,
                                                    ),
                                                    // Text(
                                                    //   Repo.todoData.id
                                                    //       .toString(),
                                                    //   style: subtitle1,
                                                    // ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 4, 0, 0),
                                                  child: Text(
                                                    snapshot.data![index].desc,
                                                    style: bodyText2.override(
                                                        fontFamily:
                                                            'Lexend Deca',
                                                        color: primarycolor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 12, 0),
                                              child: IconButton(
                                                onPressed: () {
                                                  updateStateTodo(
                                                      snapshot.data![index].id,
                                                      snapshot
                                                          .data![index].state);
                                                },
                                                icon: Icon(
                                                  snapshot.data![index].state ==
                                                          0
                                                      ? Icons.radio_button_off
                                                      : Icons.check_circle,
                                                  color: primarycolor,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateTodos(
                                      rtodo: Todos(
                                          id: snapshot.data![index].id,
                                          name: snapshot.data![index].name,
                                          desc: snapshot.data![index].desc,
                                          state: snapshot.data![index].state,
                                          datetime:
                                              snapshot.data![index].datetime),
                                    );
                                  })).then(
                                      (value) => updateTodo(Repo.todoData));
                                },
                              ));
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  void reloadData() {
    setState(() {
      handler.queryTodos();
    });
  }

  void menuBtnSelected(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CalendarPage();
        })).then((value) => updateTodo(Repo.todoData));
        break;
      case 1:
        print("clicked item 1");
        break;
      case 2:
        print("clicked item 2");
        break;
      default:
    }
  }

  Future updateStateTodo(int? id, int state) async {
    await handler.updateState(id, state);
    return reloadData();
  }

  Future updateTodo(Todos todo) async {
    DateTime dateTime = DateTime.now();
    print(dateTime);
    await handler.updateTodos([todo]);
    return reloadData();
  }
}
