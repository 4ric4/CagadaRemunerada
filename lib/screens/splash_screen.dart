import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/splash.png', fit: BoxFit.cover),
          Container(color: Color(0xFF39EE3F).withOpacity(0.4)),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double logoWidth = constraints.maxWidth * 0.7;
                      double logoHeight = logoWidth * (424 / 428);
                      return Image.asset(
                        'assets/logo.png',
                        width: logoWidth,
                        height: logoHeight,
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Dot(),
                      SizedBox(width: 8),
                      Dot(),
                      SizedBox(width: 8),
                      Dot(),
                    ],
                  ),
                  SizedBox(height: isMobile ? 30 : 40),
                  Text(
                    'Ganho Diário',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatefulWidget {
  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Icon(Icons.circle, color: Colors.white, size: 12),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
