import 'package:flutter/material.dart';

const kGradientStyle = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2588F1),
      Color(0xFF0040E7),
    ],
  ),
);

const kGradientStyleAlt = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF81c497),
      Color(0xFF0e8e38),
    ],
  ),
);

ThemeData kThemeStyle = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF031168),
  scaffoldBackgroundColor: Color(0xFF031168),
);

ThemeData kThemeStyleGreen = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF033b15),
  scaffoldBackgroundColor: Color(0xFF033b15),
);
