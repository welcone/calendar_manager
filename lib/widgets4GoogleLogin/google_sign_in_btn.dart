import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function onPressed;
  final String assetsPath;
  final String buttonText;

  GoogleSignInButton({
    Key key,
    @required this.onPressed, @required this.assetsPath, @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.onPressed(),
      color: Colors.white,
      elevation: 0.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            assetsPath,
            height: 18.0,
            width: 18.0,
          ),
          SizedBox(width: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
