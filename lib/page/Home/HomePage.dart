import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:simple_login_crud/widgets/style/theme.dart' as Theme;
import 'package:simple_login_crud/scoped_models/app_model.dart';
import 'package:simple_login_crud/widgets/ui_elements/AppDrawer.dart';
import 'package:simple_login_crud/widgets/ui_elements/loading_modal.dart';
import 'package:simple_login_crud/widgets/ui_elements/rounded_button.dart';

class HomePage extends StatefulWidget {
  final AppModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    widget.model.setEditUser(null);

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  Widget _buildAppBar(AppModel model) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'CRUD',
      ),
    );
  }

  Widget _buildButtonRow(AppModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RoundedButton(
          icon: Icon(Icons.add_circle),
          label: 'Add user',
          onPressed: () {
            Navigator.pushNamed(context, '/editUser');
          },
        ),
        SizedBox(
          width: 20.0,
        ),
        RoundedButton(
          icon: Icon(Icons.supervised_user_circle),
          label: 'View user',
          onPressed: () {
            Navigator.pushNamed(context, '/listUser');
          },
        ),
      ],
    );
  }

  Widget _textAdminOrUser() {
    return Container(
      child: Center(
          child: new Text(
            widget.model.currentUser.username== 'admin'? 'Welcome Admin': 'Welcome ${widget.model.currentUser.username}',
            style: TextStyle(
              fontSize: 20,
            ),
          )
      ),
    );
  }

  Widget _buildPageContent(AppModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;
    return Scaffold(
      drawer: AppDrawer(widget.model),
      appBar: _buildAppBar(model),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      body: Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Theme.Colors.loginGradientStart,
                Theme.Colors.loginGradientEnd
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(

          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                child: Column(
                  children: <Widget>[
                    _textAdminOrUser(),
                    SizedBox(
                      height: 70.0,
                    ),
                    widget.model.currentUser.username=='admin' || widget.model.currentUser.username=='superadmin'? _buildButtonRow(model): SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
//        model.setEditUser(null);
        Stack stack = Stack(
          children: <Widget>[
            _buildPageContent(model),
          ],
        );

        if (model.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }
}


