import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_login_crud/page/Auth/AuthPage.dart';
import 'package:simple_login_crud/page/Home/HomePage.dart';
import 'package:simple_login_crud/page/Home/EditUserPage.dart';
import 'package:simple_login_crud/page/Home/UserListPage.dart';
import 'package:simple_login_crud/scoped_models/app_model.dart';
import 'package:simple_login_crud/services/database.dart';

void main() async {
  runApp(CRUD());
}

class CRUD extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CRUDState();
  }
}

class _CRUDState extends State<CRUD> {
  AppModel _model;
  bool _isAuthenticated = false;

  @override
  void initState() {

    UsersDatabaseService.db.init();

    _model = AppModel();

    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: _model,

      child: MaterialApp(
        title: 'CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) =>
          _isAuthenticated ? HomePage(_model)  : AuthPage(),
          '/editUser': (BuildContext context) =>
          _isAuthenticated ? EditUserPage(_model) : AuthPage(),
          '/listUser': (BuildContext context) =>
          _isAuthenticated ? UserListPage(_model) : AuthPage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                AuthPage(),
          );
        },
        builder: (BuildContext context, Widget child) {
          return new Padding(
              child: child,
              padding: const EdgeInsets.only(
                  bottom: 50.0
              )
          );
        },
      ),
    );
  }
}
