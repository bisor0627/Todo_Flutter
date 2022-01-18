import 'package:flutter/material.dart';
import 'package:todo_sqlite/classes/event.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/flutter_calendar_carousel.dart';
import 'package:todo_sqlite/pages/insert.dart';
import 'package:todo_sqlite/pages/update.dart';
import 'package:todo_sqlite/sqlite/databaseHandler.dart';
import 'package:todo_sqlite/sqlite/todos.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/widget/todo_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoCalendar todoCalendar = TodoCalendar(title: "title");

  DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime(2022, 1, 15);
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
    final calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      height: 420.0,
      selectedDateTime: _currentDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _currentMonth,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    child: Text('PREV'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month + 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(
              // height: MediaQuery.of(context).size.height * 0.6,
              child: calendarCarouselNoHeader),
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
                                                    Text(
                                                      DateFormat.yMMMd().format(
                                                          snapshot.data![index]
                                                              .datetime),
                                                      style: bodyText1.override(
                                                        fontFamily:
                                                            'Lexend Deca',
                                                        color: tertiaryColor,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                      ),
                                                    )
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
                                  })).then((value) => reloadData());
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
