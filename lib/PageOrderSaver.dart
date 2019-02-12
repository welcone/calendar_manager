import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'PoOrder.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PageOrderSaver extends StatefulWidget {
  final PoOrder _poOrder;

  PageOrderSaver(this._poOrder);

  @override
  State<StatefulWidget> createState() {
    return _State4OrderSaver(this._poOrder);
  }
}

class _State4OrderSaver extends State<PageOrderSaver> {
  PoOrder _poOrder;

  _State4OrderSaver(this._poOrder);




  // todo-wk 1.1> 返回房源列表
  /// 返回房源列表
  get _showInput4RoomLabel {
    return ListTile(
      title: Text('选择房源'),
      trailing: DropdownButton(
        hint: Text('点击选择'),
        items: _dropItems,
        onChanged: saveDropDownItemData,
        value: this._poOrder.roomLable,
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
  void initState() {
    print('received poOrder from main:${this._poOrder}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 导航栏
      appBar: AppBar(
        title: Text('订单录入'),
      ),
      // 主页面
      body: Builder(builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _showInput4RoomLabel,
                _showDateTimePicker('入住时间', (dt) {
                  setState(() {
                    this._poOrder.dateTimeIn = dt;
                  });
                }),
                _showDateTimePicker('离开时间', (dt) {
                  this._poOrder.dateTimeOut = dt;
                }),
                _showSubmitButton,
              ],
            ),
          ),
        );
      }),
    );
  }

  //DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
  final _formats = {
    InputType.both: DateFormat("yyyy-MM-dd:HH:mm"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType _inputType = InputType.both;

  /// 显示入住时间
  Widget _showDateTimePicker(
      String pickerLabel, Function(DateTime dt) onDateChange) {
    return ListTile(
      title: Text(pickerLabel),
      trailing: Container(
        width: 200,
        child: DateTimePickerFormField(
          inputType: _inputType,
          editable: true,
          format: _formats[_inputType],
          initialValue: _poOrder.dateTimeIn,
          decoration: InputDecoration(
              labelText: '设置日期/时间', hasFloatingPlaceholder: false),
          onChanged: onDateChange,
        ),
      ),
    );
  }

  /// 显示提交按钮
  get _showSubmitButton {
    return RaisedButton(
      onPressed: _onSubmit,
      child: Text('提交'),
    );
  }

  /// 处理返回数据
  void _onSubmit() {
//    Navigator.pop(context,_poOrder);
    print('datetime in : ${this._poOrder}');
    Navigator.pop(context,this._poOrder);
  }
}
