import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_sqlite/classes/event.dart';
import 'package:todo_sqlite/config/constant.dart';
import 'package:todo_sqlite/flutter_calendar_carousel.dart';
import 'package:todo_sqlite/pages/insert.dart';
// import 'package:todo_sqlite/pages/update.dart';
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
  late var handler = DatabaseHandler();
  DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  late DateTime _targetDateTime;
  late StreamController<List<Todos>> todoListStreamController;

  late TextEditingController searchFieldController;
// !-------------------------------Action------------------------------------

  Stream updateStateTodo(int? id, int state) async* {
    await handler.updateState(id, state);
  }

// !-------------------------------Build------------------------------------
  @override
  void initState() {
    super.initState();
    _targetDateTime = DateTime.now();
    searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(),
      body: Column(
        children: [
          calendarHeader(),
          calendarCarouselNoHeader(),
          todoListView()
        ],
      ),
    );
  }

// !-------------------------------Widget------------------------------------
  AppBar mainAppbar() => AppBar(
        backgroundColor: primarycolor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const InsertTodos();
                }));
              },
              icon: const Icon(Icons.add))
        ],
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
            child: Text(
              _currentMonth,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                child: const Text('PREV'),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month - 1);
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
              ),
              TextButton(
                child: const Text('NEXT'),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month + 1);
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
              ),
            ],
          )
        ],
      );

  Widget calendarCarouselNoHeader() => CalendarCarousel<Event>(
        todayBorderColor: Colors.green,
        onDayPressed: (date, events) {
          setState(() {
            _targetDateTime = date;
            _currentDate = date;
          });
        },
        daysHaveCircularBorder: true,
        showOnlyCurrentMonthDate: false,
        weekendTextStyle: const TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
        weekFormat: false,
//      firstDayOfWeek: 4,
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
        onDayLongPressed: (DateTime date) {
          print('long pressed date $date');
        },
      );

  Widget todoListView() => Expanded(
        child: FutureBuilder<List<Todos>>(
            future: handler.queryDateTodos(_targetDateTime),
            builder:
                (BuildContext context, AsyncSnapshot<List<Todos>> snapshot) {
              if (snapshot.hasData) {
                print(
                    "${snapshot.data?.length}   ${snapshot.connectionState} ${_targetDateTime}");

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
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 12, 0),
                                          child: IconButton(
                                            onPressed: () {
                                              updateStateTodo(
                                                  snapshot.data![index].id,
                                                  snapshot.data![index].state);
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
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
                            },
                          ));
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      );
}
