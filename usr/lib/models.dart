class Portfolio {
  final String investorName;
  final String investmentGoals;
  final double startingCapital;
  final double targetValue;
  final double monthlyContributions;
  final double annualContributions;
  final List<Investment> investments;

  Portfolio({
    required this.investorName,
    required this.investmentGoals,
    required this.startingCapital,
    required this.targetValue,
    required this.monthlyContributions,
    required this.annualContributions,
    required this.investments,
  });

  double get totalInvested =>
      investments.fold(0, (sum, item) => sum + item.totalAmountInvested);

  double get currentTotalValue =>
      investments.fold(0, (sum, item) => sum + item.currentValue);

  double get totalProfitLoss => currentTotalValue - totalInvested;
  
  double get totalDividends =>
      investments.fold(0, (sum, item) => sum + item.dividendsEarned);

  double get totalReturn => totalProfitLoss + totalDividends;
}

class Investment {
  final String assetName;
  final String investmentType;
  final String platform;
  final DateTime investmentDate;
  final double shares;
  final double purchasePrice;
  final double currentMarketPrice;
  final double dividendsEarned;
  final String riskLevel;
  final String notes;

  Investment({
    required this.assetName,
    required this.investmentType,
    required this.platform,
    required this.investmentDate,
    required this.shares,
    required this.purchasePrice,
    required this.currentMarketPrice,
    required this.dividendsEarned,
    required this.riskLevel,
    this.notes = '',
  });

  double get totalAmountInvested => shares * purchasePrice;
  double get currentValue => shares * currentMarketPrice;
  double get profitLoss => currentValue - totalAmountInvested;
  double get profitLossPercentage =>
      totalAmountInvested == 0 ? 0 : (profitLoss / totalAmountInvested) * 100;
  double get totalReturn => profitLoss + dividendsEarned;
}

// Mock Data
final mockPortfolio = Portfolio(
  investorName: 'Alex Carter',
  investmentGoals: 'Retirement & Passive Income',
  startingCapital: 50000,
  targetValue: 500000,
  monthlyContributions: 1500,
  annualContributions: 18000,
  investments: [
    Investment(
      assetName: 'Apple Inc. (AAPL)',
      investmentType: 'Stocks',
      platform: 'Fidelity',
      investmentDate: DateTime(2023, 1, 15),
      shares: 50,
      purchasePrice: 135.0,
      currentMarketPrice: 185.0,
      dividendsEarned: 45.0,
      riskLevel: 'Moderate',
      notes: 'Long-term hold',
    ),
    Investment(
      assetName: 'Vanguard S&P 500 ETF (VOO)',
      investmentType: 'ETFs',
      platform: 'Vanguard',
      investmentDate: DateTime(2022, 6, 10),
      shares: 120,
      purchasePrice: 350.0,
      currentMarketPrice: 410.0,
      dividendsEarned: 320.0,
      riskLevel: 'Low',
      notes: 'Core portfolio holding',
    ),
    Investment(
      assetName: 'Bitcoin (BTC)',
      investmentType: 'Cryptocurrency',
      platform: 'Coinbase',
      investmentDate: DateTime(2023, 10, 5),
      shares: 0.5,
      purchasePrice: 28000.0,
      currentMarketPrice: 42000.0,
      dividendsEarned: 0.0,
      riskLevel: 'High',
      notes: 'Speculative',
    ),
    Investment(
      assetName: 'Realty Income (O)',
      investmentType: 'Real Estate',
      platform: 'Charles Schwab',
      investmentDate: DateTime(2021, 3, 20),
      shares: 200,
      purchasePrice: 65.0,
      currentMarketPrice: 55.0,
      dividendsEarned: 600.0,
      riskLevel: 'Moderate',
      notes: 'Monthly dividends',
    ),
  ],
);
