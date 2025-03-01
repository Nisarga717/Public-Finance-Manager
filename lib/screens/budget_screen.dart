import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.black87,
          ],
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
                    Text(
                      "Balance",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "\$367.30",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
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
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                toY: 400,
                                gradient: LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
                              )
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                toY: 700,
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.red],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
                              )
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                toY: 500,
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.teal],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
                                borderRadius: BorderRadius.circular(8),
                              )
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(
                                toY: 900,
                                gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.purpleAccent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
                              )
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(
                                toY: 600,
                                gradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.orange],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
                              )
                            ]),
                            BarChartGroupData(x: 5, barRods: [
                              BarChartRodData(
                                toY: 300,
                                gradient: LinearGradient(
                                  colors: [Colors.lightBlue, Colors.blueAccent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 16,
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
            ],
          ),
        ),
      ),
    );
  }
}
