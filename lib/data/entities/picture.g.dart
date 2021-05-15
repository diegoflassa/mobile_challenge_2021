// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picture _$PictureFromJson(Map<String, dynamic> json) {
  return Picture()
    ..largeUrl =
        json['large'] == null ? null : Uri.parse(json['large'] as String)
    ..mediumUrl =
        json['medium'] == null ? null : Uri.parse(json['medium'] as String)
    ..thumbnailUrl = json['thumbnail'] == null
        ? null
        : Uri.parse(json['thumbnail'] as String);
}

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'large': instance.largeUrl?.toString(),
      'medium': instance.mediumUrl?.toString(),
      'thumbnail': instance.thumbnailUrl?.toString(),
    };
