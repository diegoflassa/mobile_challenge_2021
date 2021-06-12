import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021_flutter/ui/themes/my_color_scheme.dart';

class MyButtonTheme extends ButtonThemeData {
  const MyButtonTheme(this.myColorScheme)
      : super(
          colorScheme: myColorScheme,
        );

  final MyColorScheme myColorScheme;
}
