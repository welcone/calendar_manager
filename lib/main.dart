import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:calendar_manager/PageOrderSaver.dart';
import 'PoOrder.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      home: new MyHomePage(title: '民宿管理日历'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const int _pageToOrderSaver = 0;

class _MyHomePageState extends State<MyHomePage> {

  PoOrder _poOrder = PoOrder()..roomLable = PoOrder.roomLabels[0];


  @override
  void initState() {
    super.initState();
  }

  /// 返回房源列表
  get _showInput4RoomLabel {
    return Container(
      width: 200,
      child: ListTile(
        trailing: DropdownButton(
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          hint: Text('点击选择'),
          items: _dropItems,
          onChanged: saveDropDownItemData,
          value: this._poOrder.roomLable,
        ),
      ),
    );
  }
  /// 为方法：_input4RoomLabel,返回房源列表的数据项目
  get _dropItems {
    // todo-wk > 服务器做一个界面，管理房源列表
    return List.generate(PoOrder.roomLabels.length, (int index) {
      return new DropdownMenuItem(
        child: new Text(PoOrder.roomLabels[index]),
        value: PoOrder.roomLabels[index],
      );
    });
  }
  // todo-wk 1.3>
  /// 保存下来选中的数据项目(PO:https://www.cnblogs.com/whatarewords/p/8086120.html)
  void saveDropDownItemData(t) {
    _poOrder.roomLable = t;
    setState(() {
      this._poOrder.roomLable = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            _showInput4RoomLabel
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_calendarHeader, _calendarCarouselNoHeader],
          ),
        ));
  }

  /// 今天
  DateTime _currentDate = DateTime.now();

  /// 当前选中的日期
  DateTime _currentDate2 = DateTime.now();

  /// 当前选中日期所属月份
  String _currentMonth = '';

  // todo-wk 1> 使用枚举，使得每次调用的头像是随机的，而不是固定的.
  /// 事件头像
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 1.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  //
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  get _calendarHeader {
    //日历头
    return Container(
      margin: EdgeInsets.only(
        top: 30.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        children: <Widget>[
          Expanded(
              child: Text(
            _currentMonth,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          )),
          FlatButton(
            child: Text('上个月'),
            onPressed: () {
              setState(() {
                _currentDate2 = _currentDate2.subtract(Duration(days: 30));
                _currentMonth = DateFormat.yMMM().format(_currentDate2);
              });
            },
          ),
          FlatButton(
            child: Text('下个月'),
            onPressed: () {
              setState(() {
                _currentDate2 = _currentDate2.add(Duration(days: 30));
                _currentMonth = DateFormat.yMMM().format(_currentDate2);
              });
            },
          )
        ],
      ),
    );
  }

  /// Example with custom icon
  get _calendarCarousel {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },

      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),

      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
//          headerText: Container( /// Example for rendering custom header
//            child: Text('Custom Header'),
//          ),
//          markedDates: _markedDate,
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal:
          true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );
  }

  /// Example Calendar Carousel without header and custom prev & next button
  get _calendarCarouselNoHeader {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel<Event>(
          todayBorderColor: Colors.green,
          onDayPressed: (DateTime date, List events) {
            this.setState(() => _currentDate2 = date);
            _navigateToPageOrderSaver(context,date);
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          markedDatesMap: _markedDateMap,
          height: 420.0,
          selectedDateTime: _currentDate2,
          customGridViewPhysics: NeverScrollableScrollPhysics(),
          markedDateShowIcon: true,
          markedDateIconMaxShown: 2,
          markedDateMoreShowTotal: false,
          // null for not showing hidden events indicator
          showHeader: false,
          markedDateIconBuilder: (event) {
            return event.icon;
          },
          todayTextStyle: TextStyle(
            color: Colors.blue,
          ),
          todayButtonColor: Colors.yellow,
          selectedDayTextStyle: TextStyle(
            color: Colors.green,
          ),
          minSelectedDate: _currentDate,
          maxSelectedDate: _currentDate.add(Duration(days: 60)),
//      inactiveDateColor: Colors.black12,
          onCalendarChanged: (DateTime date) {
            this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
          },
        ),
      );
    });
  }



  /// 标记点击的日期
  void _markEventOnCalendar(DateTime date) {
    _markedDateMap.add(
        date, Event(title: 'event new', icon: _eventIcon, date: date));
  }

  /// 跳转到下一个页面
  void _navigateTo(int index) async {

  }
  /// 处理跳转事件
  void _navigateToPageOrderSaver(BuildContext context, DateTime date) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PageOrderSaver(this._poOrder..dateTimeIn = date)));
    print('received data from page order saver${result}');
  }

}
