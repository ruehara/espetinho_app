import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../orders/domain/order_repository.dart';
import '../../reports/domain/report_repository.dart';

class HomeState extends Equatable {
  const HomeState({
    this.openOrders = 0,
    this.closedOrders = 0,
    this.todayTotal = 0,
    this.loading = true,
  });

  final int openOrders;
  final int closedOrders;
  final double todayTotal;
  final bool loading;

  HomeState copyWith({int? openOrders, int? closedOrders, double? todayTotal, bool? loading}) =>
      HomeState(
        openOrders: openOrders ?? this.openOrders,
        closedOrders: closedOrders ?? this.closedOrders,
        todayTotal: todayTotal ?? this.todayTotal,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [openOrders, closedOrders, todayTotal, loading];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._orderRepository, this._reportRepository) : super(const HomeState()) {
    _sub = _orderRepository.watchOrders().listen((orders) async {
      final openOrders = orders.where((o) => o.isOpen).length;
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, now.day);
      final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final sales = await _reportRepository.sales(from, to);
      emit(state.copyWith(
        openOrders: openOrders,
        closedOrders: sales.orderCount,
        todayTotal: sales.total,
        loading: false,
      ));
    });
  }

  final OrderRepository _orderRepository;
  final ReportRepository _reportRepository;
  late final StreamSubscription _sub;

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
