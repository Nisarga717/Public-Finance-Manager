import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final List<String> lottieAnimations = [
    'assets/animations/landing1.json',
    'assets/animations/landing2.json',
    'assets/animations/landing3.json',
  ];

  final List<String> sliderTexts = [
    'Smart Savings!',
    'Track Expenses!',
    'Grow Wealth!',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % lottieAnimations.length;
        });
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6C56F9),
              Color(0xFF4637F2),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Lottie.asset(lottieAnimations[_currentIndex],
                    width: 300, height: 300),
                SizedBox(height: 10),
                Text(
                  sliderTexts[_currentIndex],
                  style: GoogleFonts.pacifico(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildText('Your'),
                _buildText('Ultimate'),
                _buildText('Financial'),
                _buildText('Companion'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  text: 'Sign up',
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration_screen');
                  },
                ),
                const SizedBox(width: 20),
                _buildButton(
                  text: 'Log in',
                  color: Colors.black,
                  textColor: Colors.white,
                  borderColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login_screen');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.merriweather(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    VoidCallback? onPressed,
    Color? borderColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 2)
              : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.merriweather(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
