import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/sqlite/handler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Handler handler;
  late TextEditingController searchFieldController;

  @override
  void initState() {
    super.initState();
    handler = Handler();
    // Temp Action
    handler.initializeDB().whenComplete(() async {
      await addFirstTodo();
      setState(() {});
    });
    searchFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Column(
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
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
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
                                  child: const Icon(
                                    Icons.delete_forever,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                ),
                                key: ValueKey<int>(snapshot.data![index].id!),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await handler
                                      .deleteTodos(snapshot.data![index].id!);
                                  setState(() {
                                    snapshot.data!
                                        .remove(snapshot.data![index]);
                                  });
                                },
                                child: GestureDetector(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "todoDate :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data![index].todoName
                                                .toString())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "todoName :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data![index].todoName)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "todoDesc :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data![index].todoDesc)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "todoState :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data![index].todoState
                                                ? "true"
                                                : "false")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    /*
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return updateTodos(
                        rtodoDate: snapshot.data![index].todoDate,
                        rtodoName: snapshot.data![index].todoName,
                        rtodoDesc: snapshot.data![index].todoDesc,
                        rtodoState: snapshot.data![index].todoState);
                  })).then((value) => reloadData());
                  */
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
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        addFirstTodo();
      }),
    );
  }

  Future<int> addFirstTodo() async {
    Todos firstTodos =
        Todos(todoDesc: "world", todoName: "hello", todoState: false);

    return await handler.insertTodos(firstTodos);
  }

  void reloadData() {
    setState(() {
      handler.queryTodos();
    });
  }
}
