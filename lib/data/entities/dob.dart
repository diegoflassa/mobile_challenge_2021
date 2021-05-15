import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';

part 'dob.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Dob extends Equatable {
  Dob();

  /// A necessary factory constructor for creating a new Dob instance
  /// from a map. Pass the map to the generated `_$DobFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Dob.
  factory Dob.fromJson(Map<String, dynamic> json) => Dob._fromJson(json);

  @override
  List<Object?> get props => [date, age];

  static const String DATE = 'date';
  static const String AGE = 'age';

  @JsonKey(name: DATE)
  String date = DateTime.now().toString();
  @JsonKey(name: AGE)
  int age = 0;

  Dob copyWith(Dob dob) {
    final ret = Dob()
      ..date = dob.date
      ..age = dob.age;
    return ret;
  }

  Dob getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new Dob instance
  /// from a map. Pass the map to the generated `_$DobFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Dob.
  static Dob _fromJson(Map<String, dynamic> json) {
    final dob = _$DobFromJson(json);
    return dob;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$DobToJson`.
  Map<String, dynamic> toJson() => _$DobToJson(this);

  DateTime? getDateAsDateTime() {
    return DateTime.parse(date);
  }
}
