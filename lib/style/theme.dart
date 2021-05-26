import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFFff8552);
  static const Color loginGradientEnd = const Color(0xFFff8552);
  //
  // static const Color loginGradientStart = const Color(0xFFff7f7f);
  // static const Color loginGradientEnd = const Color(0xFF7f7fff);
  //
  // // MORANDI COLORS
  // static const Color loginGradientStart = const Color(0xFFff7f7f);
  // static const Color loginGradientEnd = const Color(0xFF7f7fff);


  // static const Color loginGradientStart = const Color(0xFF9AAAC2);
  // static const Color loginGradientEnd = const Color(0xFF9AAAC2);

  // static const Color loginGradientStart = const Color(0xFFD3B8B4);
  // static const Color loginGradientEnd = const Color(0xFFD3B8B4);

  static const Color background = const Color(0xFFfdf6ee);


  //CABAB4

  //FDD0D6

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}