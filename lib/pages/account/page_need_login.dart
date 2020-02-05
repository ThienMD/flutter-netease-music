import 'package:flutter/material.dart';
import 'package:quiet/component/route.dart';
import 'package:quiet/pages/account/account.dart';

///包裹页面，表示当前页面需要登陆才能正常显示
class PageNeedLogin extends StatelessWidget {
  final WidgetBuilder builder;

  const PageNeedLogin({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UserAccount.of(context).isLogin) {
      return builder(context);
    }
    Widget widget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Current page requires login', style: TextStyle(fontWeight: FontWeight.bold)),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel',
                    style: TextStyle(color: Theme.of(context).errorColor),
                  )),
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context, pageLogin),
                child: Text('Go to landing page'),
              )
            ],
          )
        ],
      ),
    );

    if (Scaffold.of(context, nullOk: true) == null) {
      widget = Scaffold(body: widget, appBar: AppBar(title: Text('Need to log in')));
    }
    return widget;
  }
}
