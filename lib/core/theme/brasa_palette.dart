import 'package:flutter/material.dart';

/// Paleta da direção visual "Brasa" (clima de churrasco), nas duas variantes
/// (claro e escuro). Os tokens espelham as variáveis CSS do protótipo:
/// bg, surf, elev, ink, sub, line, brand (verde), acc (laranja CTA),
/// accd (laranja escuro) e tint (fundo tonal de ícones/realces).
class BrasaPalette {
  const BrasaPalette({
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

  /// Brasa escuro — coluna "B · Brasa" do protótipo.
  static const dark = BrasaPalette(
    bg: Color(0xFF161310),
    surf: Color(0xFF211D17),
    elev: Color(0xFF2B261D),
    ink: Color(0xFFF4EFE6),
    sub: Color(0xFFA89D8B),
    line: Color(0xFF332E24),
    brand: Color(0xFF37A86E),
    acc: Color(0xFFEE6A2C),
    accd: Color(0xFFC2470F),
    tint: Color(0xFF2A2117),
  );

  /// Brasa claro — variante "B · Brasa — claro" do protótipo.
  static const light = BrasaPalette(
    bg: Color(0xFFFAF6EF),
    surf: Color(0xFFFFFFFF),
    elev: Color(0xFFF3ECE1),
    ink: Color(0xFF211B12),
    sub: Color(0xFF897D6A),
    line: Color(0xFFEBE3D5),
    brand: Color(0xFF2F8F5B),
    acc: Color(0xFFE0792B),
    accd: Color(0xFFC2470F),
    tint: Color(0xFFFBEEE1),
  );
}
