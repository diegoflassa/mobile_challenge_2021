import 'package:mobile_challenge_2021/enums/gender.dart';

abstract class OnSearch {
  void onSearch(
      {String? query, String? nationality, Gender gender = Gender.UNKNOWN});
  void clear();
}
