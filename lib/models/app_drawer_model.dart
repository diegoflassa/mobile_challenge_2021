import 'package:flutter/material.dart';

class AppDrawerModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  bool _hasShownUserLoggedInMessage = false;

  set hasShownUserLoggedInMessage(bool value) {
    _hasShownUserLoggedInMessage = value;
    notifyListeners();
  }

  bool get hasShownUserLoggedInMessage => _hasShownUserLoggedInMessage;

  bool _isUserLogged = false;

  set isUserLogged(bool value) {
    _isUserLogged = value;
    notifyListeners();
  }

  bool get isUserLogged => _isUserLogged;

  IconButton? _imgUser;

  set imgUser(IconButton? value) {
    _imgUser = value;
    notifyListeners();
  }

  IconButton? get imgUser => _imgUser;

  String? _originalFilePath;

  set originalFilePath(String? value) {
    _originalFilePath = value;
    notifyListeners();
  }

  String? get originalFilePath => _originalFilePath;

  void clear() {
    _hasShownUserLoggedInMessage = false;
    _isUserLogged = false;
    notifyListeners();
  }
}
