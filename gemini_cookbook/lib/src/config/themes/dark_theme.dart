import 'package:flutter/material.dart';

import 'color_source.dart';

class DarkTheme {
  static ThemeData get themeData {
    return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: ColorConstants.primary2,
          onPrimary: ColorConstants.onPrimary2,
          primaryContainer: ColorConstants.primaryContainer2,
          onPrimaryContainer: ColorConstants.onPrimaryContainer2,
          secondary: ColorConstants.secondary2,
          onSecondary: ColorConstants.onSecondary2,
          secondaryContainer: ColorConstants.secondaryContainer2,
          onSecondaryContainer: ColorConstants.onSecondaryContainer2,
          error: ColorConstants.error2,
          onError: ColorConstants.onError2,
          errorContainer: ColorConstants.errorContainer2,
          onErrorContainer: ColorConstants.onErrorContainer2,
          background: ColorConstants.background2,
          onBackground: ColorConstants.onBackground2,
          surface: ColorConstants.surface2,
          onSurface: ColorConstants.onSurface2,
          surfaceVariant: ColorConstants.surfaceVariant2,
          onSurfaceVariant: ColorConstants.onSurfaceVariant2,
          surfaceTint: ColorConstants.surfaceTint2,
          outline: ColorConstants.outline2,
          outlineVariant: ColorConstants.outlineVariant2,
          shadow: ColorConstants.shadow2,
          scrim: ColorConstants.scrim2,
          inversePrimary: ColorConstants.inversePrimary2,
          inverseSurface: ColorConstants.inverseSurface2,
          onInverseSurface: ColorConstants.onInverseSurface2,
        ));
  }
}
