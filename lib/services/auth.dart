import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'storage.dart';

class Auth {
  static bool _isLoggedIn;
  static bool _isRegistered;
  static Map _user;
  static String _token;
  static String _userId;
  static String _userEmail;
  static String _loginRole;
  static int _currentPackage;
  static StreamController userStreamController;
  static Stream userStream;

  static Future<void> initialize() async {
    _user = await Storage.get('user');
    _token = await Storage.get('token');
    _userId = await Storage.get('userId');
    _userEmail = await Storage.get('userEmail');
    _loginRole = await Storage.get('login_role');
    _currentPackage = await Storage.get('current_package');
    _isLoggedIn = _token != null;
    _isRegistered = false;
    _openUserStream();
  }

  static bool check() {
    return _isLoggedIn;
  }

  static Future isRegistered() async {
    return await Storage.get('isRegistered');
  }

  static Map user() {
    return _user;
  }

  static String token() {
    return _token;
  }

  static String userId() {
    return _userId;
  }

  static String userEmail() {
    return _userEmail;
  }

  static String loginRole() {
    return _loginRole;
  }

  static int currentPackage() {
    return _currentPackage;
  }

  static Future<bool> login({
    Map user,
    String token,
    String loginRole,
    String userId,
    String userEmail,
  }) async {
    _user = user;
    _token = token;
    _userId = userId;
    _userEmail = userEmail;
    _loginRole = loginRole;
    _isLoggedIn = true;
    await Storage.set('user', user);
    await Storage.set('token', token);
    await Storage.set('userId', userId);
    await Storage.set('userEmail', userEmail);
    await Storage.set('login_role', _loginRole);
    _openUserStream();
    return true;
  }

  static Future<bool> logout() async {
    _user = null;
    _token = null;
    _userId = null;
    _userEmail = null;
    _isLoggedIn = false;

    await Storage.delete('user');
    await Storage.delete('token');
    await Storage.delete('userId');
    await Storage.delete('userEmail');
    await Storage.delete('login_role');

    await _closeUserStream();

    return true;
  }

  static void _openUserStream() {
    if (userStreamController == null) {
//      userStreamController = StreamController();
      userStreamController = BehaviorSubject();
      userStream = userStreamController.stream;
    }

    if (_user != null) {
      userStreamController.add(_user);
    }
  }

  static Future<void> _closeUserStream() async {
    await userStreamController.close();
    userStream = null;
    userStreamController = null;
  }
}
