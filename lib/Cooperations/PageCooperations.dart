import 'package:flutter/material.dart';
import 'package:calendar_manager/widgets4GoogleLogin/reactive_refresh_indicator.dart';
import 'package:calendar_manager/widgets4GoogleLogin/google_sign_in_btn.dart';
import 'package:calendar_manager/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  get _onTap4Cooperations {
    switch (_cooperationsEnabled) {
      case true:
        {
          /// 跳转到团队协作页面
          break;
        }
      case false:
        {
          /// 跳转到邮件登陆
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ReactiveRefreshIndicator(
        child: _showBody,
        onRefresh: _onRefresh,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  get _showBody {
    return Center(
      child: GoogleSignInButton(
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
    var currentUser = _googleSignIn.currentUser;

    if (currentUser == null) {
      Logger.log(TAG, message: 'currentUser...为空.');
      _googleSignIn.signIn().then(
        (seccessInResult) {
          Logger.log(TAG, message: '登陆成功...seccessInResult:$seccessInResult');
          currentUser = seccessInResult;
          _updateIsRefreshing(true);
          _showErrorSnacker('登陆成功');
        },
        onError: (errorMessage) {
          Logger.log(TAG, message: '发生错误：$errorMessage');
          _showErrorSnacker('发生错误：$errorMessage');
        },
      );
    }else{
      _currentGoogleUser = currentUser;
      Logger.log(TAG, message: 'Current Login User Info:'
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
}
