import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';

class MyAppBarTheme extends AppBarTheme {
  MyAppBarTheme(this.myColorScheme)
      : super(
          brightness: myColorScheme.brightness,
          color: myColorScheme.primaryVariant,
        );

  final MyColorScheme myColorScheme;
}
