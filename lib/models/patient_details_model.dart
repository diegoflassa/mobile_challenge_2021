import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/data/entities/patient.dart';

class PatientDetailsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  Patient _patient = Patient();

  set patient(Patient value) {
    _patient = value;
    notifyListeners();
  }

  Patient get patient => _patient;

  double _scrollPosition = 5.0;

  set scrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  double get scrollPosition => _scrollPosition;

  bool _replaceState = false;

  set replaceState(bool value) {
    _replaceState = value;
    notifyListeners();
  }

  bool get replaceState => _replaceState;

  void clear() {
    _patient = Patient();
    _scrollPosition = 5.0;
    _replaceState = false;
    notifyListeners();
  }
}
