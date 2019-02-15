import 'package:flutter/material.dart';

/// 提供：
/// 1）用户登陆
/// 2）角色邀请（通过
class PageSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State4PageSettings();
  }
}

class _State4PageSettings extends State<PageSettings> {
  bool _cooperationsEnabled = false;

  get _onTap4Cooperations{
    switch(_cooperationsEnabled){
      case true: {
        /// 跳转到团队协作页面
        break;
      }
      case false:{
        /// 跳转到邮件登陆
        ///
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.people,
                size: 36,
                color: _cooperationsEnabled ? Colors.redAccent : Colors.grey,
              ),
              title: Text('多人协作',textAlign: TextAlign.left,),
              subtitle: _cooperationsEnabled ? Text('开启') : Text('未开启'),
              onTap: _onTap4Cooperations,
            )
          ],
        ),
      ),
    );
  }
}
