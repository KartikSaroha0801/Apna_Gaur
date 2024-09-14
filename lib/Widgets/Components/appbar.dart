import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBAR extends StatefulWidget {
  String title;
  AppBAR({super.key, required this.title});

  @override
  State<AppBAR> createState() => _AppBARState();
}

class _AppBARState extends State<AppBAR> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
         boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.25), // Replace with your preferred color
                      offset: Offset(0, 4), // Horizontal and Vertical offset
                      blurRadius: 8, // The blur radius
                      spreadRadius: 5, // The spread radius
                      blurStyle: BlurStyle.normal, // The blur style
                    ),
         ],
        // border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.25), // Replace with your preferred color
                      offset: Offset(0, 4), // Horizontal and Vertical offset
                      blurRadius: 8, // The blur radius
                      spreadRadius: 5, // The spread radius
                      blurStyle: BlurStyle.normal, // The blur style
                    ),
                  ],
                ),
                child: Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                ),
              ),
            ),
            Spacer(),
            Text(widget.title, style: TextStyle( fontSize: 16, color: Colors.black,),),
            Spacer(),
            SizedBox(width: 45,),
          ],
        ),
      ),
    );
  }
}
