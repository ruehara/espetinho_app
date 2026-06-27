import 'package:flutter/material.dart';

import 'brasa_colors.dart';
import 'brasa_palette.dart';

/// Tema da direção visual "Brasa" (churrasco). Monta um [ThemeData] coerente a
/// partir da [BrasaPalette] — laranja como ação primária, verde como marca/
/// status — com tipografia Manrope (UI) + Space Grotesk (display) e os themes
/// de componente que dão o acabamento arredondado do protótipo.
class AppTheme {
  static const _uiFont = 'Manrope';
  static const _dispFont = 'SpaceGrotesk';

  static ThemeData light() => _build(BrasaPalette.light, Brightness.light);

  static ThemeData dark() => _build(BrasaPalette.dark, Brightness.dark);

  static ThemeData _build(BrasaPalette p, Brightness brightness) {
    final onAcc = _onColor(p.acc);
    final onBrand = _onColor(p.brand);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: p.acc,
      onPrimary: onAcc,
      primaryContainer: p.tint,
      onPrimaryContainer: p.accd,
      secondary: p.brand,
      onSecondary: onBrand,
      secondaryContainer: p.tint,
      onSecondaryContainer: p.brand,
      tertiary: p.brand,
      onTertiary: onBrand,
      error: p.accd,
      onError: Colors.white,
      errorContainer: p.tint,
      onErrorContainer: p.accd,
      surface: p.surf,
      onSurface: p.ink,
      surfaceContainerLowest: p.bg,
      surfaceContainerLow: p.surf,
      surfaceContainer: p.surf,
      surfaceContainerHigh: p.elev,
      surfaceContainerHighest: p.elev,
      onSurfaceVariant: p.sub,
      outline: p.line,
      outlineVariant: p.line,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: p.ink,
      onInverseSurface: p.bg,
      inversePrimary: p.acc,
    );

    final baseText = (brightness == Brightness.dark
            ? Typography.material2021().white
            : Typography.material2021().black)
        .apply(fontFamily: _uiFont, bodyColor: p.ink, displayColor: p.ink);

    final textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(fontFamily: _dispFont),
      displayMedium: baseText.displayMedium?.copyWith(fontFamily: _dispFont),
      displaySmall: baseText.displaySmall?.copyWith(fontFamily: _dispFont),
      headlineLarge: baseText.headlineLarge
          ?.copyWith(fontFamily: _dispFont, fontWeight: FontWeight.w700),
      headlineMedium: baseText.headlineMedium
          ?.copyWith(fontFamily: _dispFont, fontWeight: FontWeight.w700),
      headlineSmall: baseText.headlineSmall
          ?.copyWith(fontFamily: _dispFont, fontWeight: FontWeight.w700),
      titleLarge: baseText.titleLarge
          ?.copyWith(fontFamily: _dispFont, fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.bg,
      canvasColor: p.bg,
      fontFamily: _uiFont,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[BrasaColors.fromPalette(p)],
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _dispFont,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: p.ink,
        ),
        iconTheme: IconThemeData(color: p.ink),
      ),
      cardTheme: CardThemeData(
        color: p.surf,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.line),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: p.sub),
      listTileTheme: ListTileThemeData(
        iconColor: p.sub,
        textColor: p.ink,
        subtitleTextStyle: TextStyle(color: p.sub, fontSize: 13),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.acc,
          foregroundColor: onAcc,
          textStyle: const TextStyle(
              fontFamily: _uiFont, fontWeight: FontWeight.w700, fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.acc,
          textStyle:
              const TextStyle(fontFamily: _uiFont, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.acc,
          side: BorderSide(color: p.line),
          textStyle:
              const TextStyle(fontFamily: _uiFont, fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.acc,
        foregroundColor: onAcc,
        elevation: 4,
        extendedTextStyle: const TextStyle(
            fontFamily: _uiFont, fontWeight: FontWeight.w700, fontSize: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.tint,
        side: BorderSide(color: p.line),
        labelStyle: TextStyle(
            color: p.ink, fontWeight: FontWeight.w600, fontFamily: _uiFont),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surf,
        isDense: true,
        hintStyle: TextStyle(color: p.sub),
        labelStyle: TextStyle(color: p.sub),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.acc, width: 1.6),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.acc : null),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? p.acc.withValues(alpha: 0.4) : null),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.acc : p.sub),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.acc : Colors.transparent),
        checkColor: WidgetStateProperty.all(onAcc),
        side: BorderSide(color: p.sub, width: 1.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surf,
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titleTextStyle: TextStyle(
            fontFamily: _dispFont,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: p.ink),
        contentTextStyle: TextStyle(fontFamily: _uiFont, color: p.ink),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surf,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.elev,
        contentTextStyle: TextStyle(color: p.ink, fontFamily: _uiFont),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Cor de texto/ícone legível sobre um fundo colorido (preto ou branco
  /// conforme a luminância).
  static Color _onColor(Color c) =>
      c.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
