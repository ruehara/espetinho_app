import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _qty = NumberFormat.decimalPattern('pt_BR');
final _date = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
final _dayMonth = DateFormat('dd/MM', 'pt_BR');

String money(num? value) => _currency.format(value ?? 0);
String qty(num value) => _qty.format(value);
String dateTimeLabel(DateTime value) => _date.format(value);
String dayLabel(DateTime value) => _dayMonth.format(value);
