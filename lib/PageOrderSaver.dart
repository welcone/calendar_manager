import 'package:flutter/material.dart';
import 'PoOrder.dart';

class PageOrderSaver extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State4OrderSaver();
  }
}

class _State4OrderSaver extends State<PageOrderSaver> {
  PoOrder _poOrder = PoOrder();
  // todo-wk 1.1> 返回房源列表
  /// 返回房源列表
  get _input4RoomLabel {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('房源'),
          DropdownButton(items: _drompItems, onChanged: saveDropDownItemData)
        ],
    );
  }
  // todo-wk 1.2>
  /// 为方法：_input4RoomLabel,返回房源列表的数据项目
  get _drompItems{
    // todo-wk > 服务器做一个界面，管理房源列表
    var roomLabels = ['华阳605','文殊院3218'];
    return List.generate(roomLabels.length, (int index){
         return
           new DropdownMenuItem(
           child:new Text(roomLabels[index]),
           value: roomLabels[index],
         );
    });
  }
  // todo-wk 1.3>
  /// 保存下来选中的数据项目(PO:https://www.cnblogs.com/whatarewords/p/8086120.html)
  void saveDropDownItemData(t){
    _poOrder.roomLable = t ;
    print('*************${_poOrder.roomLable}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 导航栏
      appBar: AppBar(
        title: Text('订单录入'),
      ),
      // 主页面
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _input4RoomLabel,
        ],
      ),

    );
  }
}
