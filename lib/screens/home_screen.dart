import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import 'budget_screen.dart';
import 'profile_screen.dart';
import 'horizon.dart';

void main() {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app and wrap with ChangeNotifierProvider to provide AuthService
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(), // Provide AuthService here
      child: FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Color(0xFF0A0F1C),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0F1C),
              Color(0xFF1A1F2C),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Finance Hub',
                    style: GoogleFonts.spaceMono(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  Flexible(
                      child:
                          _buildProfileAvatar(context)), // ✅ Prevents overflow
                  const SizedBox(width: 20),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ModernBalanceCard(),
                      SizedBox(height: 25),
                      QuickActionsGrid(),
                      SizedBox(height: 25),
                      SpendingAnalytics(),
                      SizedBox(height: 25),
                      RecentTransactionsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GlassBottomBar(controller: _tabController),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;

    return GestureDetector(
      onTap: () {
        try {
          Navigator.pushNamed(context, '/profile');
        } catch (e) {
          print("Navigation error: $e");
        }
      },
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF6C56F9), Color(0xFF4637F2)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C56F9).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: user != null
              ? FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get()
              : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              );
            }

            final profilePicUrl = snapshot.data!.get('profilePic') as String?;
            return CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              backgroundImage: profilePicUrl != null && profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl)
                  : null,
              child: profilePicUrl == null || profilePicUrl.isEmpty
                  ? const Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class ModernBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Increased height to accommodate content
      height: 220, // Adjusted from 200
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C56F9),
            Color(0xFF4637F2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C56F9).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 15), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Balance',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.chartLine,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '+15.3%',
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12), // Reduced spacing
                Text(
                  '\$2,548.50',
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(child: SizedBox()), // Flexible spacing
                Container(
                  margin: EdgeInsets.only(bottom: 10), // Added bottom margin
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBalanceMetric(
                        icon: FontAwesomeIcons.arrowUp,
                        label: 'Income',
                        amount: '+\$3.5K',
                        color: Colors.greenAccent,
                      ),
                      _buildBalanceMetric(
                        icon: FontAwesomeIcons.arrowDown,
                        label: 'Expenses',
                        amount: '-\$1.2K',
                        color: Colors.pinkAccent,
                      ),
                      _buildBalanceMetric(
                        icon: FontAwesomeIcons.wallet,
                        label: 'Savings',
                        amount: '\$850',
                        color: Colors.amberAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceMetric({
    required IconData icon,
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Added to prevent expansion
      children: [
        Container(
          padding: EdgeInsets.all(8), // Reduced padding
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            icon,
            size: 14, // Reduced size
            color: color,
          ),
        ),
        SizedBox(height: 6), // Reduced spacing
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.spaceMono(
            fontSize: 13, // Reduced font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class QuickActionsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> actions = [
    {
      'icon': FontAwesomeIcons.moneyBillTransfer,
      'label': 'Transfer',
      'color': Color(0xFF6C56F9),
    },
    {
      'icon': FontAwesomeIcons.creditCard,
      'label': 'Cards',
      'color': Color(0xFFFF6B6B),
    },
    {
      'icon': FontAwesomeIcons.piggyBank,
      'label': 'Savings',
      'color': Color(0xFF4ECDC4),
    },
    {
      'icon': FontAwesomeIcons.chartPie,
      'label': 'Analytics',
      'color': Color(0xFFFFBE0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionItem(actions[index]);
      },
    );
  }

  Widget _buildActionItem(Map<String, dynamic> action) {
    return Container(
      decoration: BoxDecoration(
        color: action['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: action['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: action['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              action['icon'],
              color: action['color'],
              size: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            action['label'],
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Analytics',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 35,
                    title: '35%',
                    color: Color(0xFF6C56F9),
                    radius: 60,
                    titleStyle: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: '25%',
                    color: Color(0xFFFF6B6B),
                    radius: 60,
                    titleStyle: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: '20%',
                    color: Color(0xFF4ECDC4),
                    radius: 60,
                    titleStyle: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: '20%',
                    color: Color(0xFFFFBE0B),
                    radius: 60,
                    titleStyle: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final categories = [
      {'label': 'Shopping', 'color': Color(0xFF6C56F9)},
      {'label': 'Bills', 'color': Color(0xFFFF6B6B)},
      {'label': 'Food', 'color': Color(0xFF4ECDC4)},
      {'label': 'Others', 'color': Color(0xFFFFBE0B)},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: categories.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: category['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(
              category['label'] as String,
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'icon': FontAwesomeIcons.bagShopping,
      'name': 'Shopping Mall',
      'date': '2h ago',
      'amount': '-\$85.00',
      'color': Color(0xFF6C56F9),
    },
    {
      'icon': FontAwesomeIcons.burger,
      'name': 'Restaurant',
      'date': '5h ago',
      'amount': '-\$35.50',
      'color': Color(0xFFFF6B6B),
    },
    {
      'icon': FontAwesomeIcons.taxi,
      'name': 'Uber Ride',
      'date': '1d ago',
      'amount': '-\$25.00',
      'color': Color(0xFF4ECDC4),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        ...transactions
            .map((transaction) => _buildTransactionItem(transaction)),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: FaIcon(
              transaction['icon'],
              color: transaction['color'],
              size: 20,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['name'],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  transaction['date'],
                  style: GoogleFonts.outfit(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction['amount'],
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6C56F9),
            Color(0xFF4637F2),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C56F9).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class GlassBottomBar extends StatelessWidget {
  final TabController controller;

  GlassBottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          child: TabBar(
            controller: controller,
            onTap: (index) {
              // Navigate to the corresponding screen based on tab index
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BudgetScreen()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HorizonScreen()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                  break;
              }
            },
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF6C56F9),
                  width: 2,
                ),
              ),
            ),
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.house)),
              Tab(icon: FaIcon(FontAwesomeIcons.chartPie)),
              Tab(icon: FaIcon(FontAwesomeIcons.wallet)),
              Tab(icon: FaIcon(FontAwesomeIcons.user)),
            ],
          ),
        ),
      ),
    );
  }
}
