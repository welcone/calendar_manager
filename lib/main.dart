import 'package:calendar_manager/Calendar/PageCalendar.dart';
import 'package:calendar_manager/Cooperations/PageCooperations.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return State4MyApp();
  }
}

class State4MyApp extends State<MyApp> {
  var _selectedIndex = 0;
  final _widgetOptions = [];

  @override
  void initState() {
    _widgetOptions.addAll([
      PageCalendar(
        title: '房源日历',
      ),
      Text('任务清单'),
      PageCooperations(
        title: '任务协作',
      ),
    ]);
    super.initState();
  }

  get _bottomNaviItems {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), title: Text('房源日历')),
      BottomNavigationBarItem(icon: Icon(Icons.check_box), title: Text('任务清单')),
      BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('多人协作')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendar Manager',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNaviItems,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          fixedColor: Colors.deepPurple,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
