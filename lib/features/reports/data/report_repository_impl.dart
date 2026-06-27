import '../../../core/database/daos/report_dao.dart';
import '../domain/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._dao);
  final ReportDao _dao;

  @override
  Future<SalesReport> sales(DateTime from, DateTime to) async {
    final summary = await _dao.salesSummary(from, to);
    final daily = await _dao.salesByDay(from, to);
    return SalesReport(
      summary.orderCount,
      summary.totalSales,
      daily.map((d) => DailyPoint(d.day, d.orderCount, d.total)).toList(),
    );
  }

  @override
  Future<List<TopProductItem>> topProducts(DateTime from, DateTime to) async {
    final rows = await _dao.topProducts(from, to);
    return rows
        .map((r) => TopProductItem(r.name, r.quantity, r.revenue))
        .toList();
  }

  @override
  Future<ProfitReport> profit(DateTime from, DateTime to) async {
    final p = await _dao.profitSummary(from, to);
    return ProfitReport(p.revenue, p.cost);
  }
}
