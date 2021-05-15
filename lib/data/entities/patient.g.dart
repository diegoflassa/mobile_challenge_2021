// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return Patient()
    ..id = Id.fromJson(json['id'] as Map<String, dynamic>)
    ..picture = Picture.fromJson(json['picture'] as Map<String, dynamic>)
    ..fullName = FullName.fromJson(json['name'] as Map<String, dynamic>)
    ..email = json['email'] as String
    ..gender = json['gender'] as String
    ..dateOfBirth = Dob.fromJson(json['dob'] as Map<String, dynamic>)
    ..telephone = json['phone'] as String
    ..cellphone = json['cell'] as String
    ..nationality = json['nat'] as String
    ..address = Address.fromJson(json['location'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id.toJson(),
      'picture': instance.picture.toJson(),
      'name': instance.fullName.toJson(),
      'email': instance.email,
      'gender': instance.gender,
      'dob': instance.dateOfBirth.toJson(),
      'phone': instance.telephone,
      'cell': instance.cellphone,
      'nat': instance.nationality,
      'location': instance.address.toJson(),
    };
