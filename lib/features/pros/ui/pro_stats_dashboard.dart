import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

/// PG-17: Pro statistics dashboard with comprehensive performance metrics
class ProStatsDashboard extends ConsumerStatefulWidget {
  const ProStatsDashboard({super.key});

  @override
  ConsumerState<ProStatsDashboard> createState() => _ProStatsDashboardState();
}

class _ProStatsDashboardState extends ConsumerState<ProStatsDashboard> {
  String _selectedPeriod = '30d';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Meine Statistiken'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: '7d', child: Text('Letzte 7 Tage')),
              PopupMenuItem(value: '30d', child: Text('Letzte 30 Tage')),
              PopupMenuItem(value: '90d', child: Text('Letzte 3 Monate')),
              PopupMenuItem(value: 'all', child: Text('Alle Zeit')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOverviewCards(),
            const SizedBox(height: 20),
            _buildEarningsChart(),
            const SizedBox(height: 20),
            _buildJobCompletionChart(),
            const SizedBox(height: 20),
            _buildCategoryPerformance(),
            const SizedBox(height: 20),
            _buildRatingsTrend(),
            const SizedBox(height: 20),
            _buildPerformanceMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          title: 'Verdienst',
          value: '€1,247',
          subtitle: '+€124 vs. letzten Monat',
          icon: Icons.euro,
          color: Colors.green,
          trend: 0.11,
        ),
        _buildStatCard(
          title: 'Jobs erledigt',
          value: '23',
          subtitle: '+3 vs. letzten Monat',
          icon: Icons.check_circle,
          color: Colors.blue,
          trend: 0.15,
        ),
        _buildStatCard(
          title: 'Durchschnittsbewertung',
          value: '4.8',
          subtitle: '142 Bewertungen',
          icon: Icons.star,
          color: Colors.orange,
          trend: 0.02,
        ),
        _buildStatCard(
          title: 'Response Rate',
          value: '94%',
          subtitle: 'Anfragen in <2h beantwortet',
          icon: Icons.speed,
          color: Colors.purple,
          trend: 0.05,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double trend,
  }) {
    final isPositive = trend >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${(trend * 100).abs().toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💰 Verdienst-Entwicklung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text('€${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const weeks = ['W1', 'W2', 'W3', 'W4'];
                          return Text(weeks[value.toInt() % weeks.length]);
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 180),
                        FlSpot(1, 240),
                        FlSpot(2, 320),
                        FlSpot(3, 410),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCompletionChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📋 Job-Completion Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 85,
                            title: '85%',
                            color: Colors.green,
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: 10,
                            title: '10%',
                            color: Colors.orange,
                            radius: 50,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: 5,
                            title: '5%',
                            color: Colors.red,
                            radius: 40,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('Erfolgreich', Colors.green, '85%'),
                      _buildLegendItem('Storniert', Colors.orange, '10%'),
                      _buildLegendItem('Probleme', Colors.red, '5%'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPerformance() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏠 Performance nach Kategorie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildCategoryBar('S (≤60m²)', 0.8, '12 Jobs', '€640'),
            _buildCategoryBar('M (61-120m²)', 0.9, '18 Jobs', '€980'),
            _buildCategoryBar('L (121-200m²)', 0.7, '8 Jobs', '€520'),
            _buildCategoryBar('XL (201-250m²)', 0.6, '4 Jobs', '€340'),
            _buildCategoryBar('GT250 (>250m²)', 0.5, '2 Jobs', '€180'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(
    String category,
    double performance,
    String jobCount,
    String earnings,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Text(
                    jobCount,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    earnings,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: performance,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              performance >= 0.8
                  ? Colors.green
                  : performance >= 0.6
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(performance * 100).toInt()}% Erfolgsrate',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsTrend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⭐ Bewertungen & Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < 4
                                ? Colors.orange
                                : Colors.grey.shade300,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '142 Bewertungen',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.75),
                      _buildRatingBar(4, 0.15),
                      _buildRatingBar(3, 0.07),
                      _buildRatingBar(2, 0.02),
                      _buildRatingBar(1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Häufige Bewertungs-Tags:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildTagChip('Pünktlich', Colors.green),
                _buildTagChip('Gründlich', Colors.blue),
                _buildTagChip('Freundlich', Colors.purple),
                _buildTagChip('Zuverlässig', Colors.orange),
                _buildTagChip('Sauber', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars'),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📈 Performance-Kennzahlen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricTile(
                  'Request Response Time',
                  '1h 24m',
                  Icons.speed,
                  Colors.green,
                  'Durchschnitt',
                ),
                _buildMetricTile(
                  'Acceptance Rate',
                  '78%',
                  Icons.thumb_up,
                  Colors.blue,
                  'Anfragen angenommen',
                ),
                _buildMetricTile(
                  'On-time Completion',
                  '96%',
                  Icons.schedule,
                  Colors.purple,
                  'Pünktlich erledigt',
                ),
                _buildMetricTile(
                  'Customer Retention',
                  '64%',
                  Icons.repeat,
                  Colors.orange,
                  'Wiederkehrende Kunden',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
