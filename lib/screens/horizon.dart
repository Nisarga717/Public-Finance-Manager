import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:confetti/confetti.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:web3dart/web3dart.dart';

class HorizonScreen extends StatefulWidget {
  @override
  _HorizonScreenState createState() => _HorizonScreenState();
}

class _HorizonScreenState extends State<HorizonScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
            children: [
              _buildHolographicGraph(),
              _buildPredictiveScenarios(),
              _buildFinancialFitnessGamification(),
              _buildDeFiSustainabilityHub(),
            ],
          ),
          _buildVoiceAssistantButton(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.4),
            Colors.purpleAccent.withOpacity(0.4)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.2)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Container(),
      ),
    );
  }

  Widget _buildHolographicGraph() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "3D Financial Graph (Placeholder)",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPredictiveScenarios() {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Predictive Scenarios Timeline (2024 → 2030)",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialFitnessGamification() {
    return Container(
      height: 120,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Financial Fitness Score: 85/100",
                style: TextStyle(color: Colors.white)),
            ElevatedButton(
              onPressed: () {
                Vibrate.feedback(FeedbackType.success);
              },
              child: Text("Start Challenge"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeFiSustainabilityHub() {
    return Container(
      height: 140,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          "DeFi & Sustainability Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildVoiceAssistantButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          AlanVoice.playText("How can I assist with your finances?");
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.mic),
      ),
    );
  }
}
