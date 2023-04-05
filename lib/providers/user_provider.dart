import 'package:b2bmobile/models/users.dart';
import 'package:b2bmobile/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {

  UserProvider(){
      
  }

  

  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserData();
    _user = user;
    notifyListeners();
  }
}
