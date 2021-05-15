import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';

part 'id.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Id extends Equatable {
  Id();

  /// A necessary factory constructor for creating a new Id instance
  /// from a map. Pass the map to the generated `_$IdFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Id.
  factory Id.fromJson(Map<String, dynamic> json) => Id._fromJson(json);

  @override
  List<Object?> get props => [name, value];

  static const String NAME = 'name';
  static const String VALUE = 'value';

  @JsonKey(name: NAME)
  String name = '';
  @JsonKey(name: VALUE)
  String value = '';

  Id copyWith(Id id) {
    final ret = Id()
      ..name = id.name
      ..value = id.value;
    return ret;
  }

  Id getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new Id instance
  /// from a map. Pass the map to the generated `_$IdFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Id.
  static Id _fromJson(Map<String, dynamic> json) {
    final id = _$IdFromJson(json);
    return id;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$IdToJson`.
  Map<String, dynamic> toJson() => _$IdToJson(this);
}
