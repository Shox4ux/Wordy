import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordy_app/ui/res/main_navigation.dart';

import '../res/constants/app_colors.dart';
import '../res/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  void route() async {
    Navigator.pushNamed(
      context,
      RouteNames.main,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Wordy",
              style: AppTextStyles.splashText,
            ),
            Text(
              "Make your world meaningful!",
              style: AppTextStyles.subTextStule,
            ),
          ],
        ),
      ),
    );
  }
}
