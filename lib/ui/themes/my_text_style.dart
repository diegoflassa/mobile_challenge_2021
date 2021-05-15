import 'package:flutter/material.dart';

class MyTextStyle extends TextStyle {
  const MyTextStyle() : super();

  const MyTextStyle.black()
      : super(
          color: Colors.black,
        );

  const MyTextStyle.blackBold()
      : super(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

  const MyTextStyle.bold()
      : super(
          fontWeight: FontWeight.bold,
        );

  const MyTextStyle.title()
      : super(
          fontSize: 20,
        );

  const MyTextStyle.white()
      : super(
          color: Colors.white,
        );
}
