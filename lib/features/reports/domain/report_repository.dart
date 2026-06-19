class DailyPoint {
  DailyPoint(this.day, this.count, this.total);
  final String day;
  final int count;
  final double total;
}

class SalesReport {
  SalesReport(this.orderCount, this.total, this.daily);
  final int orderCount;
  final double total;
  final List<DailyPoint> daily;
}

class TopProductItem {
  TopProductItem(this.name, this.quantity, this.revenue);
  final String name;
  final double quantity;
  final double revenue;
}

class ProfitReport {
  ProfitReport(this.revenue, this.cost);
  final double revenue;
  final double cost;
  double get profit => revenue - cost;
  double get margin => revenue == 0 ? 0 : profit / revenue * 100;
}

class StockItem {
  StockItem(this.name, this.stock, this.minStock);
  final String name;
  final double stock;
  final double minStock;
  bool get isLow => minStock > 0 && stock <= minStock;
}

abstract class ReportRepository {
  Future<SalesReport> sales(DateTime from, DateTime to);
  Future<List<TopProductItem>> topProducts(DateTime from, DateTime to);
  Future<ProfitReport> profit(DateTime from, DateTime to);
  Future<List<StockItem>> stock();
}
