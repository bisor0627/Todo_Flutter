import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_sqlite/classes/event.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/flutter_calendar_carousel.dart';
import 'package:todo_sqlite/pages/insert.dart';
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
  // sqlite
  late var handler = DatabaseHandler();

  // Calendar
  StreamController<DateTime> calendarStreamController = StreamController();
  TodoCalendar todoCalendar = TodoCalendar(title: "title");
  DateTime _currentDate = DateTime.now(); // 오늘 날짜
  String _currentMonth = DateFormat.yMMM().format(DateTime.now()); // 현재 월
  ValueNotifier<String> currentMonth =
      ValueNotifier<String>(DateFormat.yMMM().format(DateTime.now()));
  late DateTime _targetDateTime; // 선택한 날짜

  // ListView
  StreamController<List<Todos>> listStreamController =
      StreamController.broadcast();

  // Delete
  final List<int> _delTodosID = [];
  //Stream

// !-------------------------------Method------------------------------------

  Future updateStateTodo(int? id, int state) async {
    await handler.updateState(id, state);
  }

  Future multiDeleteTodos(List<int> ids) async {
    await handler.deleteMutiTodos(ids);
  }

  Future insertDeleteList(int index) async {
    if (_delTodosID.contains(index)) {
      _delTodosID.remove(index);
    } else {
      _delTodosID.add(index);
    }
  }

// !--------------------------------Cycle-------------------------------------
  @override
  void initState() {
    super.initState();
    _targetDateTime = DateTime.now();

    listStreamController.addStream(handler.queryDateTodos(_targetDateTime));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: mainAppbar(),
      body: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            calendarHeader(),
            calendarCarouselNoHeader(),
            todoListView()
          ],
        ),
      ),
    );
  }

// !---------------------------------Widget------------------------------------
  AppBar mainAppbar() => AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const InsertTodos();
                }));
                listStreamController
                    .addStream(handler.queryDateTodos(_targetDateTime));
              },
              icon: const Icon(Icons.add))
        ],
        leading: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () async {
            await multiDeleteTodos(_delTodosID);
            _delTodosID.clear();
            listStreamController
                .addStream(handler.queryDateTodos(_targetDateTime));
          },
        ),
        title: Text(
          'My Tasks',
          style: title2,
        ),
        centerTitle: true,
        elevation: 0,
      );
  Widget calendarHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<String>(
              valueListenable: currentMonth,
              builder: (context, value, child) {
                print("Value");
                return Text(
                  currentMonth.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              TextButton(
                child: const Text('PREV'),
                onPressed: () async {
                  // setState(() {
                  //   _targetDateTime = DateTime(
                  //       _targetDateTime.year, _targetDateTime.month - 1);
                  //   _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  // });
                  _targetDateTime =
                      DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                  currentMonth.value =
                      DateFormat.yMMM().format(_targetDateTime);
                  calendarStreamController.sink.add(_targetDateTime);
                },
              ),
              TextButton(
                child: const Text('NEXT'),
                onPressed: () async {
                  _targetDateTime =
                      DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                  currentMonth.value =
                      DateFormat.yMMM().format(_targetDateTime);

                  calendarStreamController.sink.add(_targetDateTime);
                },
              ),
            ],
          )
        ],
      );

  Widget calendarCarouselNoHeader() => StreamBuilder<DateTime>(
      stream: calendarStreamController.stream,
      builder: (context, snapshot) {
        return CalendarCarousel<Event>(
          todayBorderColor: Colors.green,
          onDayPressed: (date, events) async {
            await {_targetDateTime = date, _currentDate = date};
            calendarStreamController.sink.add(_targetDateTime);
            listStreamController
                .addStream(handler.queryDateTodos(_targetDateTime));
          },
          daysHaveCircularBorder: true,
          showOnlyCurrentMonthDate: false,
          weekendTextStyle: const TextStyle(
            color: Colors.red,
          ),
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          height: 420.0,
          selectedDateTime: _currentDate,
          targetDateTime: _targetDateTime,
          customGridViewPhysics: const NeverScrollableScrollPhysics(),
          markedDateCustomShapeBorder:
              const CircleBorder(side: BorderSide(color: Colors.yellow)),
          markedDateCustomTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.blue,
          ),
          showHeader: false,
          todayTextStyle: const TextStyle(
            color: Colors.blue,
          ),
          todayButtonColor: Colors.yellow,
          selectedDayTextStyle: const TextStyle(
            color: Colors.yellow,
          ),
          minSelectedDate: _currentDate.subtract(const Duration(days: 360)),
          maxSelectedDate: _currentDate.add(const Duration(days: 360)),
          prevDaysTextStyle: const TextStyle(
            fontSize: 16,
            color: Colors.pinkAccent,
          ),
          inactiveDaysTextStyle: const TextStyle(
            color: Colors.tealAccent,
            fontSize: 16,
          ),
        );
      });

  Widget todoListView() => Expanded(
        child: StreamBuilder<List<Todos>>(
            stream: listStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                                  snapshot.data![index].name,
                                                  style: title2,
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(
                                                      snapshot.data![index]
                                                          .datetime),
                                                  style: bodyText1.override(
                                                    fontFamily: 'Lexend Deca',
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
                                    Padding(
                                      // State Done Button
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 12, 0),
                                      child: IconButton(
                                        onPressed: () async {
                                          await updateStateTodo(
                                              snapshot.data![index].id,
                                              snapshot.data![index].state);
                                          listStreamController.addStream(handler
                                              .queryDateTodos(_targetDateTime));
                                        },
                                        icon: Icon(
                                          snapshot.data![index].state == 0
                                              ? Icons.radio_button_off
                                              : Icons.check_circle,
                                          color: primarycolor,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      // Delete Button
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 12, 0),
                                      child: IconButton(
                                        onPressed: () async {
                                          await insertDeleteList(
                                              snapshot.data![index].id!);
                                          listStreamController.addStream(handler
                                              .queryDateTodos(_targetDateTime));
                                        },
                                        icon: Icon(
                                          _delTodosID.contains(
                                                  snapshot.data![index].id)
                                              ? Icons.delete_forever_rounded
                                              : Icons.delete_forever_outlined,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return InsertTodos(
                                  rtodo: Todos(
                                      id: snapshot.data![index].id,
                                      name: snapshot.data![index].name,
                                      desc: snapshot.data![index].desc,
                                      state: snapshot.data![index].state,
                                      datetime: snapshot.data![index].datetime),
                                );
                              }));
                              listStreamController.addStream(
                                  handler.queryDateTodos(_targetDateTime));
                            },
                          ));
                    });
              } else {
                return Text("no data");
              }
            }),
      );
}
