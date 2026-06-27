import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/report_repository.dart';

class ReportsState extends Equatable {
  const ReportsState({
    required this.from,
    required this.to,
    this.loading = true,
    this.sales,
    this.topProducts = const [],
    this.profit,
  });

  final DateTime from;
  final DateTime to;
  final bool loading;
  final SalesReport? sales;
  final List<TopProductItem> topProducts;
  final ProfitReport? profit;

  ReportsState copyWith({
    DateTime? from,
    DateTime? to,
    bool? loading,
    SalesReport? sales,
    List<TopProductItem>? topProducts,
    ProfitReport? profit,
  }) =>
      ReportsState(
        from: from ?? this.from,
        to: to ?? this.to,
        loading: loading ?? this.loading,
        sales: sales ?? this.sales,
        topProducts: topProducts ?? this.topProducts,
        profit: profit ?? this.profit,
      );

  @override
  List<Object?> get props =>
      [from, to, loading, sales, topProducts, profit];
}

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._repository)
      : super(ReportsState(
          from: DateTime.now().subtract(const Duration(days: 30)),
          to: DateTime.now(),
        )) {
    refresh();
  }

  final ReportRepository _repository;

  Future<void> setRange(DateTime from, DateTime to) async {
    emit(state.copyWith(from: from, to: to));
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true));
    final from = DateTime(state.from.year, state.from.month, state.from.day);
    final to = DateTime(state.to.year, state.to.month, state.to.day, 23, 59, 59);
    final sales = await _repository.sales(from, to);
    final top = await _repository.topProducts(from, to);
    final profit = await _repository.profit(from, to);
    emit(state.copyWith(
      loading: false,
      sales: sales,
      topProducts: top,
      profit: profit,
    ));
  }
}
