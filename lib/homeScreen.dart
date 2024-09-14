import 'package:apna_gaur/UserFlow/buy_flat.dart';
import 'package:apna_gaur/UserFlow/rent_flow/rent_screen.dart';
import 'package:apna_gaur/UserFlow/rent_flow/upload_listing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // List of items to display in the ListView
  final List<Map<String, dynamic>> options = [
    {"title": "Rent", "color": Colors.blue.shade900},
    {"title": "Buy Flat", "color": Colors.blue.shade900},
    {"title": "Lease", "color": Colors.blue.shade900},
    {"title": "Sell", "color": Colors.blue.shade900},
  ];

  void _handleOptionTap(String title) {
    if (title == "Rent") {
      Get.to(() => RentScreen());
    } else if (title == "Buy Flat") {
      Get.to(() => BuyFlat());
    }
    // You can add more conditions for "Lease" and "Sell" as needed.
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's find your perfect",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Dream Flat",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                height: screenHeight * 0.43,
                child: Image.asset("assets/images/apna_gaur_banner.png"),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Text(
                    "Select from the List :",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.08, // Set a fixed height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return GestureDetector(
                      onTap: () => _handleOptionTap(option["title"]),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10), // Add space between items
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenHeight * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: option["color"], // Use color from the map
                          ),
                          child: Center(
                            child: Text(
                              option["title"], // Use title from the map
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white, // White text for contrast
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(()=>FirstPage());
                    },
                    child: Container(
                      width: screenWidth*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.black,
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text("Upload your Flat", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),),
                      )),
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
