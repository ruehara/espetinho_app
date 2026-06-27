import 'package:flutter/material.dart';

import 'brasa_palette.dart';

/// Expõe os tokens da paleta Brasa que não cabem bem no [ColorScheme] padrão
/// (verde da marca, superfície elevada, fundo tonal, bordas, texto secundário),
/// para que as telas leiam as cores via `BrasaColors.of(context)` mantendo a
/// consistência entre as variantes claro/escuro.
@immutable
class BrasaColors extends ThemeExtension<BrasaColors> {
  const BrasaColors({
    required this.bg,
    required this.surf,
    required this.elev,
    required this.ink,
    required this.sub,
    required this.line,
    required this.brand,
    required this.acc,
    required this.accd,
    required this.tint,
  });

  factory BrasaColors.fromPalette(BrasaPalette p) => BrasaColors(
        bg: p.bg,
        surf: p.surf,
        elev: p.elev,
        ink: p.ink,
        sub: p.sub,
        line: p.line,
        brand: p.brand,
        acc: p.acc,
        accd: p.accd,
        tint: p.tint,
      );

  final Color bg;
  final Color surf;
  final Color elev;
  final Color ink;
  final Color sub;
  final Color line;
  final Color brand;
  final Color acc;
  final Color accd;
  final Color tint;

  /// Atalho para ler a extensão a partir do tema atual.
  static BrasaColors of(BuildContext context) =>
      Theme.of(context).extension<BrasaColors>()!;

  @override
  BrasaColors copyWith({
    Color? bg,
    Color? surf,
    Color? elev,
    Color? ink,
    Color? sub,
    Color? line,
    Color? brand,
    Color? acc,
    Color? accd,
    Color? tint,
  }) {
    return BrasaColors(
      bg: bg ?? this.bg,
      surf: surf ?? this.surf,
      elev: elev ?? this.elev,
      ink: ink ?? this.ink,
      sub: sub ?? this.sub,
      line: line ?? this.line,
      brand: brand ?? this.brand,
      acc: acc ?? this.acc,
      accd: accd ?? this.accd,
      tint: tint ?? this.tint,
    );
  }

  @override
  BrasaColors lerp(ThemeExtension<BrasaColors>? other, double t) {
    if (other is! BrasaColors) return this;
    return BrasaColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surf: Color.lerp(surf, other.surf, t)!,
      elev: Color.lerp(elev, other.elev, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      sub: Color.lerp(sub, other.sub, t)!,
      line: Color.lerp(line, other.line, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      acc: Color.lerp(acc, other.acc, t)!,
      accd: Color.lerp(accd, other.accd, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
    );
  }
}
