import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

extension UriExtensions on Uri {
  String? lastPath() {
    String? ret;
    if (pathSegments.isNotEmpty) {
      ret = pathSegments[pathSegments.length - 1];
    } else {
      ret = null;
    }
    return ret;
  }

  String? penultimatePath() {
    String? ret;
    if (pathSegments.length > 1) {
      ret = pathSegments[pathSegments.length - 2];
    } else {
      ret = null;
    }
    return ret;
  }

  Future<Uint8List?> downloadBytes() async {
    Uint8List? bytes;
    if (path.isNotEmpty && path.toLowerCase() != 'null') {
      bytes = await http.readBytes(this);
    }
    return bytes;
  }
}
