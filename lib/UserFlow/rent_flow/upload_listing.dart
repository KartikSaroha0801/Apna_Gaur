import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadListing extends StatefulWidget {
  const UploadListing({super.key});

  @override
  State<UploadListing> createState() => _UploadListingState();
}

class _UploadListingState extends State<UploadListing> {

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  TextEditingController _societyController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

 

  @override
  void dispose() {
    // TODO: implement dispose
    _societyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Please upload your listing"),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15,),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Enter Your Society Name: ", style: TextStyle(color: Color(0xFF8fa5a4), fontSize: 14),),
                ],
              ),
              SizedBox(height: screenHeight*0.013,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xFFced3cc),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _societyController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.027,),
              Row(
                children: [
                  Text("Please Enter Carpet Area in Sq Ft", style: TextStyle(color: Color(0xFF8fa5a4), fontSize: 14),),
                ],
              ),
              SizedBox(height: screenHeight*0.013,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xFFced3cc),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _societyController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.027,),
              Container(
                height: screenHeight*0.05,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Select BHK: "),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("1"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("2"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("2+1"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("3"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("3+1"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("4"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("4+1"),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(3),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          ),
        ),
    );
  }
}
