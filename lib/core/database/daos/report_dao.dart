import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'report_dao.g.dart';

class SalesSummary {
  SalesSummary(this.orderCount, this.totalSales);
  final int orderCount;
  final double totalSales;
}

class DailySales {
  DailySales(this.day, this.orderCount, this.total);
  final String day;
  final int orderCount;
  final double total;
}

class TopProduct {
  TopProduct(this.productId, this.name, this.quantity, this.revenue);
  final int productId;
  final String name;
  final double quantity;
  final double revenue;
}

class ProfitSummary {
  ProfitSummary(this.revenue, this.cost);
  final double revenue;
  final double cost;
  double get profit => revenue - cost;
}

@DriftAccessor(tables: [Orders, OrderItems, Products, Purchases])
class ReportDao extends DatabaseAccessor<AppDatabase> with _$ReportDaoMixin {
  ReportDao(super.db);

  Future<SalesSummary> salesSummary(DateTime from, DateTime to) async {
    final row = await customSelect(
      "SELECT COUNT(*) AS c, COALESCE(SUM(total),0) AS t FROM orders "
      "WHERE status='closed' AND closed_at BETWEEN ? AND ?",
      variables: [Variable<DateTime>(from), Variable<DateTime>(to)],
      readsFrom: {orders},
    ).getSingle();
    return SalesSummary(row.read<int>('c'), row.read<double>('t'));
  }

  Future<List<DailySales>> salesByDay(DateTime from, DateTime to) async {
    final rows = await customSelect(
      "SELECT date(closed_at,'unixepoch','localtime') AS day, COUNT(*) AS c, "
      "COALESCE(SUM(total),0) AS t FROM orders "
      "WHERE status='closed' AND closed_at BETWEEN ? AND ? "
      "GROUP BY day ORDER BY day",
      variables: [Variable<DateTime>(from), Variable<DateTime>(to)],
      readsFrom: {orders},
    ).get();
    return rows
        .map((r) =>
            DailySales(r.read<String>('day'), r.read<int>('c'), r.read<double>('t')))
        .toList();
  }

  Future<List<TopProduct>> topProducts(DateTime from, DateTime to,
      {int limit = 20}) async {
    final rows = await customSelect(
      "SELECT oi.product_id AS pid, oi.product_name AS pname, "
      "SUM(oi.quantity) AS qty, SUM(oi.unit_price*oi.quantity) AS rev "
      "FROM order_items oi JOIN orders o ON o.id = oi.order_id "
      "WHERE o.status='closed' AND o.closed_at BETWEEN ? AND ? "
      "GROUP BY oi.product_id, oi.product_name ORDER BY qty DESC LIMIT ?",
      variables: [
        Variable<DateTime>(from),
        Variable<DateTime>(to),
        Variable<int>(limit),
      ],
      readsFrom: {orderItems, orders},
    ).get();
    return rows
        .map((r) => TopProduct(r.read<int>('pid'), r.read<String>('pname'),
            r.read<double>('qty'), r.read<double>('rev')))
        .toList();
  }

  Future<ProfitSummary> profitSummary(DateTime from, DateTime to) async {
    final row = await customSelect(
      "SELECT COALESCE(SUM(oi.unit_price*oi.quantity),0) AS rev, "
      "COALESCE(SUM(p.cost_price*oi.quantity),0) AS cost "
      "FROM order_items oi "
      "JOIN orders o ON o.id = oi.order_id "
      "JOIN products p ON p.id = oi.product_id "
      "WHERE o.status='closed' AND o.closed_at BETWEEN ? AND ?",
      variables: [Variable<DateTime>(from), Variable<DateTime>(to)],
      readsFrom: {orderItems, orders, products},
    ).getSingle();
    return ProfitSummary(row.read<double>('rev'), row.read<double>('cost'));
  }

  /// Posição de estoque (produtos não compostos, com quantidade e mínimo).
  Future<List<ProductRow>> stockPosition() => (select(products)
        ..where((p) => p.isComposite.equals(false))
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .get();
}
