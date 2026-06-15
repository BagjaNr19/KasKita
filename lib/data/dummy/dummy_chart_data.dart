class ChartPoint {
  final String label;
  final double income;
  final double expense;

  const ChartPoint({
    required this.label,
    required this.income,
    required this.expense,
  });

  double get balance => income - expense;
}

class DummyChartData {
  /// Data pemasukan vs pengeluaran 6 bulan terakhir
  static const List<ChartPoint> monthlyData = [
    ChartPoint(label: 'Jan', income: 1100000, expense: 950000),
    ChartPoint(label: 'Feb', income: 1200000, expense: 870000),
    ChartPoint(label: 'Mar', income: 1150000, expense: 1050000),
    ChartPoint(label: 'Apr', income: 1150000, expense: 720000),
    ChartPoint(label: 'Mei', income: 1700000, expense: 1000000),
    ChartPoint(label: 'Jun', income: 1250000, expense: 1150000),
  ];

  /// Saldo kas kumulatif per bulan
  static List<double> get balanceTrend {
    double running = 2000000; // saldo awal
    return monthlyData.map((d) {
      running += d.income - d.expense;
      return running;
    }).toList();
  }

  static double get currentBalance {
    return balanceTrend.last;
  }

  static double get totalIncomeThisMonth => monthlyData.last.income;
  static double get totalExpenseThisMonth => monthlyData.last.expense;
}
