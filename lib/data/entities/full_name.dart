import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';

part 'full_name.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class FullName extends Equatable {
  FullName();

  /// A necessary factory constructor for creating a new FullName instance
  /// from a map. Pass the map to the generated `_$FullNameFromJson()` constructor.
  /// The constructor is named after the source class, in this case, FullName.
  factory FullName.fromJson(Map<String, dynamic> json) =>
      FullName._fromJson(json);

  @override
  List<Object?> get props => [
        title,
        first,
        last,
      ];

  static const String TITLE = 'title';
  static const String FIRST = 'first';
  static const String LAST = 'last';

  @JsonKey(name: TITLE)
  String title = '';
  @JsonKey(name: FIRST)
  String first = '';
  @JsonKey(name: LAST)
  String last = '';

  FullName copyWith(FullName fullName) {
    final ret = FullName()
      ..title = fullName.title
      ..first = fullName.first
      ..last = fullName.last;

    return ret;
  }

  FullName getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new FullName instance
  /// from a map. Pass the map to the generated `_$FullNameFromJson()` constructor.
  /// The constructor is named after the source class, in this case, FullName.
  static FullName _fromJson(Map<String, dynamic> json) {
    final fullName = _$FullNameFromJson(json);
    return fullName;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$FullNameToJson`.
  Map<String, dynamic> toJson() => _$FullNameToJson(this);

  String getFullName() {
    return '$title $first $last';
  }
}
