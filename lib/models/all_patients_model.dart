import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/data/entities/patient.dart';
import 'package:mobile_challenge_2021/enums/query_fields.dart';

class AllPatientsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Patient> _patients = <Patient>[];

  set patients(List<Patient> value) {
    _patients = value;
    notifyListeners();
  }

  List<Patient> get patients => _patients;

  Map<QueryFields, String> _queryFields = <QueryFields, String>{};

  set queryFields(Map<QueryFields, String> value) {
    _queryFields = value;
    notifyListeners();
  }

  Map<QueryFields, String> get queryFields => _queryFields;

  int _currentPage = 1;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;

  double _scrollPosition = 5.0;

  set scrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  double get scrollPosition => _scrollPosition;

  bool _shouldReload = false;

  set shouldReload(bool value) {
    _shouldReload = value;
    notifyListeners();
  }

  bool get shouldReload => _shouldReload;

  bool _isFromQuery = false;

  set isFromQuery(bool value) {
    _isFromQuery = value;
    notifyListeners();
  }

  bool get isFromQuery => _isFromQuery;

  Type? _clearPatientsByState;

  set clearPatientsByState(Type? value) {
    _clearPatientsByState = value;
    notifyListeners();
  }

  Type? get clearPatientsByState => _clearPatientsByState;

  bool _waitForFirstPage = false;

  set waitForFirstPage(bool value) {
    _waitForFirstPage = value;
    notifyListeners();
  }

  bool get waitForFirstPage => _waitForFirstPage;

  bool _loadMore = false;

  set loadMore(bool value) {
    _loadMore = value;
    notifyListeners();
  }

  bool get loadMore => _loadMore;

  double _previousMaxScrollExtent = 0;

  set previousMaxScrollExtent(double value) {
    _previousMaxScrollExtent = value;
    notifyListeners();
  }

  double get previousMaxScrollExtent => _previousMaxScrollExtent;

  List<Widget> _patientsAsCards = <Widget>[];

  set patientsAsCards(List<Widget> value) {
    _patientsAsCards = value;
    notifyListeners();
  }

  List<Widget> get patientsAsCards => _patientsAsCards;

  bool _endOfItems = true;

  set endOfItems(bool value) {
    _endOfItems = value;
    notifyListeners();
  }

  bool get endOfItems => _endOfItems;

  bool _isLoading = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void clear() {
    _patients.clear();
    _queryFields.clear();
    _currentPage = 1;
    _scrollPosition = 5.0;
    _shouldReload = false;
    _isFromQuery = false;
    _clearPatientsByState = null;
    _waitForFirstPage = false;
    _loadMore = false;
    _patientsAsCards.clear();
    _endOfItems = true;
    _isLoading = false;
    notifyListeners();
  }
}
