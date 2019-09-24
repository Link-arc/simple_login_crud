import 'package:path/path.dart';
import 'package:simple_login_crud/models/User.dart';
import 'package:sqflite/sqflite.dart';

class UsersDatabaseService {
  String path;

  UsersDatabaseService._();

  static final UsersDatabaseService db = UsersDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'users.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Users (_id INTEGER PRIMARY KEY, username TEXT, password TEXT, date TEXT);');
      print('New table created at $path');
    });
  }

  Future<List<User>> getUsersFromDB() async {
    final db = await database;
    List<User> usersList = [];
    List<Map> maps = await db.query('Users',
        columns: ['_id', 'username', 'password', 'date']);
    if (maps.length > 0) {
      maps.forEach((map) {
        usersList.add(User.fromMap(map));
      });
    }

    print('-------');
    return usersList;
  }

  updateUserInDB(User updatedUser) async {
    final db = await database;
    await db.update('Users', updatedUser.toMap(),
        where: '_id = ?', whereArgs: [updatedUser.id]);
    print('Note updated: ${updatedUser.username} ${updatedUser.password}');
  }

  deleteUserInDB(User userToDelete) async {
    final db = await database;
    await db.delete('Users', where: '_id = ?', whereArgs: [userToDelete.id]);
    print('Note deleted');
  }

  Future<User> addUserInDB(User newUser) async {
    final db = await database;
//    if (newUser.password.trim().isEmpty) newUser.password = 'Untitled Note';
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Users(username, password, date) VALUES ("${newUser.username}", "${newUser.password}", "${newUser.date.toIso8601String()}");');
    });
    newUser.id = id;
    print('Note added: ${newUser.username} ${newUser.password}');
    return newUser;
  }
}
