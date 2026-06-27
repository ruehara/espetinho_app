import 'package:flutter/material.dart';

import '../../theme/brasa_colors.dart';

/// Biblioteca de componentes da direção visual "Brasa", derivados dos padrões
/// repetidos no protótipo. Todos leem as cores via [BrasaColors] para funcionar
/// nas duas variantes (claro/escuro).

const _dispFont = 'SpaceGrotesk';

/// Rótulo de seção em caixa-alta com espaçamento — usado em "Módulos",
/// "Inclusos", "Adicionais", "Fechados", etc.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.padding});

  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: c.sub,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

/// Card padrão Brasa: superfície `surf` com borda `line` arredondada. A variação
/// [accentBorderLeft] adiciona a barra laranja à esquerda (pedido em preparo).
class BrasaCard extends StatelessWidget {
  const BrasaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.accentBorderLeft = false,
    this.radius = 18,
    this.color,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool accentBorderLeft;
  final double radius;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    final border = BorderRadius.circular(radius);
    // Uma BoxDecoration com borderRadius exige borda uniforme, então a barra de
    // destaque à esquerda é desenhada como uma tira posicionada (clipada pelos
    // cantos arredondados do Material). Stack evita o stretch de altura, que
    // falha dentro de um ListView (cross-axis sem limite).
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: border,
        border: Border.all(color: c.line),
      ),
      padding: padding,
      child: child,
    );
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        elevation: 1,
        color: color ?? c.surf,
        borderRadius: border,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: accentBorderLeft
              ? Stack(
                  children: [
                    card,
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 3, color: c.brand),
                    ),
                  ],
                )
              : card,
        ),
      ),
    );
  }
}

/// Quadrado com fundo tonal `tint` e ícone colorido (laranja por padrão),
/// reaproveitado nos módulos da Home, avatares de pedido e header da montagem.
class TintIcon extends StatelessWidget {
  const TintIcon(
    this.icon, {
    super.key,
    this.size = 40,
    this.iconSize = 22,
    this.radius = 12,
    this.color,
    this.filled = false,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final double radius;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.tint,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: color ?? c.acc),
    );
  }
}

/// Pílula de status (Em preparo / Novo / Cozinha / pago), com variantes de cor.
enum StatusTone { accent, brand, neutral }

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = StatusTone.neutral, this.icon});

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    late final Color fg;
    late final Color bg;
    switch (tone) {
      case StatusTone.accent:
        fg = c.acc;
        bg = c.acc.withValues(alpha: 0.16);
        break;
      case StatusTone.brand:
        fg = c.brand;
        bg = c.brand.withValues(alpha: 0.16);
        break;
      case StatusTone.neutral:
        fg = c.sub;
        bg = c.tint;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
                color: fg, fontWeight: FontWeight.w700, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

/// Botão de ação primária (CTA laranja) em formato de pílula, com ícone
/// opcional. Usado nos rodapés "Adicionar", "Novo pedido", "Salvar".
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.expanded = false,
    this.radius = 15,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final bool expanded;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    final enabled = onPressed != null;
    final fg = c.acc.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: enabled ? c.acc : c.elev,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: enabled ? fg : c.sub),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: enabled ? fg : c.sub,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, size: 20, color: enabled ? fg : c.sub),
          ],
        ],
      ),
    );
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onPressed,
        child: child,
      ),
    );
  }
}

/// Rodapé fixo do protótipo: borda superior `line`, fundo `surf`, com o "Total"
/// (rótulo + valor em Space Grotesk) à esquerda e uma ação (botão) à direita.
class BrasaTotalBar extends StatelessWidget {
  const BrasaTotalBar({
    super.key,
    required this.value,
    required this.action,
    this.label = 'Total',
  });

  final String label;
  final String value;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Material(
      color: c.surf,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: c.line)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: c.sub,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: _dispFont,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(child: action),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stepper compacto –/valor/+ no estilo do protótipo (cápsula `elev`).
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.label,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.elev,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove, color: c.acc, onPressed: onDecrement),
          Container(
            constraints: const BoxConstraints(minWidth: 24),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: _dispFont,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: c.ink,
              ),
            ),
          ),
          _StepButton(icon: Icons.add, color: c.acc, onPressed: onIncrement),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.color, this.onPressed});

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: onPressed == null ? color.withValues(alpha: 0.4) : color),
      ),
    );
  }
}
