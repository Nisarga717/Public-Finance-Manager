import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isDarkMode = false;
  bool isBiometricEnabled = false;

  // Enhanced theme constants
  static final _colors = _AppColors();
  static final _styles = _AppStyles();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final data =
        await Provider.of<AuthService>(context, listen: false).getUserData();
    if (mounted)
      setState(() {
        userData = data;
        isLoading = false;
      });
  }

  Widget _buildCard({required Widget child, double elevation = 8}) {
    return Card(
      elevation: elevation,
      shadowColor: _colors.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          gradient: _colors.cardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _colors.accent.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Financial Overview', style: _styles.headerStyle),
              IconButton(
                icon: Icon(LucideIcons.trendingUp, color: _colors.primary),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Total Balance', '\$24,500', LucideIcons.wallet)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      'Monthly Savings', '\$3,200', LucideIcons.piggyBank)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                PieChart(PieChartData(
                  sections: _buildChartSections(),
                  sectionsSpace: 5,
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                )),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.pieChart,
                        color: _colors.primary, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX();
  }

  List<PieChartSectionData> _buildChartSections() {
    final sectionStyle = GoogleFonts.spaceMono(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return [
      PieChartSectionData(
        value: 35,
        title: 'Income',
        color: _colors.chartColor1,
        radius: 80,
        titleStyle: sectionStyle,
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      PieChartSectionData(
        value: 65,
        title: 'Expenses',
        color: _colors.chartColor2,
        radius: 70,
        titleStyle: sectionStyle,
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
    ];
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'icon': LucideIcons.calculator, 'label': 'Budget'},
      {'icon': LucideIcons.creditCard, 'label': 'Cards'},
      {'icon': LucideIcons.barChart2, 'label': 'Analytics'},
      {'icon': LucideIcons.shield, 'label': 'Security'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: _colors.actionGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _colors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(actions[index]['icon'] as IconData,
                        color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                ).animate().scale(duration: 200.ms, curve: Curves.easeInOut),
                const SizedBox(height: 8),
                Text(actions[index]['label'] as String,
                    style: _styles.labelStyle),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _colors.statCardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _colors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _colors.primary, size: 28),
          const SizedBox(height: 12),
          Text(title, style: _styles.labelStyle),
          const SizedBox(height: 4),
          Text(value, style: _styles.valueStyle),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'type': 'expense',
        'title': 'Netflix Subscription',
        'amount': '-\$14.99'
      },
      {'type': 'income', 'title': 'Salary Deposit', 'amount': '+\$4,500'},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: _styles.headerStyle),
          const SizedBox(height: 16),
          ...activities.map((activity) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _colors.accent.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          activity['type'] == 'income'
                              ? LucideIcons.arrowUpRight
                              : LucideIcons.arrowDownLeft,
                          color: activity['type'] == 'income'
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Text(activity['title']!, style: _styles.activityStyle),
                      ],
                    ),
                    Text(
                      activity['amount']!,
                      style: _styles.amountStyle.copyWith(
                        color: activity['type'] == 'income'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("User data not found"))
              : Container(
                  decoration:
                      BoxDecoration(gradient: _colors.backgroundGradient),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildProfileHeader(),
                                const SizedBox(height: 32),
                                _buildFinancialOverview(),
                                const SizedBox(height: 24),
                                _buildQuickActions(),
                                const SizedBox(height: 24),
                                _buildRecentActivity(),
                                const SizedBox(height: 24),
                                _buildSettingsSection(),
                              ],
                            ),
                          ),
                        ),
                        _buildGoHomeButton(), // Add Go Home button here
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _colors.profileGradient,
            boxShadow: [
              BoxShadow(
                color: _colors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          backgroundImage: userData!["profilePic"] != null
              ? NetworkImage(userData!["profilePic"])
              : null,
          child: userData!["profilePic"] == null
              ? Icon(LucideIcons.user, size: 50, color: _colors.primary)
              : null,
        ),
      ],
    );
  }

  Widget _buildGoHomeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home'); // Navigate to Home
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _colors.primary, // Use your theme primary color
            foregroundColor: Colors.white, // White text
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
          child: const Text('Go Home', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return _buildCard(
      child: Column(
        children: [
          ListTile(
            leading: Icon(LucideIcons.settings, color: _colors.primary),
            title: Text('Settings', style: _styles.headerStyle),
          ),
          SwitchListTile(
            secondary: Icon(LucideIcons.moon, color: _colors.primary),
            title: Text('Dark Mode', style: _styles.settingStyle),
            value: isDarkMode,
            activeColor: _colors.primary,
            onChanged: (value) => setState(() => isDarkMode = value),
          ),
          SwitchListTile(
            secondary: Icon(LucideIcons.fingerprint, color: _colors.primary),
            title: Text('Biometric Auth', style: _styles.settingStyle),
            value: isBiometricEnabled,
            activeColor: _colors.primary,
            onChanged: (value) => setState(() => isBiometricEnabled = value),
          ),
        ],
      ),
    );
  }
}

class _AppColors {
  // Modern color palette
  final primary = const Color(0xFF7C3AED); // Vibrant purple
  final secondary = const Color(0xFF6D28D9); // Deep purple
  final accent = const Color(0xFFA78BFA); // Light purple
  final dark = const Color(0xFF4C1D95); // Dark purple

  // Chart colors
  final chartColor1 = const Color(0xFF22D3EE); // Cyan
  final chartColor2 = const Color(0xFFF472B6); // Pink

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFF5F3FF), // Very light purple
          Colors.white,
          Colors.white,
        ],
      );

  LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, const Color(0xFFF5F3FF)],
      );

  LinearGradient get statCardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFF5F3FF),
          const Color(0xFFEDE9FE),
        ],
      );

  LinearGradient get actionGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, secondary],
      );

  LinearGradient get profileGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, primary],
      );
}

class _AppStyles {
  final headerStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF4C1D95),
  );

  final labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF6D28D9),
  );

  final valueStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF7C3AED),
  );

  final settingStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: const Color(0xFF4C1D95),
  );

  final activityStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF4C1D95),
  );

  final amountStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
