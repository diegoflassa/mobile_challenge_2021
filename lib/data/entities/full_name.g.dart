// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullName _$FullNameFromJson(Map<String, dynamic> json) {
  return FullName()
    ..title = json['title'] as String
    ..first = json['first'] as String
    ..last = json['last'] as String;
}

Map<String, dynamic> _$FullNameToJson(FullName instance) => <String, dynamic>{
      'title': instance.title,
      'first': instance.first,
      'last': instance.last,
    };
