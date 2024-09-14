import 'package:apna_gaur/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apna_gaur/homeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  void nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  void previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void getStartedFunction() {
    Get.offAll(()=>SignUp());
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: onChangedFunction,
            children: <Widget>[
              Container(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(children: [
                  SizedBox(
                    height: screenHeight * 0.10,
                  ),
                  Image.asset("assets/images/onboarding1.png"),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Expanded(
                    child: Text(
                      "Our reputation is an solid as concrete.",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500,),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              )),
              Container(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(children: [
                  SizedBox(
                    height: screenHeight * 0.10,
                  ),
                  Image.asset("assets/images/onboarding2.png"),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Expanded(
                    child: Text(
                      "Real Estate Service At Their Peak.",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500,),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              )),
              Container(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(children: [
                  SizedBox(
                    height: screenHeight * 0.10,
                  ),
                  Image.asset("assets/images/onboarding3.png"),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Expanded(
                    child: Text(
                      "A Premier Real Estate Professional.",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500,),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              )),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.21,
            left: screenWidth * 0.43,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Indicator(
                  positionIndex: 0,
                  currentIndex: currentIndex,
                ),
                SizedBox(width: 10),
                Indicator(
                  positionIndex: 1,
                  currentIndex: currentIndex,
                ),
                SizedBox(width: 10),
                Indicator(
                  positionIndex: 2,
                  currentIndex: currentIndex,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: screenWidth * 0.06,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: currentIndex == 2
                  ? Center(
                      child: InkWell(
                        onTap: getStartedFunction,
                        child: Container(
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                    fontSize: 19, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: previousFunction,
                          child: Container(
                            width: screenWidth * 0.37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                child: Text(
                                  "Previous",
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.06),
                        InkWell(
                          onTap: nextFunction,
                          child: Container(
                            width: screenWidth * 0.37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.white),
                                ),
                              ),
                            ),
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

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const Indicator({
    Key? key,
    required this.currentIndex,
    required this.positionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: positionIndex == currentIndex ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
