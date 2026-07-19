import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';

void main() {
  runApp(const InvestmentTrackerApp());
}

class InvestmentTrackerApp extends StatelessWidget {
  const InvestmentTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Investment Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF001F3F), // Navy Blue
          primary: const Color(0xFF001F3F), // Navy
          secondary: const Color(0xFF2E8B57), // Green
          background: const Color(0xFFF4F6F8), // Off-White
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.black87,
          onSurface: Colors.black87,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001F3F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final percentageFormat = NumberFormat.decimalPatternDigits(decimalDigits: 2);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Tracker'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {},
            tooltip: 'Export / Print',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeader(context, currencyFormat, percentageFormat, isMobile),
              const SizedBox(height: 24),
              Text(
                'Portfolio Assets',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF001F3F),
                    ),
              ),
              const SizedBox(height: 16),
              isMobile 
                  ? _buildMobileAssetList(currencyFormat, percentageFormat)
                  : _buildDesktopAssetTable(currencyFormat, percentageFormat),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF2E8B57), // Green
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Asset'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NumberFormat currencyFormat, NumberFormat percentFormat, bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mockPortfolio.investorName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF001F3F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Goal: ${mockPortfolio.investmentGoals}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001F3F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total Value', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        currencyFormat.format(mockPortfolio.currentTotalValue),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001F3F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _buildSummaryMetric('Starting Capital', currencyFormat.format(mockPortfolio.startingCapital)),
                _buildSummaryMetric('Target Value', currencyFormat.format(mockPortfolio.targetValue)),
                _buildSummaryMetric('Monthly Contrib.', currencyFormat.format(mockPortfolio.monthlyContributions)),
                _buildSummaryMetric(
                  'Total P/L', 
                  currencyFormat.format(mockPortfolio.totalProfitLoss),
                  valueColor: mockPortfolio.totalProfitLoss >= 0 ? const Color(0xFF2E8B57) : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileAssetList(NumberFormat currencyFormat, NumberFormat percentFormat) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockPortfolio.investments.length,
      itemBuilder: (context, index) {
        final asset = mockPortfolio.investments[index];
        final isPositive = asset.profitLoss >= 0;
        final color = isPositive ? const Color(0xFF2E8B57) : Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        asset.assetName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        asset.investmentType,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryMetric('Shares/Units', asset.shares.toString()),
                    _buildSummaryMetric('Current Price', currencyFormat.format(asset.currentMarketPrice)),
                    _buildSummaryMetric('Value', currencyFormat.format(asset.currentValue)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryMetric('Platform', asset.platform),
                    _buildSummaryMetric(
                      'P/L', 
                      '${currencyFormat.format(asset.profitLoss)} (${percentFormat.format(asset.profitLossPercentage)}%)',
                      valueColor: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopAssetTable(NumberFormat currencyFormat, NumberFormat percentFormat) {
    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF001F3F),
          ),
          columns: const [
            DataColumn(label: Text('Asset')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Platform')),
            DataColumn(label: Text('Shares')),
            DataColumn(label: Text('Purchase Price')),
            DataColumn(label: Text('Current Price')),
            DataColumn(label: Text('Total Value')),
            DataColumn(label: Text('P/L')),
            DataColumn(label: Text('Total Return')),
          ],
          rows: mockPortfolio.investments.map((asset) {
            final isPositive = asset.profitLoss >= 0;
            final color = isPositive ? const Color(0xFF2E8B57) : Colors.red;
            return DataRow(
              cells: [
                DataCell(Text(asset.assetName, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(asset.investmentType)),
                DataCell(Text(asset.platform)),
                DataCell(Text(asset.shares.toString())),
                DataCell(Text(currencyFormat.format(asset.purchasePrice))),
                DataCell(Text(currencyFormat.format(asset.currentMarketPrice))),
                DataCell(Text(currencyFormat.format(asset.currentValue))),
                DataCell(
                  Text(
                    '${currencyFormat.format(asset.profitLoss)} (${percentFormat.format(asset.profitLossPercentage)}%)',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(Text(currencyFormat.format(asset.totalReturn))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
