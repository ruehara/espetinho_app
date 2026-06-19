import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/order_entities.dart';
import '../domain/order_repository.dart';

class OrdersState extends Equatable {
  const OrdersState({this.orders = const [], this.loading = true});

  final List<OrderSummary> orders;
  final bool loading;

  List<OrderSummary> get open => orders.where((o) => o.isOpen).toList();
  List<OrderSummary> get closed => orders.where((o) => !o.isOpen).toList();

  OrdersState copyWith({List<OrderSummary>? orders, bool? loading}) =>
      OrdersState(orders: orders ?? this.orders, loading: loading ?? this.loading);

  @override
  List<Object?> get props => [orders, loading];
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(const OrdersState()) {
    _sub = _repository.watchOrders().listen((orders) {
      emit(state.copyWith(orders: orders, loading: false));
    });
  }

  final OrderRepository _repository;
  late final StreamSubscription _sub;

  Future<void> closeOrder(int id, {int discountPercent = 0}) =>
      _repository.closeOrder(id, discountPercent: discountPercent);
  Future<void> deleteOrder(int id) => _repository.deleteOrder(id);

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
