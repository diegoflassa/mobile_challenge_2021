import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';

part 'street.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Street extends Equatable {
  Street();

  /// A necessary factory constructor for creating a new Street instance
  /// from a map. Pass the map to the generated `_$StreetFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Street.
  factory Street.fromJson(Map<String, dynamic> json) => Street._fromJson(json);

  @override
  List<Object?> get props => [number, name];

  static const String NUMBER = 'number';
  static const String NAME = 'name';

  @JsonKey(name: NUMBER)
  int number = 0;
  @JsonKey(name: NAME)
  String name = '';

  Street copyWith(Street street) {
    final ret = Street()
      ..number = street.number
      ..name = street.name;
    return ret;
  }

  Street getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new Street instance
  /// from a map. Pass the map to the generated `_$StreetFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Street.
  static Street _fromJson(Map<String, dynamic> json) {
    final id = _$StreetFromJson(json);
    return id;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$StreetToJson`.
  Map<String, dynamic> toJson() => _$StreetToJson(this);
}
