import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';

class MyToggleButtonTheme extends ToggleButtonsThemeData {
  MyToggleButtonTheme(this.myColorScheme)
      : super(
          color: myColorScheme.primary,
          highlightColor: myColorScheme.primary.withOpacity(0.16),
          splashColor: myColorScheme.secondary,
          hoverColor: myColorScheme.primary.withOpacity(0.04),
          selectedColor: myColorScheme.secondary,
          disabledColor: myColorScheme.onSurface.withOpacity(0.12),
        );

  final MyColorScheme myColorScheme;
}
