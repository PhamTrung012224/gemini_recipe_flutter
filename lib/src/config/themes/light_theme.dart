import 'package:flutter/material.dart';

import 'color_source.dart';

class LightTheme {
  static ThemeData get themeData {
    return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: ColorConstants.primary1,
          onPrimary: ColorConstants.onPrimary1,
          primaryContainer: ColorConstants.primaryContainer1,
          onPrimaryContainer: ColorConstants.onPrimaryContainer1,
          secondary: ColorConstants.secondary1,
          onSecondary: ColorConstants.onSecondary1,
          secondaryContainer: ColorConstants.secondaryContainer1,
          onSecondaryContainer: ColorConstants.onSecondaryContainer1,
          error: ColorConstants.error1,
          onError: ColorConstants.onError1,
          errorContainer: ColorConstants.errorContainer1,
          onErrorContainer: ColorConstants.onErrorContainer1,
          background: ColorConstants.background1,
          onBackground: ColorConstants.onBackground1,
          surface: ColorConstants.surface1,
          onSurface: ColorConstants.onSurface1,
          surfaceVariant: ColorConstants.surfaceVariant1,
          onSurfaceVariant: ColorConstants.onSurfaceVariant1,
          surfaceTint: ColorConstants.surfaceTint1,
          outline: ColorConstants.outline1,
          outlineVariant: ColorConstants.outlineVariant1,
          shadow: ColorConstants.shadow1,
          scrim: ColorConstants.scrim1,
          inversePrimary: ColorConstants.inversePrimary1,
          inverseSurface: ColorConstants.inverseSurface1,
          onInverseSurface: ColorConstants.onInverseSurface1,
        ));
  }
}
