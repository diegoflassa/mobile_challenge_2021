import 'dart:typed_data';

import 'package:mobile_challenge_2021_flutter/extensions/uri_extensions.dart';
import 'package:mobile_challenge_2021_flutter/helpers/my_logger.dart';

extension StringExtensions on String {

  bool parseBool() {
    return toLowerCase() == 'true';
  }

  bool isUrl() {
    bool ret;
    try {
      Uri.parse(this);
      ret = true;
    } on FormatException catch (ex) {
      MyLogger().logger.i(ex.toString());
      ret = false;
    }
    return ret;
  }

  Future<Uint8List?> downloadBytes() async {
    final uri = Uri.parse(this);
    return uri.downloadBytes();
  }
}
