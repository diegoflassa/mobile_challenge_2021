// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..street = Street.fromJson(json['street'] as Map<String, dynamic>)
    ..city = json['city'] as String
    ..state = json['state'] as String;
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street.toJson(),
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postCode,
    };
