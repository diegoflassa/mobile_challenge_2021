import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021_flutter/enums/gender.dart';
import 'package:mobile_challenge_2021_flutter/i18n/app_localizations.dart';

class SearchBarModel extends ChangeNotifier {
  String _query = '';

  set query(String value) {
    _query = value;
    notifyListeners();
  }

  String get query => _query;

  String _nationality = 'All';

  set nationality(String value) {
    _nationality = value;
    notifyListeners();
  }

  String get nationality => _nationality;

  Gender _gender = Gender.UNKNOWN;

  set gender(Gender value) {
    _gender = value;
    notifyListeners();
  }

  Gender get gender => _gender;

  void clear(BuildContext context) {
    _query = '';
    _nationality = AppLocalizations.of(context).all;
    _gender = Gender.UNKNOWN;
    notifyListeners();
  }
}
