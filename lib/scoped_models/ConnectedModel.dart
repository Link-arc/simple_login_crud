
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_login_crud/models/User.dart';
import 'package:simple_login_crud/services/database.dart';

mixin CoreModel on Model {
  List<User> _users = [];
  User _user;
  User _editUser;
  bool _isLoading = false;

}

mixin UsersModel on CoreModel {
  List<User> get users {
    return List.from(_users);
  }

  bool get isLoading {
    return _isLoading;
  }

  User get currentUser {
    return _user;
  }

  User get editUser {
    return _editUser;
  }

  void setCurrentUser(User user) {
    _user = user;
  }

  void setEditUser(User user) {
    _editUser = user;
  }

  Future<Null> fetchUsers() async{
    _isLoading = true;
    notifyListeners();

    _users = [];

    print('fetch note');

    try {

      var fetchedUsers = await UsersDatabaseService.db.getUsersFromDB();
      print('list');
      print(fetchedUsers);
      _users= fetchedUsers;

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<Map<String, dynamic>> createUser(
      String username, String password) async {
    _isLoading = true;
    notifyListeners();

    String id;

    try {

      final response = await UsersDatabaseService.db.getUser(username);

      String message;

      if (response == null) {
        await UsersDatabaseService.db.addUserInDB(username, password);
        _isLoading = false;
        notifyListeners();

        return {'success': true};
      } else {
        message = 'Username has been register ';
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': message,
      };

    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': error.toString()};
    }
  }

  Future<bool> updateUser(
      User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {

      await UsersDatabaseService.db.updateUserInDB(updatedUser);

      _isLoading = false;
      notifyListeners();

      return true;
    }  catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> removeUser(User currentUser) async {
    _isLoading = true;
    notifyListeners();

    try {

      int noteIndex = _users.indexWhere((t) => t.id == currentUser.id);
      _users.removeAt(noteIndex);

      await UsersDatabaseService.db.deleteUserInDB(currentUser);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
}

mixin Auth on CoreModel {

  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _user;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(
      String username, String password) async {
    _isLoading = true;
    notifyListeners();

    String message;

    try {

      if (username == 'superadmin') {
        _user = User(
//            id: response.id,
            username: username,
            password: password,
            date: DateTime.now()
        );

        _userSubject.add(true);

        _isLoading = false;
        notifyListeners();

        return {'success': true};
      } else {
        final response = await UsersDatabaseService.db.getLogin(
            username, password);

        if (response != null) {
          _user = User(
              id: response.id,
              username: response.username,
              password: response.password,
              date: DateTime.now()
          );

          updateUserData(user);

          _userSubject.add(true);

          _isLoading = false;
          notifyListeners();

          return {'success': true};
        } else {
          message = 'Invalid username or password.';
        }
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': message,
      };

    } catch(error) {
      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': error.toString(),
      };
    }

  }

  void updateUserData(User updatedUser) async {
    await UsersDatabaseService.db.updateUserInDB(updatedUser);
  }


  Future<void> signOut() async {

    _users = [];
    _user = null;

    _userSubject.add(false);
  }

}

