import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Budget & Planning",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 💰 Balance Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance",
                        style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text("\$367.30",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    // 📊 Bar Chart
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 1500,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 28),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  final titles = [
                                    'May',
                                    'June',
                                    'July',
                                    'Aug',
                                    'Sep',
                                    'Oct'
                                  ];
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                        titles[value.toInt() % titles.length],
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 12)),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            for (int i = 0; i < 6; i++)
                              BarChartGroupData(x: i, barRods: [
                                BarChartRodData(
                                  toY: (400 + i * 100).toDouble(),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.primaries[
                                          i % Colors.primaries.length],
                                      Colors.primaries[
                                          (i + 2) % Colors.primaries.length]
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  width: 16,
                                  borderRadius: BorderRadius.circular(8),
                                )
                              ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 🔄 Recurring Expenses + Investment Suggestions
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text("Complete the registration",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            lineHeight: 8,
                            percent: 0.74,
                            backgroundColor: Colors.white24,
                            progressColor: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("74%",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text("Explore ways to invest",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Icon(FontAwesomeIcons.chartPie,
                              color: Colors.white, size: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // ➕ Add Expense Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.white, size: 36),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Add a new expense",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Open add expense modal
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ✨ Floating Action Button
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          icon: Icon(Icons.add, color: Colors.white),
          label: Text("New Expense",
              style: GoogleFonts.poppins(color: Colors.white)),
          onPressed: () {
            // Open add expense modal
          },
        ),
      ),
    );
  }
}
