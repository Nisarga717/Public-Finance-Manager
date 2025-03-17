import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HorizonScreen extends StatefulWidget {
  const HorizonScreen({Key? key}) : super(key: key);

  @override
  _HorizonScreenState createState() => _HorizonScreenState();
}

class _HorizonScreenState extends State<HorizonScreen> {
  @override
  void initState() {
    super.initState();
    _initAlanVoice();
  }

  void _initAlanVoice() {
    AlanVoice.addButton("YOUR_ALAN_KEY",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    if (command['command'] == 'navigate') {
      _navigateToScreen(command['target']);
    }
  }

  void _navigateToScreen(String screenName) {
    Vibrate.feedback(FeedbackType.medium);

    final Map<String, Widget> screens = {
      'graph': const HolographicGraphScreen(),
      'scenarios': const PredictiveScenariosScreen(),
      'fitness': const FinancialFitnessScreen(),
      'defi': const DeFiSustainabilityScreen(),
    };

    if (screens.containsKey(screenName)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screens[screenName]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildModuleCard("Holographic Graph", Icons.area_chart,
                          Colors.blueAccent, () => _navigateToScreen('graph')),
                      _buildModuleCard(
                          "Predictive Scenarios",
                          Icons.timeline,
                          Colors.purpleAccent,
                          () => _navigateToScreen('scenarios')),
                      _buildModuleCard(
                          "Financial Fitness",
                          Icons.fitness_center,
                          Colors.greenAccent,
                          () => _navigateToScreen('fitness')),
                      _buildModuleCard("DeFi & Sustainability", Icons.eco,
                          Colors.orangeAccent, () => _navigateToScreen('defi')),
                    ]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildActivityList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AlanVoice.activate(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.mic),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.4),
            Colors.purpleAccent.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildModuleCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color).animate().fade().scale(),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: 0.1, end: 0);
  }

  Widget _buildActivityList() {
    // Define activities with explicit types for each field
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Investment Growth',
        'subtitle': '+2.3% in tech sector',
        'icon': Icons.trending_up as IconData,
        'color': Colors.green as Color,
      },
      {
        'title': 'Savings Goal',
        'subtitle': '85% completed',
        'icon': Icons.savings as IconData,
        'color': Colors.blue as Color,
      },
      {
        'title': 'Market Alert',
        'subtitle': 'Crypto volatility',
        'icon': Icons.warning as IconData,
        'color': Colors.orange as Color,
      },
    ];

    return Column(
      children: activities
          .map((activity) => Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {},
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (activity['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(activity['icon'] as IconData,
                            color: activity['color'] as Color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity['title'] as String,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            Text(activity['subtitle'] as String,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// Module screens (create separate dart files for each)
class HolographicGraphScreen extends StatelessWidget {
  const HolographicGraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Holographic Graph'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: true,
                // Changed from 'colors' to 'color' to match the updated API
                color: Colors.blue,
                barWidth: 4,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  // Changed from 'colors' to 'color' to match the updated API
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictiveScenariosScreen extends StatelessWidget {
  const PredictiveScenariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Predictive Scenarios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Predictive Scenarios Screen',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class FinancialFitnessScreen extends StatelessWidget {
  const FinancialFitnessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Financial Fitness'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Financial Fitness Screen',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class DeFiSustainabilityScreen extends StatelessWidget {
  const DeFiSustainabilityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('DeFi & Sustainability'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('DeFi & Sustainability Screen',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
