import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class UserProvider with ChangeNotifier {
  UserVo? _user;

  UserVo? get user => _user;

  void setUser(UserVo user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
