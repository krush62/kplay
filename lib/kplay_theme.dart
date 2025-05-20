import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(final BuildContext context, final String bodyFontString, final String displayFontString)
{
  final TextTheme baseTextTheme = Theme.of(context).textTheme;
  final TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  final TextTheme displayTextTheme =
  GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  final TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8e4955),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd9dd),
      onPrimaryContainer: Color(0xff72333e),
      secondary: Color(0xff76565a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffd9dd),
      onSecondaryContainer: Color(0xff5c3f43),
      tertiary: Color(0xff795831),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffddb9),
      onTertiaryContainer: Color(0xff5e411c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff22191a),
      onSurfaceVariant: Color(0xff524345),
      outline: Color(0xff847374),
      outlineVariant: Color(0xffd7c1c3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xffffb2bc),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff3b0714),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff72333e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff2c1518),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff5c3f43),
      tertiaryFixed: Color(0xffffddb9),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff5e411c),
      surfaceDim: Color(0xffe7d6d7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaeb),
      surfaceContainerHigh: Color(0xfff6e4e5),
      surfaceContainerHighest: Color(0xfff0dedf),
    );

  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d222e),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa05863),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a2f33),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff856569),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4b310d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff89673e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff170f10),
      onSurfaceVariant: Color(0xff403334),
      outline: Color(0xff5e4f50),
      outlineVariant: Color(0xff7a696a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xffffb2bc),
      primaryFixed: Color(0xffa05863),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff83404c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff856569),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6b4d51),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff89673e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6e4f28),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3c3c4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfff6e4e5),
      surfaceContainerHigh: Color(0xffead9da),
      surfaceContainerHighest: Color(0xffdececf),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff501824),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff753540),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3e2529),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5f4145),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff402704),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff61431e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff36292a),
      outlineVariant: Color(0xff544547),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xffffb2bc),
      primaryFixed: Color(0xff753540),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff591f2b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5f4145),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff462b2f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff61431e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff472d09),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5b5b6),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffeeded),
      surfaceContainer: Color(0xfff0dedf),
      surfaceContainerHigh: Color(0xffe1d0d1),
      surfaceContainerHighest: Color(0xffd3c3c4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2bc),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff561d29),
      primaryContainer: Color(0xff72333e),
      onPrimaryContainer: Color(0xffffd9dd),
      secondary: Color(0xffe5bdc1),
      onSecondary: Color(0xff43292d),
      secondaryContainer: Color(0xff5c3f43),
      onSecondaryContainer: Color(0xffffd9dd),
      tertiary: Color(0xffeabf8f),
      onTertiary: Color(0xff452b07),
      tertiaryContainer: Color(0xff5e411c),
      onTertiaryContainer: Color(0xffffddb9),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a1112),
      onSurface: Color(0xfff0dedf),
      onSurfaceVariant: Color(0xffd7c1c3),
      outline: Color(0xff9f8c8e),
      outlineVariant: Color(0xff524345),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff8e4955),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff3b0714),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff72333e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff2c1518),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff5c3f43),
      tertiaryFixed: Color(0xffffddb9),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff5e411c),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff413738),
      surfaceContainerLowest: Color(0xff140c0d),
      surfaceContainerLow: Color(0xff22191a),
      surfaceContainer: Color(0xff261d1e),
      surfaceContainerHigh: Color(0xff312829),
      surfaceContainerHighest: Color(0xff3d3233),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd1d6),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff48121e),
      primaryContainer: Color(0xffc97a86),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcd2d6),
      onSecondary: Color(0xff371f22),
      secondaryContainer: Color(0xffac888c),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5a7),
      onTertiary: Color(0xff382000),
      tertiaryContainer: Color(0xffb08a5e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1112),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffedd7d9),
      outline: Color(0xffc1adaf),
      outlineVariant: Color(0xff9e8c8d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff73343f),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff2c000b),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff5d222e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff200b0e),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff4a2f33),
      tertiaryFixed: Color(0xffffddb9),
      onTertiaryFixed: Color(0xff1c0e00),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff4b310d),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff4d4243),
      surfaceContainerLowest: Color(0xff0c0607),
      surfaceContainerLow: Color(0xff241b1c),
      surfaceContainer: Color(0xff2f2526),
      surfaceContainerHigh: Color(0xff3a3031),
      surfaceContainerHighest: Color(0xff463b3c),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffebed),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffacb8),
      onPrimaryContainer: Color(0xff210006),
      secondary: Color(0xffffebed),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe1b9bd),
      onSecondaryContainer: Color(0xff190609),
      tertiary: Color(0xffffeddd),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe6bb8c),
      onTertiaryContainer: Color(0xff140900),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1a1112),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffebed),
      outlineVariant: Color(0xffd3bebf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      inversePrimary: Color(0xff73343f),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff2c000b),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff200b0e),
      tertiaryFixed: Color(0xffffddb9),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff1c0e00),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff594d4e),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261d1e),
      surfaceContainer: Color(0xff382e2f),
      surfaceContainerHigh: Color(0xff43393a),
      surfaceContainerHighest: Color(0xff4f4445),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(final ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(4.0)),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(14)),
        textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.headlineLarge),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
          ),
        ),
      ),
    ),

    listTileTheme: ListTileThemeData(
      leadingAndTrailingTextStyle: textTheme.titleLarge!.copyWith(color: colorScheme.primary),
      titleTextStyle: textTheme.headlineMedium!.copyWith(color: colorScheme.onSurface),
      subtitleTextStyle: textTheme.bodyLarge!.copyWith(color: colorScheme.primary),
      iconColor: colorScheme.primary,
      contentPadding: const EdgeInsets.only(left: 16, right: 16),
      selectedColor: colorScheme.secondary,
      selectedTileColor: colorScheme.secondaryContainer,
    ),

    sliderTheme: SliderThemeData(
      overlayShape: SliderComponentShape.noOverlay,
      padding: EdgeInsets.zero,
    ),


  );


  List<ExtendedColor> get extendedColors => <ExtendedColor>[
  ];
}

class ExtendedColor {
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
