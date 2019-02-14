import 'package:flutter/material.dart';
import 'BottomOptions/PageCalendar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return State4MyApp();
  }
}

class State4MyApp extends State<MyApp> {
  var _selectedIndex = 0;

  final _widgetOptions = [
  ];


  @override
  void initState() {
    _widgetOptions.addAll([
      _showCalendar,
      _showTodo,
      _showSettings,
    ]);
    super.initState();
  }

  get _showCalendar => PageCalendar(title: '房源日历',);

  get _showTodo => Text('任务处理');

  get _showSettings => Text('设置');
  

  get _bottomNaviItems {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.calendar_today),title: Text('房源日历')),
      BottomNavigationBarItem(icon: Icon(Icons.check_box),title: Text('任务清单')),
      BottomNavigationBarItem(icon: Icon(Icons.settings),title: Text('设置')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendar Manager',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
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