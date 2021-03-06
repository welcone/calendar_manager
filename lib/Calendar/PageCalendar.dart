import 'package:calendar_manager/Calendar/PageOrderSaver.dart';
import 'package:calendar_manager/Calendar/PoOrder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

// todo-wk 16> 日历布局在iPad上有严重问题。


class PageCalendar extends StatefulWidget {
  PageCalendar({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PageCalendarState createState() => new _PageCalendarState();
}

class _PageCalendarState extends State<PageCalendar> {
  PoOrder _poOrder = PoOrder();

  /// 房源列表对应的订单图
  Map<String, EventList<Event>> _map4RoomsEvents = Map();

  /// 当前房源对应的订单列表
  EventList<Event> _markedDateMap;



//  get _navigateToPageSetting => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
//    return PageSetting();
//  }));

  //dasds

  @override
  void initState() {
    // todo-wk 6> done 解决返回的时候，因为没有 dateTimeOut 出错的bug
    this._poOrder.dateTimeIn = DateTime.now();
    this._poOrder.dateTimeOut = DateTime.now();
    this._poOrder.roomLable = PoOrder.roomLabels[0];

    /// 初始化房源事件容器
    var iterator = PoOrder.roomLabels.iterator;
    while (iterator.moveNext()) {
      _map4RoomsEvents.putIfAbsent(iterator.current, () {
        return EventList<Event>(
          events: {},
        );
      });
    }
    _markedDateMap = _map4RoomsEvents[this._poOrder.roomLable];
    super.initState();
  }



  /// 返回房源列表
  get _showInput4RoomLabel {
    return Container(
      // todo-wk 8> done 将控件往右边移动
      alignment: Alignment.centerRight,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.yellow, width: 2)),
      child: ListTile(
        leading: Icon(Icons.home),
        trailing: DropdownButton(
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          hint: Text('点击选择'),
          items: _dropItems,
          onChanged: _onChangeRoomLabels,
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

  // todo-wk 14> done 房间号切换，对应的订单表也切换。
  /// 保存下来选中的数据项目(PO:https://www.cnblogs.com/whatarewords/p/8086120.html)
  /// 切换当前房源
  void _onChangeRoomLabels(t) {
    _poOrder.roomLable = t;
    setState(() {
      this._poOrder.roomLable = t;
      this._markedDateMap = this._map4RoomsEvents[t];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
//          actions: <Widget>[
//            // todo-wk 19> 在这里弄一个设置弹出菜单， 显示两个项目：
//            // 1> 管理房源
//            // 2> 管理渠道
//            // 3> 账号管理
//            IconButton(icon: DropdownButton(items: null, onChanged: null), onPressed: (){}),
//          ],
        ),
        // todo-wk 20> 增加底部栏
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _clearEventOnCalendar(this._poOrder.dateTimeIn);
            },
            icon: Icon(Icons.arrow_back),
            label: Text('撤销')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _showInput4RoomLabel,
              _calendarHeader,
              _calendarCarouselNoHeader
            ],
          ),
        ),
    );
  }







  /// 今天
  DateTime _currentDate = DateTime.now();

  /// 当前选中的日期
  DateTime _currentDate2 = DateTime.now();

  /// 当前选中日期所属月份
  String _currentMonth = '';

  // todo-wk 1> 使用枚举，使得每次调用的头像是随机的，而不是固定的.
  /// 返回事件头像
    _eventIcon(DateTime date){
    return  Container(
      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Colors.blue, width: 1.0)),
      // todo-wk 13> 在头像上方，写入价格，下方写入日期，如果空间够
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.person,
            color: Colors.amber,
          ),
          Column(
            children: <Widget>[
              Text(
                '${_poOrder.incomeDaily}',
                style: TextStyle(fontSize: 12, color: Colors.redAccent,fontWeight: FontWeight.bold),
              ),
              Text(
                date.day.toString(),
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

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

  /// Example Calendar Carousel without header and custom prev & next button
  get _calendarCarouselNoHeader {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel<Event>(
          todayBorderColor: Colors.green,
          onDayPressed: (DateTime date, List events) {
            this.setState(() => _currentDate2 = date);
            print('main poOrder:$_poOrder');
            _navigateToPageOrderSaver(context, date);
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
    // todo-wk 12> done 解决录入订单的日期bug，用到了 date.difference
    int diffDays = date.difference(this._poOrder.dateTimeOut).inDays;
    print(' daydiffs: $diffDays');
    while (diffDays < 0) {
      _markedDateMap.add(
          date, Event(title: 'event new', icon: _eventIcon(date), date: date));
      print('$date marked, daydiffs: $diffDays');
      date = date.add(Duration(days: 1));
      diffDays = date.difference(this._poOrder.dateTimeOut).inDays;
    }
  }

  // todo-wk 9 > Done 撤销上一次操作
  /// 撤销标记点击的日期
  void _clearEventOnCalendar(DateTime date) {
    while (date.isBefore(this._poOrder.dateTimeOut)) {
      setState(() {
        _markedDateMap.remove(
            date, Event(title: 'event new', icon: _eventIcon(date), date: date));
        date = date.add(Duration(days: 1));
      });
      print('$date removed');
    }
  }

  /// 处理跳转事件
  void _navigateToPageOrderSaver(BuildContext context, DateTime date) async {
    this._poOrder = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PageOrderSaver(this._poOrder..dateTimeIn = date)));
    print('received data from page order saver:$_poOrder');
    _markEventOnCalendar(this._poOrder.dateTimeIn);
  }





}
