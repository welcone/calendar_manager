import 'dart:async';

import 'package:flutter/material.dart';
import 'package:calendar_manager/widgets4GoogleLogin/reactive_refresh_indicator.dart';
import 'package:calendar_manager/widgets4GoogleLogin/google_sign_in_btn.dart';
import 'package:calendar_manager/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 提供：
/// 1）用户登陆
/// 2）角色邀请（通过
class PageCooperations extends StatefulWidget {
  String title;

  PageCooperations({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State4PageSettings();
  }
}

class _State4PageSettings extends State<PageCooperations> {
  bool _cooperationsEnabled = false;
  bool _isRefreshing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String TAG = 'Auth';
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentGoogleUser;

  // 验证是否登陆
  bool _isSignInded = false;



  String urlTask = 'https://gph.is/2xVFjhJ';
  /// 根据登陆账号的邮箱，去查询服务器中，与它存在对应关系的的其他用户的邮件地址。
  FutureOr Function() get _loadUsers {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:_showLogInPage(),
    );
  }

  get _showGoogleSignButton {
    return Center(
      child: GoogleSignInButton(
        assetsPath: 'assets/images/glogo.png',
        buttonText: '谷歌登陆',
        onPressed: () => _updateIsRefreshing(true),
      ),
    );
  }

  _updateIsRefreshing(bool isRefreshing) {
    Logger.log(TAG,
        message: '设置 _isRefreshing:$_isRefreshing to $isRefreshing');
    if (_isRefreshing) {
      // 如果本来是true 先重置为false
      setState(() {
        _isRefreshing = false;
      });
    }
    // 再设置为当前的状态
    setState(() {
      _isRefreshing = isRefreshing;
    });
  }

  Future<Null> _onRefresh() async {
    return await _onSignInGoogle();
  }

  Future<Null> _onSignInGoogle() async {
    Logger.log(TAG, message: '开始登陆....');
    _currentGoogleUser = _googleSignIn.currentUser;

    if (_currentGoogleUser == null) {
      Logger.log(TAG, message: 'currentUser...为空.');
      _googleSignIn.signIn().then(
            (seccessInResult) {
          Logger.log(TAG, message: '登陆成功...seccessInResult:$seccessInResult');
          _currentGoogleUser = seccessInResult;
          _updateIsRefreshing(true);
          _showErrorSnacker('登陆成功');
        },
        onError: (errorMessage) {
          Logger.log(TAG, message: '发生错误：$errorMessage');
          _showErrorSnacker('发生错误：$errorMessage');
        },
      ).whenComplete(_loadUsers);
    } else {
      Logger.log(TAG,
          message: 'Current Login User Info:'
              'display Name:${_currentGoogleUser.displayName}\n'
              'email:${_currentGoogleUser.email}\n'
              'photoUrl:${_currentGoogleUser.photoUrl}');
      _updateIsRefreshing(true);
      _showErrorSnacker('登陆成功');
    }
  }

  void _showErrorSnacker(String errorMessage) {
    this._updateIsRefreshing(false);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  Widget _showLogInPage() {
    return Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
                child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/giphy.gif')),
              ),
            )),
            Flexible(
              flex: 1,
              child: ReactiveRefreshIndicator(
                child: _showGoogleSignButton,
                onRefresh: _onRefresh,
                isRefreshing: _isRefreshing,
              ),
            )
          ],
        ));
  }

  Widget _showManageMents() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int) {
          return ListTile(
            leading: _currentGoogleUser == null
                ? Icon(Icons.person)
                : CachedNetworkImage(imageUrl: _currentGoogleUser.photoUrl),
            title: Text('Antonio steve'),
            subtitle: Text('owner'),
          );
        });
  }
}
