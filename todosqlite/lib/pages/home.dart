import 'package:flutter/material.dart';
import 'package:todosqlite/config/constant.dart';
import 'package:todosqlite/pages/insert.dart';
import 'package:todosqlite/pages/update.dart';
import 'package:todosqlite/sqlite/databaseHandler.dart';
import 'package:todosqlite/sqlite/todos.dart';

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
    // Temp Action
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
    searchFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black77,
      appBar: AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        title: Text(
          'My Tasks',
          style: title2,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            color: Colors.transparent,
            elevation: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: const BoxDecoration(
                color: primarycolor,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 4),
                child: Row(children: [
                  Expanded(
                    // flex: 7,
                    child: TextFormField(
                      controller: searchFieldController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '당신의 기록을 검색하세요...',
                        labelStyle: bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: const Color(0xFF95A1AC),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF262D34),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF262D34),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF95A1AC),
                        ),
                      ),
                      style: bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: const Color(0xFF95A1AC),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const InsertTodos();
                      })).then((value) => reloadData());
                    },
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ),
                  )
                ]),
              ),
            ),
          ),
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
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Icon(
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: title2,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                  snapshot.data![index].desc,
                                                  style: bodyText2.override(
                                                      fontFamily: 'Lexend Deca',
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
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 12, 0),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                snapshot.data![index].state == 0
                                                    ? Icons.check_circle
                                                    : Icons.radio_button_off,
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
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateTodos(
                                        rname: snapshot.data![index].name,
                                        rdesc: snapshot.data![index].desc,
                                        rstate: snapshot.data![index].state);
                                  })).then((value) => reloadData());
                                },
                              ));
                        });
                  } else {
                    return Center(
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
}
