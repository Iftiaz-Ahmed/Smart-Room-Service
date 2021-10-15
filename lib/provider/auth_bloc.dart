import 'package:flutter/cupertino.dart';

class AuthBloc extends ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;
  set isLogged(bool value) {
    _isLogged = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
