import 'package:flutter/material.dart';

/// Envolve a árvore de widgets e, sempre que qualquer campo de texto
/// ([EditableText]) recebe foco, seleciona automaticamente todo o seu conteúdo.
///
/// Isso evita ter que configurar `onTap`/`FocusNode` em cada `TextField`/
/// `TextFormField` espalhado pelo app: o comportamento passa a ser global.
class SelectAllOnFocus extends StatefulWidget {
  const SelectAllOnFocus({super.key, required this.child});

  final Widget child;

  @override
  State<SelectAllOnFocus> createState() => _SelectAllOnFocusState();
}

class _SelectAllOnFocusState extends State<SelectAllOnFocus> {
  FocusNode? _lastFocused;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = FocusManager.instance.primaryFocus;
    if (focused == _lastFocused) return;
    _lastFocused = focused;
    if (focused == null || !focused.hasFocus) return;

    // O contexto do nó focado corresponde ao EditableText quando um campo de
    // texto ganha foco. Buscamos o estado para acessar o controller.
    final context = focused.context;
    if (context == null) return;

    final editableText = context.findAncestorStateOfType<EditableTextState>() ??
        _findEditableTextDescendant(context);
    if (editableText == null) return;

    // Adiamos para o próximo frame: ao focar via toque o framework pode
    // reposicionar o cursor logo após, então selecionamos depois disso.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (FocusManager.instance.primaryFocus != focused) return;
      final controller = editableText.widget.controller;
      final text = controller.text;
      if (text.isEmpty) return;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: text.length,
      );
    });
  }

  EditableTextState? _findEditableTextDescendant(BuildContext context) {
    EditableTextState? result;
    void visitor(Element element) {
      if (result != null) return;
      if (element is StatefulElement && element.state is EditableTextState) {
        result = element.state as EditableTextState;
        return;
      }
      element.visitChildren(visitor);
    }

    if (context is Element) {
      context.visitChildren(visitor);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
