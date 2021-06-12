import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/street.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Address extends Equatable {
  Address();

  /// A necessary factory constructor for creating a new Address instance
  /// from a map. Pass the map to the generated `_$AddressFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Address.
  factory Address.fromJson(Map<String, dynamic> json) =>
      Address._fromJson(json);

  @override
  List<Object?> get props => [
        //reference,
        street,
        city,
        state,
        postCode,
      ];

  static const String STREET = 'street';
  static const String CITY = 'city';
  static const String STATE = 'state';
  static const String POSTCODE = 'postcode';

  @JsonKey(name: STREET)
  Street street = Street();
  @JsonKey(name: CITY)
  String city = '';
  @JsonKey(name: STATE)
  String state = '';
  @JsonKey(name: POSTCODE, fromJson: _stringFromIntOrString)
  String postCode = '';

  Address copyWith(Address address) {
    final ret = Address()
      ..street.number = address.street.number
      ..street.name = address.street.name
      ..city = address.city
      ..state = address.state
      ..postCode = address.postCode;

    return ret;
  }

  Address getCopy() {
    return copyWith(this);
  }

  static String _stringFromIntOrString(Object value) {
    return value.toString();
  }

  /// A necessary factory constructor for creating a new Address instance
  /// from a map. Pass the map to the generated `_$AddressFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Address.
  static Address _fromJson(Map<String, dynamic> json) {
    final address = _$AddressFromJson(json);
    return address;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AddressToJson`.
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String getFullAddress() {
    return '$street - $city - $state - $postCode';
  }
}
