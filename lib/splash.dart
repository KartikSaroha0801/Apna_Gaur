import 'package:apna_gaur/OnBoarding/onboarding.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:apna_gaur/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      Get.to(OnboardingScreen());
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(child: Image.asset("assets/images/Apna Gaur Logo.png"), borderRadius: BorderRadius.circular(300),),
      ),
    );
  }
}