import 'dart:async';
import 'PoUser.dart';
import 'package:flutter/material.dart';
import 'package:calendar_manager/widgets4GoogleLogin/reactive_refresh_indicator.dart';
import 'package:calendar_manager/widgets4GoogleLogin/google_sign_in_btn.dart';
import 'package:calendar_manager/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { AUTH_SOCIAL, AUTH_LOGIN }

class PageCooperations extends StatefulWidget {
  String title;

  PageCooperations({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State4PageSettings();
  }
}

class _State4PageSettings extends State<PageCooperations> {
  bool _isRefreshing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String TAG = 'Auth';
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentGoogleUser;
  String urlTask = 'https://gph.is/2xVFjhJ';

  var _authStatus = AuthStatus.AUTH_SOCIAL;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ReactiveRefreshIndicator(
        child: _loadPages(),
        onRefresh: _onRefresh,
        isRefreshing: _isRefreshing,
      ),
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

    switch(this._authStatus){
      case AuthStatus.AUTH_SOCIAL:{
        return await _onSignInGoogle();
      }
      case AuthStatus.AUTH_LOGIN:{
        return await _onLoadingUsers();
      }
    }
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
          // 接下来是传输数据到谷歌firestore
          _uploadCurrentUserToFireStore();
        },
        onError: (errorMessage) {
          Logger.log(TAG, message: '发生错误：$errorMessage');
          _showErrorSnacker('发生错误：$errorMessage');
        },
      );
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

  Widget _loadPages() {
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
              child: _showGoogleSignButton
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

  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  /// 将获取到的谷歌用户信息存储到谷歌firestore
  void _uploadCurrentUserToFireStore() async {
    Map<String, String> docData = Map();
    docData.putIfAbsent(PoUser.keyName, () => _currentGoogleUser.displayName);
    docData.putIfAbsent(PoUser.keyPhotoUrl, () => _currentGoogleUser.photoUrl);
    docData.putIfAbsent(PoUser.keyEmail, () => _currentGoogleUser.email);
    var documentReference =
        _firestore.collection(PoUser.keyUsers).document(_currentGoogleUser.email);
    await documentReference.setData(docData).then(
        (result){
          // todo-wk Friday, February 22, 2019:17:44> 在这里开始显示可分享的列表
        },
        onError: (error){
          // todo-wk Friday, February 22, 2019:17:44> 在这里显示错误
          _showErrorSnacker('联络谷歌服务器错误！');
          Logger.logd(message: '$error');
        }
    );
  }
  /// 加载user
  _onLoadingUsers() {

  }
}
