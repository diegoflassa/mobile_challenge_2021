import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/patient.dart';
import 'package:mobile_challenge_2021_flutter/enums/gender.dart';
import 'package:mobile_challenge_2021_flutter/i18n/app_localizations.dart';

class Helper {
  static Color colorFromString(String color) {
    var value = 0;
    if (color.contains('Color(0x')) {
      // kind of hacky..
      final valueString = color.split('(0x')[1].split(')')[0];
      value = int.parse(valueString, radix: 16);
    }
    return Color(value);
  }

  static DateTime datetimeFromInt(int timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }

  static String? parameterToString(String? param) {
    return (param != null) ? param.replaceAll('_', ' ') : null;
  }

  static ColorFiltered? grayScale(Image? image) {
    ColorFiltered? ret;
    if (image != null) {
      ret = ColorFiltered(
        colorFilter: const ColorFilter.matrix(
          <double>[
            // GrayScale, based on
            // https://www.w3.org/TR/filter-effects-1/#grayscaleEquivalent
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0, 0, 0, 1, 0,
          ],
        ),
        child: image,
      );
    }
    return ret;
  }

  static Uint8List stringToBytes(String source) {
    // String (Dart uses UTF-16) to bytes
    final list = <int>[];
    source.runes.forEach((rune) {
      if (rune >= 0x10000) {
        rune -= 0x10000;
        final firstWord = (rune >> 10) + 0xD800;
        list.add(firstWord >> 8);
        list.add(firstWord & 0xFF);
        final secondWord = (rune & 0x3FF) + 0xDC00;
        list.add(secondWord >> 8);
        list.add(secondWord & 0xFF);
      } else {
        list.add(rune >> 8);
        list.add(rune & 0xFF);
      }
    });
    return Uint8List.fromList(list);
  }

  static String bytesToString(Uint8List bytes) {
    // Bytes to UTF-16 string
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length;) {
      final firstWord = (bytes[i] << 8) + bytes[i + 1];
      if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        final secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        buffer.writeCharCode(
            ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
        i += 4;
      } else {
        buffer.writeCharCode(firstWord);
        i += 2;
      }
    }
    // Outcome
    return buffer.toString();
  }

  static List<Patient> patientsJsonToPatientsList(dynamic jsonData) {
    final ret = <Patient>[];
    if (jsonData != null && jsonData is Map<String, dynamic>) {
      for (final Map<String, dynamic> entity in jsonData['results']) {
        ret.add(Patient.fromJson(entity));
      }
    }
    return ret;
  }

  static Gender genderStringToEnum(String gender) {
    var ret = Gender.UNKNOWN;
    if (gender == 'female') {
      ret = Gender.FEMALE;
    } else if (gender == 'male') {
      ret = Gender.MALE;
    }
    return ret;
  }

  static String genderEnumToString(BuildContext context, Gender gender,
      {bool unknownAsBoth = false}) {
    var ret = AppLocalizations.of(context).unknown;
    if (unknownAsBoth) {
      ret = AppLocalizations.of(context).any;
    }
    switch (gender) {
      case Gender.MALE:
        ret = AppLocalizations.of(context).male;
        break;
      case Gender.FEMALE:
        ret = AppLocalizations.of(context).female;
        break;
      case Gender.PREFER_NOT_TO_SAY:
        ret = AppLocalizations.of(context).preferNotToSay;
        break;
      case Gender.UNKNOWN:
        ret = AppLocalizations.of(context).unknown;
        if (unknownAsBoth) {
          ret = AppLocalizations.of(context).any;
        }
        break;
    }
    return ret;
  }
}
