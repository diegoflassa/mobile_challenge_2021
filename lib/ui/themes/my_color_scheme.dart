import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/extensions/color_extensions.dart';

class MyColorScheme extends ColorScheme {
  factory MyColorScheme() {
    return _instance;
  }

  MyColorScheme._internal()
      : super(
          primary: ColorExtensions.fromHex('#FF0083CA'),
          primaryVariant: ColorExtensions.fromHex('#FF00AFAD'),
          secondary: ColorExtensions.fromHex('#FF0083CA'),
          secondaryVariant: ColorExtensions.fromHex('#FFF26522'),
          surface: ColorExtensions.fromHex('#FFFFFFFF'),
          background: ColorExtensions.fromHex('#FF003461'),
          error: ColorExtensions.fromHex('#FFF4511E'),
          onPrimary: ColorExtensions.fromHex('#FFFFFFFF'),
          onSecondary: ColorExtensions.fromHex('#FF000000'),
          onSurface: ColorExtensions.fromHex('#FF000000'),
          onBackground: ColorExtensions.fromHex('#FF000000'),
          onError: ColorExtensions.fromHex('#FF000000'),
          brightness: Brightness.light,
        );

  static final MyColorScheme _instance = MyColorScheme._internal();

  MaterialColor get primaryAsMaterial {
    return MaterialColor(primary.value, _getColorCodesFromColor(primary));
  }

  Map<int, Color> _getColorCodesFromColor(Color color) {
    return {
      50: Color.fromRGBO(color.red, color.green, color.blue, .1),
      100: Color.fromRGBO(color.red, color.green, color.blue, .2),
      200: Color.fromRGBO(color.red, color.green, color.blue, .3),
      300: Color.fromRGBO(color.red, color.green, color.blue, .4),
      400: Color.fromRGBO(color.red, color.green, color.blue, .5),
      500: Color.fromRGBO(color.red, color.green, color.blue, .6),
      600: Color.fromRGBO(color.red, color.green, color.blue, .7),
      700: Color.fromRGBO(color.red, color.green, color.blue, .8),
      800: Color.fromRGBO(color.red, color.green, color.blue, .9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1),
    };
  }
}
