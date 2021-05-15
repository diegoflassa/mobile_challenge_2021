import 'dart:typed_data';

import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_challenge_2021/extensions/uri_extensions.dart';

part 'picture.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Picture extends Equatable {
  Picture();

  /// A necessary factory constructor for creating a new Picture instance
  /// from a map. Pass the map to the generated `_$PictureFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Picture.
  factory Picture.fromJson(Map<String, dynamic> json) =>
      Picture._fromJson(json);

  @override
  List<Object?> get props => [
        //reference,
        largeUrl, mediumUrl, thumbnailUrl
      ];

  static const String LARGE = 'large';
  static const String MEDIUM = 'medium';
  static const String THUMBNAIL = 'thumbnail';

  @JsonKey(name: LARGE)
  Uri? largeUrl;
  @JsonKey(ignore: true)
  Uint8List? largeAsBytes;
  @JsonKey(ignore: true)
  Future<Uint8List?>? largeAsBytesFuture;
  @JsonKey(ignore: true)
  bool _gotLarge = false;
  @JsonKey(ignore: true)
  bool _gettingLarge = false;

  @JsonKey(name: MEDIUM)
  Uri? mediumUrl;
  @JsonKey(ignore: true)
  Uint8List? mediumAsBytes;
  @JsonKey(ignore: true)
  Future<Uint8List?>? mediumAsBytesFuture;
  @JsonKey(ignore: true)
  bool _gotMedium = false;
  @JsonKey(ignore: true)
  bool _gettingMedium = false;

  @JsonKey(name: THUMBNAIL)
  Uri? thumbnailUrl;
  @JsonKey(ignore: true)
  Uint8List? thumbnailAsBytes;
  @JsonKey(ignore: true)
  Future<Uint8List?>? thumbnailAsBytesFuture;
  @JsonKey(ignore: true)
  bool _gotThumbnail = false;
  @JsonKey(ignore: true)
  bool _gettingThumbnail = false;

  Picture copyWith(Picture picture) {
    final ret = Picture()
      ..largeUrl = picture.largeUrl
      ..mediumUrl = picture.mediumUrl
      ..thumbnailUrl = picture.thumbnailUrl;

    return ret;
  }

  Picture getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new Picture instance
  /// from a map. Pass the map to the generated `_$PictureFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Picture.
  static Picture _fromJson(Map<String, dynamic> json) {
    final picture = _$PictureFromJson(json);
    return picture;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PictureToJson`.
  Map<String, dynamic> toJson() => _$PictureToJson(this);

  Future<void> getAllImages() async {
    await getThumbnailImage();
    await getMediumImage();
    await getLargeImage();
  }

  bool hasGotLargeImage() {
    return _gotLarge;
  }

  bool isGettingLargeImage() {
    return _gettingLarge;
  }

  Future<Uint8List?> getLargeImage() async {
    return largeAsBytesFuture = _getLargeImage();
  }

  Future<Uint8List?> getLargeImageBytes() async {
    if (largeAsBytes != null && largeAsBytes!.isNotEmpty) {
      return largeAsBytes;
    } else {
      _gotLarge = false;
      return _getLargeImage();
    }
  }

  Future<Uint8List?> _getLargeImage() async {
    Uint8List? ret;
    if (largeUrl != null && largeUrl!.path.isNotEmpty) {
      if (!_gotLarge && !_gettingLarge) {
        _gettingLarge = true;
        final bytes = await largeUrl!.downloadBytes();
        if (bytes != null && bytes.isNotEmpty) {
          largeAsBytes = bytes;
          _gotLarge = true;
        }
        _gettingLarge = false;
        ret = bytes;
      }
      return ret;
    }
  }

  bool hasGotMediumImage() {
    return _gotMedium;
  }

  bool isGettingMediumImage() {
    return _gettingMedium;
  }

  Future<Uint8List?> getMediumImage() async {
    return mediumAsBytesFuture = _getMediumImage();
  }

  Future<Uint8List?> getMediumImageBytes() async {
    if (mediumAsBytes != null && mediumAsBytes!.isNotEmpty) {
      return mediumAsBytes;
    } else {
      _gotMedium = false;
      return _getMediumImage();
    }
  }

  Future<Uint8List?> _getMediumImage() async {
    Uint8List? ret;
    if (mediumUrl != null && mediumUrl!.path.isNotEmpty) {
      if (!_gotMedium && !_gettingMedium) {
        _gettingMedium = true;
        final bytes = await mediumUrl!.downloadBytes();
        if (bytes != null && bytes.isNotEmpty) {
          mediumAsBytes = bytes;
          _gotMedium = true;
        }
        _gettingMedium = false;
        ret = bytes;
      }
      return ret;
    }
  }

  bool hasGotThumbnailImage() {
    return _gotThumbnail;
  }

  bool isGettingThumbnailImage() {
    return _gettingThumbnail;
  }

  Future<Uint8List?> getThumbnailImage() async {
    return thumbnailAsBytesFuture = _getThumbnailImage();
  }

  Future<Uint8List?> getThumbnailImageBytes() async {
    if (thumbnailAsBytes != null && thumbnailAsBytes!.isNotEmpty) {
      return thumbnailAsBytes;
    } else {
      _gotThumbnail = false;
      return _getThumbnailImage();
    }
  }

  Future<Uint8List?> _getThumbnailImage() async {
    Uint8List? ret;
    if (thumbnailUrl != null && thumbnailUrl!.path.isNotEmpty) {
      if (!_gotThumbnail && !_gettingThumbnail) {
        _gettingThumbnail = true;
        final bytes = await thumbnailUrl!.downloadBytes();
        if (bytes != null && bytes.isNotEmpty) {
          thumbnailAsBytes = bytes;
          _gotThumbnail = true;
        }
        _gettingThumbnail = false;
        ret = bytes;
      }
      return ret;
    }
  }
}
